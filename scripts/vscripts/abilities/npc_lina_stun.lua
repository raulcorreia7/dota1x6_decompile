LinkLuaModifier("modifier_lina_stun_cd", "abilities/npc_lina_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_stun_thinker", "abilities/npc_lina_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_stun_targets", "abilities/npc_lina_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_stun_noulti", "abilities/npc_lina_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_thinker", "abilities/npc_lina_fiery.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_aura", "abilities/npc_lina_fiery", LUA_MODIFIER_MOTION_NONE)


npc_lina_stun = class({})

function npc_lina_stun:OnSpellStart()

    if not IsServer() then
        return
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_stun_cd", {duration = self:GetCooldownTimeRemaining()})
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_stun_targets", {})
    
end


modifier_lina_stun_targets = class({})
function modifier_lina_stun_targets:IsHidden() return true end
function modifier_lina_stun_targets:IsPurgable() return false end
function modifier_lina_stun_targets:OnCreated(table)
if not IsServer() then return end





  self.number = 3
  self.max_number = self.number*2 + 1

  local i = 0
  local j = 0
  local vert = 0
  local horiz = 0
  local qangle = QAngle(0, 90, 0)



  self.targets = {}
  for i = 1,self.max_number do
    self.targets[i] = {}
  end


  local targets_origin

  for i = -1*self.number,self.number do
    horiz = horiz + 1
    vert = 0
    local line_position = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*self:GetAbility():GetSpecialValueFor("radius")*2*i

    targets_origin = RotatePosition(self:GetCaster():GetAbsOrigin() , qangle, line_position)

    for j = -1*self.number,self.number do
       vert = vert + 1

       self.targets[horiz][vert] = targets_origin + self:GetCaster():GetForwardVector()*j*self:GetAbility():GetSpecialValueFor("radius")*2

    end


end

   
  self.count = 0


local random = RandomInt(1, 5)

self.delay_stun = 1.5
self.pattern = random

if self.pattern == 1 then 
  self.restrict = 
       {
        {1,7},
        {2,6},
        {3,5},
        {4,4}
       }
   self.max = 4    
   self.delay = 0.6
end

if self.pattern == 2 then 
  self.restrict = {   }
   self.max = 2   
   self.delay = 1.5
end

if self.pattern == 3 then 
  self.restrict = 
       {
        {4,4},
        {3,5},
        {2,6},
        {1,7}
       }
   self.max = 4    
   self.delay = 0.5
end

if self.pattern == 3 then 
  self.restrict = 
       {
        {4,4},
        {3,5},
        {2,6},
        {1,7}
       }
   self.max = 4    
   self.delay = 0.5
end

if self.pattern == 4 then 
  self.restrict =   { }
   self.max = 2    
   self.delay = 1
end

if self.pattern == 5 then 
  self.restrict =   { }

   self.max = self.max_number*self.max_number    
   self.delay = 0.04
   local n = 0
   local used_numbers = {}

   for n = 1,self.max do 
        repeat r = RandomInt(1, self.max)
        until not my_game:check_used(used_numbers,r)
        used_numbers[n] = r
        self.restrict[n] = r
    end

end

  self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lina_stun_noulti", {duration = self.delay*self.max})
  self:StartIntervalThink(self.delay)
  self:OnIntervalThink()
    
end







function modifier_lina_stun_targets:OnIntervalThink()
if not IsServer() then return end
local i = 0
local j = 0
local vert = 0
local horiz = 0
local radius = 0


if self.pattern ~= 5 then

self.count = self.count + 1

 for i = 1,self.max_number do 
  for j = 1,self.max_number do 

      local stun = false 

      if self.pattern == 1 then 
           if (i == self.restrict[self.count][1]) or (i == self.restrict[self.count][2]) then 
            stun = true 
            radius = 50
          end
      end


      if self.pattern == 2 then 

         if self.count == 1 then
            if (i + j == self.max_number + 1) or (i == j) then 
              stun = true 
              radius = 50
            end
         end
          
         if self.count == 2 then
            if (i + j ~= self.max_number + 1) and (i ~= j) then 
              stun = true 
              radius = 50
            end
         end
             
      end

      if self.pattern == 3 then 
           if ((i >= self.restrict[self.count][1]) and (i <= self.restrict[self.count][2])
            and ((j == self.restrict[self.count][1]) or (j == self.restrict[self.count][2])))
           or
            ((j >= self.restrict[self.count][1]) and (j <= self.restrict[self.count][2])
            and ((i == self.restrict[self.count][1]) or (i == self.restrict[self.count][2])))
           
           then 
            stun = true 
            radius = 40
          end

      end


      if self.pattern == 4 then 

         if self.count == 1 then
            if (i >= (self.max_number + 1)/2)  then 
              stun = true 
              radius = 50
            end
         end
          
         if self.count == 2 then
            if (i < (self.max_number + 1)/2) then 
              stun = true 
              radius = 50

            end
         end
             
      end

      if stun == true then 
         CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_lina_stun_thinker", {duration = self.delay_stun, radius = radius}, self.targets[i][j], self:GetCaster():GetTeamNumber(), false)
  
      end 

    end
  end
