LinkLuaModifier("modifier_lich_blast_cd", "abilities/npc_lich_blast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lich_blast_thinker", "abilities/npc_lich_blast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lich_blast_targets", "abilities/npc_lich_blast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lich_blast_b", "abilities/npc_lich_blast", LUA_MODIFIER_MOTION_NONE)


npc_lich_blast = class({})

function npc_lich_blast:OnSpellStart()

    if not IsServer() then
        return
    end

    if self:GetCaster():HasModifier("modifier_lich_blast_b") then 
      self:GetCaster():RemoveModifierByName("modifier_lich_blast_b")
    else
      self:GetCaster():AddNewModifier(self:GetCaster(), self, ("modifier_lich_blast_b"), {}) 
    end
    

    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lich_blast_cd", {duration = self:GetCooldownTimeRemaining()})
    self.target = self:GetCursorTarget()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lich_blast_targets", { target = self.target:entindex()})
    
   

end


modifier_lich_blast_targets = class({})
function modifier_lich_blast_targets:IsHidden() return true end
function modifier_lich_blast_targets:IsPurgable() return false end
function modifier_lich_blast_targets:OnCreated(table)
if not IsServer() then return end

  self.targets = {}
  local i = 0

  local random = self:GetCaster():HasModifier("modifier_lich_blast_b")
  local pos = Vector(0,0,0)



  self.delay = 0
  self.number = 0

  if random  then 
     self.delay = 0.1
     self.number = 5
  end
  if not random then 
     self.delay = 0
     self.number = 10
  end
  self.target = EntIndexToHScript(table.target)

  local line_position = self:GetCaster():GetAbsOrigin() + Vector(1) * (self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D()
  local qangle_rotation_rate = 360 / self.number

  local random_i = RollPseudoRandomPercentage(50,14,self:GetParent())


    for i = 1,self.number do

      if random then 
        local n = 0
        if random_i then 
          n = self.number - i + 1
        else 
          n = i
        end
        pos = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*n*self:GetAbility():GetSpecialValueFor("radius")
      end

      if not random then 
    
        local qangle = QAngle(0, qangle_rotation_rate, 0)
        line_position = RotatePosition(self:GetCaster():GetAbsOrigin() , qangle, line_position)
        pos = line_position
      end

      self.targets[i] = pos
      
   end
 

  self.count = 0


  self:StartIntervalThink(self.delay)
  self:OnIntervalThink()
end



function modifier_lich_blast_targets:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + 1

 CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_lich_blast_thinker", {duration = self:GetAbility():GetSpecialValueFor("delay_blast")}, self.targets[self.count], self:GetCaster():GetTeamNumber(), false)
if self.count == self.number then 
  self:Destroy()
  return -1
end

end

modifier_lich_blast_thinker = class({})

function modifier_lich_blast_thinker:IsHidden() return false end

function modifier_lich_blast_thinker:IsPurgable() return false end

function modifier_lich_blast_thinker:OnCreated(table)
if not IsServer() then return end
  self.radius = self:GetAbility():GetSpecialValueFor("radius")
  local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"
  self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent())
  ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius) )
  ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )

end


function modifier_lich_blast_thinker:OnDestroy(table)
if not IsServer() then return end
  
  ParticleManager:DestroyParticle( self.effect_cast, true )
  ParticleManager:ReleaseParticleIndex( self.effect_cast )

    self:GetParent():EmitSound("Ability.FrostNova")
    local seed_particle = ParticleManager:CreateParticle("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(seed_particle, 0, self:GetParent():GetAbsOrigin())
  ParticleManager:SetParticleControl(seed_particle, 1, self:GetParent():GetAbsOrigin())
  ParticleManager:SetParticleControl(seed_particle, 2, self:GetParent():GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(seed_particle)

  local  enemy_for_ability = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE , FIND_CLOSEST, false)
   for _,i in ipairs(enemy_for_ability) do
    if not i:IsMagicImmune() then 

      local damageTable = {victim = i,  damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, attacker = self:GetCaster(), ability = self:GetAbility()}
      local actualy_damage = ApplyDamage(damageTable)
   
    end

   end
   


end






modifier_lich_blast_cd = class({})

function modifier_lich_blast_cd:IsHidden() return false end
function modifier_lich_blast_cd:IsPurgable() return false end


modifier_lich_blast_b = class({})

function modifier_lich_blast_b:IsHidden() return true end
function modifier_lich_blast_b:IsPurgable() return false end

