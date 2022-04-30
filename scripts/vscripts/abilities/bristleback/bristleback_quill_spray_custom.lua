LinkLuaModifier("modifier_custom_bristleback_quillspray_thinker", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_count", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_tracker", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_legendary", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_lowhp_tracker", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_proc_slow", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)



bristleback_quill_spray_custom              = class({})

bristleback_quill_spray_custom.damage_init = 0
bristleback_quill_spray_custom.damage_inc = 5

bristleback_quill_spray_custom.legendary_cd = 2
bristleback_quill_spray_custom.legendary_health = 0.08

bristleback_quill_spray_custom.proc_chance = 25
bristleback_quill_spray_custom.proc_slow = -80
bristleback_quill_spray_custom.proc_duration = 1
bristleback_quill_spray_custom.proc_damage_init = 0
bristleback_quill_spray_custom.proc_damage_inc = 50

bristleback_quill_spray_custom.double_init = 5
bristleback_quill_spray_custom.double_inc = 10

bristleback_quill_spray_custom.heal_init = 0
bristleback_quill_spray_custom.heal_inc = 0.05
bristleback_quill_spray_custom.heal_creep = 2

bristleback_quill_spray_custom.lowhp_health = 40
bristleback_quill_spray_custom.lowhp_cd = 2

bristleback_quill_spray_custom.reduce = -2
bristleback_quill_spray_custom.reduce_duration = 20


function bristleback_quill_spray_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_bristle_spray_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AUTOCAST end
 return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end


function bristleback_quill_spray_custom:GetIntrinsicModifierName()  return "modifier_custom_bristleback_quill_spray_tracker" end


function bristleback_quill_spray_custom:GetCooldown(iLevel)
local cd = 0
if self:GetCaster():HasModifier("modifier_bristle_spray_lowhp") and self:GetCaster():GetHealthPercent() <= self.lowhp_health then 
    cd = self.lowhp_cd
  else 
    cd = self.BaseClass.GetCooldown(self, iLevel)
end
if self:GetCaster():HasModifier("modifier_bristle_spray_legendary") and self:GetCaster():HasModifier("modifier_custom_bristleback_quill_spray_legendary") then 
  cd = cd/self.legendary_cd
end
return cd

end


function bristleback_quill_spray_custom:OnSpellStart()
if self:GetCaster():HasModifier("modifier_bristle_spray_legendary") and self:GetCaster():HasModifier("modifier_custom_bristleback_quill_spray_legendary") then 
  self:GetCaster():SetHealth(math.max(1,self:GetCaster():GetHealth() - self:GetCaster():GetHealth()*self.legendary_health))
end

  self:MakeSpray()

end 




function bristleback_quill_spray_custom:MakeSpray(location, double)

  self.caster = self:GetCaster()
  self.radius         = self:GetSpecialValueFor("radius") 

  self.projectile_speed   = self:GetSpecialValueFor("projectile_speed")
  
  self.duration       = self.radius / self.projectile_speed
  

  if location == nil then 
    self.location = self:GetCaster():GetAbsOrigin()
  else  
    self.location = location
  end

  if not IsServer() then return end


  if location == nil then 
    self.caster:FadeGesture(ACT_DOTA_CAST_ABILITY_2)
    self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
  end



  CreateModifierThinker(self.caster, self, "modifier_custom_bristleback_quillspray_thinker", {duration = self.duration}, self.location, self.caster:GetTeamNumber(), false)
  
  self.caster:EmitSound("Hero_Bristleback.QuillSpray.Cast")

  if self:GetCaster():HasModifier("modifier_bristle_spray_double") and (double == true or double == nil)  then 
    local chance = self.double_init + self.double_inc*self:GetCaster():GetUpgradeStack("modifier_bristle_spray_double")

    local random = RollPseudoRandomPercentage(chance,75,self:GetCaster())
    if random then 
      Timers:CreateTimer(0.3, function() self:MakeSpray(location, false) end)
    end

  end
end



modifier_custom_bristleback_quillspray_thinker = class({})


function modifier_custom_bristleback_quillspray_thinker:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  

  self.radius         = self.ability:GetSpecialValueFor("radius")
  self.quill_base_damage    = self.ability:GetSpecialValueFor("quill_base_damage")
  self.quill_stack_damage   = self.ability:GetSpecialValueFor("quill_stack_damage") 

  if self:GetCaster():HasModifier("modifier_bristle_spray_damage") then 
     self.quill_stack_damage = self.quill_stack_damage + self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetCaster():GetUpgradeStack("modifier_bristle_spray_damage")
  end


  self.quill_stack_duration = self.ability:GetSpecialValueFor("quill_stack_duration")
  self.max_damage       = self.ability:GetSpecialValueFor("max_damage")
  

  if not IsServer() then return end
  
  self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf", PATTACH_ABSORIGIN, self.parent)
  self:AddParticle(self.particle, false, false, -1, false, false)
  
  self.hit_enemies = {}
  
  self:StartIntervalThink(FrameTime())
end

function modifier_custom_bristleback_quillspray_thinker:OnIntervalThink()
  if not IsServer() then return end

  local radius_pct = math.min((self:GetDuration() - self:GetRemainingTime()) / self:GetDuration(), 1)
  
  local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius * radius_pct, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
  
  local proc = false 
  if self:GetCaster():HasModifier("modifier_bristle_spray_max") then 
    local chance = self:GetAbility().proc_chance

    local random = RollPseudoRandomPercentage(chance,78,self:GetCaster())
    if random then 
      proc = true
    end

  end



  for _, enemy in pairs(enemies) do
  
    local hit_already = false
  
    for _, hit_enemy in pairs(self.hit_enemies) do
      if hit_enemy == enemy then
        hit_already = true
        break
      end
    end

    if not hit_already then
      local quill_spray_stacks  = 0
      local quill_spray_modifier  = enemy:FindModifierByName("modifier_custom_bristleback_quill_spray")
      
      if quill_spray_modifier then
        quill_spray_stacks    = quill_spray_modifier:GetStackCount()
      end
    
      local damageTable = {
        victim      = enemy,
        damage      = math.min(self.quill_base_damage + (self.quill_stack_damage * quill_spray_stacks), self.max_damage),
        damage_type   = DAMAGE_TYPE_PHYSICAL,
        damage_flags  = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
        attacker    = self.caster,
        ability     = self.ability
      }
                  
      ApplyDamage(damageTable)
      

      if not enemy:IsMagicImmune() and proc == true and self:GetCaster():HasModifier("modifier_bristle_spray_max") then 
          enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_bristleback_quill_spray_proc_slow", {duration = self:GetAbility().proc_duration})
      end


      local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
     ParticleManager:SetParticleControlEnt(particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
      ParticleManager:ReleaseParticleIndex(particle)
      
      enemy:EmitSound("Hero_Bristleback.QuillSpray.Target")
      
      local stack_duration = self.quill_stack_duration

      if self:GetCaster():HasModifier("modifier_bristle_spray_reduce") then 
        stack_duration = stack_duration + self:GetAbility().reduce_duration
      end

      enemy:AddNewModifier(self.caster, self.ability, "modifier_custom_bristleback_quill_spray", {duration = stack_duration * (1 - enemy:GetStatusResistance())})
      enemy:AddNewModifier(self.caster, self.ability, "modifier_custom_bristleback_quill_spray_count", {duration = stack_duration * (1 - enemy:GetStatusResistance())})
      

      
      table.insert(self.hit_enemies, enemy)
      
      if not enemy:IsAlive() and enemy:IsRealHero() and (enemy.IsReincarnating and not enemy:IsReincarnating()) then
        self.caster:EmitSound("bristleback_bristle_quill_spray_0"..math.random(1,6))
      end
    end
  end
end




modifier_custom_bristleback_quill_spray = class({})


function modifier_custom_bristleback_quill_spray:IsPurgable() return false end

function modifier_custom_bristleback_quill_spray:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  
  self.RemoveForDuel = true
  
  if not IsServer() then return end
  
  self:IncrementStackCount()
  
  local particle_name = "particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit.vpcf"
  if self.parent:IsCreep() then 
    particle_name ="particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit_creep.vpcf"
  end

  self.particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self.parent)


  ParticleManager:SetParticleControlEnt(self.particle, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.particle, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  self:AddParticle(self.particle, false, false, -1, false, false)
  
  
end

function modifier_custom_bristleback_quill_spray:OnRefresh()
  if not IsServer() then return end

  self:IncrementStackCount()
  
end

function modifier_custom_bristleback_quill_spray:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
 MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end



function modifier_custom_bristleback_quill_spray:GetModifierLifestealRegenAmplify_Percentage() 
if self:GetCaster():HasModifier("modifier_bristle_spray_reduce") then 
    return self:GetStackCount()*self:GetAbility().reduce
else 
     return
end

end

function modifier_custom_bristleback_quill_spray:GetModifierHealAmplify_PercentageTarget() 
if self:GetCaster():HasModifier("modifier_bristle_spray_reduce") then 
    return self:GetStackCount()*self:GetAbility().reduce
else 
     return
end

end

function modifier_custom_bristleback_quill_spray:GetModifierHPRegenAmplify_Percentage() 

if self:GetCaster():HasModifier("modifier_bristle_spray_reduce") then 
    return self:GetStackCount()*self:GetAbility().reduce
else 
     return
end

end




modifier_custom_bristleback_quill_spray_count = class({})

function modifier_custom_bristleback_quill_spray_count:IsHidden() return true end
function modifier_custom_bristleback_quill_spray_count:IsPurgable() return false end
function modifier_custom_bristleback_quill_spray_count:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_bristleback_quill_spray_count:OnCreated(table)
if not IsServer() then return end
  self.RemoveForDuel = true
end

function modifier_custom_bristleback_quill_spray_count:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_custom_bristleback_quill_spray")

if mod then 
  mod:DecrementStackCount()
end

end



modifier_custom_bristleback_quill_spray_tracker = class({})
function modifier_custom_bristleback_quill_spray_tracker:IsHidden() return true end
function modifier_custom_bristleback_quill_spray_tracker:IsPurgable() return false end
function modifier_custom_bristleback_quill_spray_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end




function modifier_custom_bristleback_quill_spray_tracker:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.inflictor ~= self:GetAbility() then return end
if not self:GetParent():HasModifier("modifier_bristle_spray_heal") then return end

local heal = params.damage*(self:GetAbility().heal_init + self:GetAbility().heal_inc*self:GetParent():GetUpgradeStack("modifier_bristle_spray_heal"))
if params.unit:IsCreep() then 
  heal = heal/self:GetAbility().heal_creep
end

self:GetParent():Heal(heal, self:GetParent())
local particle = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

end





modifier_custom_bristleback_quill_spray_legendary = class({})

function modifier_custom_bristleback_quill_spray_legendary:IsHidden() return false end
function modifier_custom_bristleback_quill_spray_legendary:IsPurgable() return false end
function modifier_custom_bristleback_quill_spray_legendary:GetTexture() return "buffs/quill_cdr" end
function modifier_custom_bristleback_quill_spray_legendary:RemoveOnDeath() return false end


--self.particle = ParticleManager:CreateParticle("particles/bristle_cdr.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
--ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
--ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
--ParticleManager:SetParticleControlEnt(self.particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
--self:AddParticle(self.particle, false, false, -1, false, false)
  

modifier_custom_bristleback_quill_spray_lowhp_tracker = class({})

function modifier_custom_bristleback_quill_spray_lowhp_tracker:IsHidden()
if self:GetParent():GetHealthPercent() <= self:GetAbility().lowhp_health then 
  return false 
else 
  return true
end
end
function modifier_custom_bristleback_quill_spray_lowhp_tracker:GetTexture() return "buffs/spray_lowhp" end
function modifier_custom_bristleback_quill_spray_lowhp_tracker:IsPurgable() return false end
function modifier_custom_bristleback_quill_spray_lowhp_tracker:RemoveOnDeath() return false end

function modifier_custom_bristleback_quill_spray_lowhp_tracker:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0.1)
self.flag = false 
end

function modifier_custom_bristleback_quill_spray_lowhp_tracker:OnIntervalThink()
if not IsServer() then return end
if self.flag == false then 
  if self:GetParent():GetHealthPercent() <= self:GetAbility().lowhp_health then 
    self.flag = true 
    self:GetParent():EmitSound("Lc.Moment_Lowhp")
    self.particle = ParticleManager:CreateParticle( "particles/lc_lowhp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
     ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetAbsOrigin() )
       ParticleManager:SetParticleControl( self.particle, 1, self:GetParent():GetAbsOrigin() )
     ParticleManager:SetParticleControl( self.particle, 2, self:GetParent():GetAbsOrigin() )
    
  end
end

if self.flag == true then
  if self:GetParent():GetHealthPercent() > self:GetAbility().lowhp_health then
    self.flag = false 
    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)
  end
end

end




modifier_custom_bristleback_quill_spray_proc_slow = class({})
function modifier_custom_bristleback_quill_spray_proc_slow:IsHidden() return true end
function modifier_custom_bristleback_quill_spray_proc_slow:IsPurgable() return true end
function modifier_custom_bristleback_quill_spray_proc_slow:GetTexture() return "buffs/spray_slow" end
function modifier_custom_bristleback_quill_spray_proc_slow:OnCreated(table)
if not IsServer() then return end

local damage = self:GetAbility().proc_damage_init + self:GetAbility().proc_damage_inc*self:GetCaster():GetUpgradeStack("modifier_bristle_spray_max")

self:GetParent():EmitSound("BB.Quill_proc")

local particle = ParticleManager:CreateParticle("particles/brist_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:ReleaseParticleIndex(particle)


local damageTable = 
{
        victim      = self:GetParent(),
        damage      = damage,
        damage_type   = DAMAGE_TYPE_MAGICAL,
        damage_flags  = DOTA_DAMAGE_FLAG_NONE,
        attacker    = self:GetCaster(),
        ability     = self:GetAbility()
}
                  
ApplyDamage(damageTable)
      

end

function modifier_custom_bristleback_quill_spray_proc_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_custom_bristleback_quill_spray_proc_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().proc_slow
end