end

if self.pattern == 5 then 

    self.count = self.count + 1
    local pos_i = math.ceil(self.restrict[self.count]/self.max_number)
    local pos_j = 0

    if self.restrict[self.count] > self.max_number then  
      pos_j =  self.restrict[self.count] -  (pos_i - 1)*self.max_number 
    else 
      pos_j = self.restrict[self.count]
    end

    radius = 30
    CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_lina_stun_thinker", {duration = self.delay_stun, radius = radius}, self.targets[pos_i][pos_j], self:GetCaster():GetTeamNumber(), false)
   
end


  if self.count >= self.max then
   self:Destroy()
  end 

end

modifier_lina_stun_thinker = class({})

function modifier_lina_stun_thinker:IsHidden() return false end

function modifier_lina_stun_thinker:IsPurgable() return false end

function modifier_lina_stun_thinker:OnCreated(table)
if not IsServer() then return end
  self.radius = self:GetAbility():GetSpecialValueFor("radius") + table.radius

    self:GetParent():EmitSound("Ability.PreLightStrikeArray")
  local particle_cast = "particles/lina_warning.vpcf"

  self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent())
  ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius) )
  ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )

  local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", PATTACH_WORLDORIGIN, caster)
  ParticleManager:SetParticleControl(cast_pfx, 0, self:GetParent():GetOrigin())
  ParticleManager:SetParticleControl(cast_pfx, 1, Vector( self.radius, 0, -self.radius))
  ParticleManager:ReleaseParticleIndex(cast_pfx)

end


function modifier_lina_stun_thinker:OnDestroy(table)
if not IsServer() then return end
  
  ParticleManager:DestroyParticle( self.effect_cast, true )
  ParticleManager:ReleaseParticleIndex( self.effect_cast )

    self:GetParent():EmitSound("Ability.LightStrikeArray")
    local seed_particle = ParticleManager:CreateParticle("particles/npc_lina_stun.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(seed_particle, 0, self:GetParent():GetAbsOrigin())
  ParticleManager:SetParticleControl(seed_particle, 1, Vector(self.radius,self.radius,self.radius ))
  ParticleManager:ReleaseParticleIndex(seed_particle)

  local  enemy_for_ability = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES , FIND_CLOSEST, false)
   for _,i in ipairs(enemy_for_ability) do

      local damageTable = {victim = i,  damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_PURE, attacker = self:GetCaster(), ability = self:GetAbility()}
      local actualy_damage = ApplyDamage(damageTable)
      i:AddNewModifier(self:GetCaster(), self:GetAbility() ,"modifier_stunned", {duration = 1.5*(1 - i:GetStatusResistance())})
    

   end



local chance = self:GetAbility():GetSpecialValueFor("chance")

local ability = self:GetAbility():GetCaster():FindAbilityByName("npc_lina_fiery")   
local random = RollPseudoRandomPercentage(chance,27,self:GetParent())

if random then

  if ability then 
    local duration = ability:GetSpecialValueFor("duration") 
    CreateModifierThinker(self:GetAbility():GetCaster(), ability, "modifier_lina_fiery_thinker", {duration = duration}, self:GetParent():GetAbsOrigin(), self:GetParent():GetTeamNumber(), false)
  end 
end


end





modifier_lina_stun_noulti = class({})

function modifier_lina_stun_noulti:IsHidden() return true end
function modifier_lina_stun_noulti:IsPurgable() return false end


modifier_lina_stun_cd = class({})

function modifier_lina_stun_cd:IsHidden() return false end
function modifier_lina_stun_cd:IsPurgable() return false end



