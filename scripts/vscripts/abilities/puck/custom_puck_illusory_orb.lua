LinkLuaModifier("modifier_puck_coil_wall_thinker", "abilities/puck/custom_puck_illusory_orb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_puck_coil_orb_thinker", "abilities/puck/custom_puck_illusory_orb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_puck_coil_orb_slow", "abilities/puck/custom_puck_illusory_orb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_puck_coil_orb_blind", "abilities/puck/custom_puck_illusory_orb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_puck_coil_speed", "abilities/puck/custom_puck_illusory_orb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_puck_coil_orb_attackspeed", "abilities/puck/custom_puck_illusory_orb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_puck_coil_orb_damage", "abilities/puck/custom_puck_illusory_orb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_puck_coil_orb_tracker", "abilities/puck/custom_puck_illusory_orb", LUA_MODIFIER_MOTION_NONE)



custom_puck_illusory_orb          = class({})
custom_puck_ethereal_jaunt        = class({})
custom_puck_illusory_barrier      = class({})


custom_puck_illusory_orb.building = 0.3

custom_puck_illusory_orb.damage_init = 0
custom_puck_illusory_orb.damage_inc = 40

custom_puck_illusory_orb.range_init = 0
custom_puck_illusory_orb.range_inc = 150
custom_puck_illusory_orb.range_speed_init = 0.1
custom_puck_illusory_orb.range_speed_inc = 0.1


custom_puck_ethereal_jaunt.slow_blind = 1.5
custom_puck_ethereal_jaunt.blind_radius = 300

custom_puck_illusory_orb.damage_stack_duration = 15
custom_puck_illusory_orb.damage_stack_init = 5
custom_puck_illusory_orb.damage_stack_inc = 10
custom_puck_illusory_orb.damage_stack_max = 6

custom_puck_illusory_orb.cd_speed = 30
custom_puck_illusory_orb.cd_duration = 3
custom_puck_illusory_orb.cd_cd = 2

custom_puck_illusory_orb.slow_slow = -80
custom_puck_illusory_orb.slow_duration = 2

custom_puck_illusory_orb.speed_init = 40
custom_puck_illusory_orb.speed_inc = 40
custom_puck_illusory_orb.speed_duration = 2








function custom_puck_illusory_barrier:GetVectorTargetRange()
  return self:GetSpecialValueFor("radius")
end

local function GetAngle( x1, y1, x2, y2 )
    return math.deg(math.acos((x1*x2+y1*y2)/(((x1^2+y1^2)^0.5)*((x2^2+y2^2)^0.5))))
end



function custom_puck_illusory_barrier:OnVectorCastStart(vStartLocation, vDirection)

local target = self:GetCursorPosition() 


if target == self:GetCaster():GetAbsOrigin() then 
  target = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*30
  return
end


  local pos1 = self:GetVectorPosition() + RotatePosition(Vector(), QAngle(0, 90 ,0), vDirection*(self:GetVectorTargetRange()/2)) 
local pos2 = self:GetVectorPosition() + RotatePosition(Vector(), QAngle(0,-90,0), vDirection*(self:GetVectorTargetRange()/2)) 


--local pos1 = self:GetVectorPosition() + 200*vDirection
--local pos2 = self:GetVectorPosition() - 200*vDirection

  CreateModifierThinker(self:GetCaster(), self, "modifier_puck_coil_wall_thinker",
   {
    duration = self:GetSpecialValueFor("duration"),
    pos1x = pos1.x,
    pos1y = pos1.y,
    pos1z = pos1.z,
    pos2x = pos2.x,
    pos2y = pos2.y,
    pos2z = pos2.z,
    vDirectionX = vDirection.x,
    vDirectionY = vDirection.y,
    vDirectionZ = vDirection.z

   }
   , target, self:GetCaster():GetTeamNumber(), false)
  

end







------------------
-- ILLUSORY ORB --
------------------









------------------
-- ILLUSORY ORB --
------------------


function custom_puck_illusory_orb:GetBehavior()
  if self:GetCaster():HasModifier("modifier_puck_orb_legendary") then
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING
  end
 return DOTA_ABILITY_BEHAVIOR_POINT 
end


function custom_puck_illusory_orb:GetVectorTargetRange()
  return self:GetSpecialValueFor("radius")
end

function custom_puck_illusory_orb:GetIntrinsicModifierName()
return "modifier_puck_coil_orb_tracker"
end


function custom_puck_illusory_orb:GetAssociatedSecondaryAbilities()
  return "custom_puck_ethereal_jaunt"
end





function custom_puck_illusory_orb:OnVectorCastStart(vStartLocation, vDirection)

local target = self:GetCursorPosition()


if target == self:GetCaster():GetAbsOrigin() then 
  target = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*30
end

local orb_direction = (self:GetCaster():GetAbsOrigin() - target):Normalized()

local angle = GetAngle(orb_direction.x , orb_direction.y , vDirection.x , vDirection.y)/2

  
local rat = math.atan2( orb_direction.y, orb_direction.x )
local dat = math.atan2( vDirection.y, vDirection.x )

local l = rat < dat 
if  math.deg(math.abs(rat - dat)) > 180 then 
  l = not l
end

if l then 
   angle = -angle
end

local pos1 = self:GetVectorPosition() + RotatePosition(Vector(), QAngle(0, 90 + angle ,0), vDirection*(self:GetVectorTargetRange())) 
local pos2 = self:GetVectorPosition() + RotatePosition(Vector(), QAngle(0,-90 + angle,0), vDirection*(self:GetVectorTargetRange())) 


--local pos1 = self:GetVectorPosition() + 200*vDirection
--local pos2 = self:GetVectorPosition() - 200*vDirection

  CreateModifierThinker(self:GetCaster(), self, "modifier_puck_coil_wall_thinker",
   {
    duration = 10,
    pos1x = pos1.x,
    pos1y = pos1.y,
    pos1z = pos1.z,
    pos2x = pos2.x,
    pos2y = pos2.y,
    pos2z = pos2.z,
    vDirectionX = vDirection.x,
    vDirectionY = vDirection.y,
    vDirectionZ = vDirection.z

   }
   , target, self:GetCaster():GetTeamNumber(), false)
  


self:StartOrb(target,self:GetCaster():GetAbsOrigin(),self:GetCaster())
  


end





function custom_puck_illusory_orb:OnUpgrade()
  local jaunt_ability = self:GetCaster():FindAbilityByName("custom_puck_ethereal_jaunt")
  local barrier_ability = self:GetCaster():FindAbilityByName("custom_puck_illusory_barrier")

  if jaunt_ability and not self.jaunt_ability then
    self.jaunt_ability  = jaunt_ability
    
    if not jaunt_ability:IsTrained() then
      self.jaunt_ability:SetLevel(1)
    end
  end

  if barrier_ability then 

   if not barrier_ability:IsTrained() then
      barrier_ability:SetLevel(1)
    end

  end

end



function custom_puck_illusory_orb:OnSpellStart()

local target = self:GetCursorPosition()

if target == self:GetCaster():GetAbsOrigin() then 
  target = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*30
end


self:StartOrb(target,self:GetCaster():GetAbsOrigin(),self:GetCaster())
  
end


function custom_puck_illusory_orb:StartOrb(target,start,caster)


  local jaunt_ability = caster:FindAbilityByName("custom_puck_ethereal_jaunt")

  if jaunt_ability and not self.jaunt_ability then
    self.jaunt_ability = jaunt_ability
    
    if not jaunt_ability:IsTrained() then
      self.jaunt_ability:SetLevel(1)
    end
  end

  if not self.orbs then
    self.orbs = {}
  end



   if not self.orbs_effect then
    self.orbs_effect = {}
  end

  local vector = (target - start):Normalized()

  if target == start then
    target = target + vector
  end

  -- Main Orb
  self:FireOrb(target,start)
  
  if self.jaunt_ability then
    self.jaunt_ability:SetActivated(true)
  end

end





function custom_puck_illusory_orb:OnProjectileThink_ExtraData(location, data)
  if not IsServer() then return end
  
  if data.orb_thinker then
    local thinker = EntIndexToHScript(data.orb_thinker)
    thinker:SetAbsOrigin(location)
  
  end


  self:CreateVisibilityNode(location, self:GetSpecialValueFor("orb_vision"), 5)
end




function custom_puck_illusory_orb:FireOrb(target,start)

  local orb_thinker = CreateUnitByName("npc_dota_companion", start, false, self:GetCaster(), self:GetCaster(),self:GetCaster():GetTeamNumber())

  orb_thinker:AddNewModifier(self:GetCaster(), self, "modifier_puck_coil_orb_thinker", {}) 



  orb_thinker.current_distance = 0

  local vector = (start - target):Normalized()
  orb_thinker.angle = math.deg(math.atan2(vector.x, vector.y))
  orb_thinker.vector = vector

  orb_thinker.Destroyed = false

 self.distance = self:GetSpecialValueFor("max_distance")

  local speed_bonus = 1

  if self:GetCaster():HasModifier("modifier_puck_orb_range") then 
    self.distance = self.distance + self.range_init + self.range_inc*self:GetCaster():GetUpgradeStack("modifier_puck_orb_range")
    speed_bonus = speed_bonus + self.range_speed_init + self.range_speed_inc*self:GetCaster():GetUpgradeStack("modifier_puck_orb_range")
  end


  orb_thinker.max_distance = self.distance

  orb_thinker:EmitSound("Hero_Puck.Illusory_Orb")

  local speed = self:GetSpecialValueFor("orb_speed")

  if self:GetCaster():HasModifier("modifier_puck_orb_legendary") then 
    speed = speed * speed_bonus
  end

  local velocity = ((GetGroundPosition(target, nil) - GetGroundPosition(start, nil)))

  velocity.z = 0

  local projectile_info = {
    Source        = self:GetCaster(),
    Ability       = self,
    vSpawnOrigin    = start,
    
      bDeleteOnHit    = false,
      
      iUnitTargetTeam   = DOTA_UNIT_TARGET_TEAM_ENEMY,
      iUnitTargetType   = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC  + DOTA_UNIT_TARGET_BUILDING,
      
      EffectName      = "particles/units/heroes/hero_puck/puck_illusory_orb.vpcf",
      fDistance       = self.distance  ,
      fStartRadius    = self:GetSpecialValueFor("radius") ,
      fEndRadius      = self:GetSpecialValueFor("radius"),
    vVelocity       =  velocity:Normalized() * speed,
  
    bReplaceExisting  = false,
    
    bProvidesVision   = true,
    iVisionRadius     = self:GetSpecialValueFor("orb_vision"),
    iVisionTeamNumber   = self:GetCaster():GetTeamNumber(),
    
    ExtraData = {
      orb_thinker   = orb_thinker:entindex(), max_distance = self.distance
    }
  }
  

  local projectile = ProjectileManager:CreateLinearProjectile(projectile_info)
   table.insert(self.orbs, orb_thinker:entindex())
   table.insert(self.orbs_effect, projectile)
end

function custom_puck_illusory_orb:OnProjectileHit_ExtraData(target, location, data)
  if not IsServer() then return end 


  if target then 

    target:EmitSound("Hero_Puck.IIllusory_Orb_Damage")
    
    self.damage = self:GetAbilityDamage()

    if self:GetCaster():HasModifier("modifier_puck_orb_damage") then 
      self.damage = self.damage + self.damage_init + self.damage_inc*self:GetCaster():GetUpgradeStack("modifier_puck_orb_damage")

    end

    if target:HasModifier("modifier_puck_coil_orb_damage") then 
      local stack = target:FindModifierByName("modifier_puck_coil_orb_damage"):GetStackCount()
      self.damage = self.damage*(1 + stack*(self.damage_stack_init + self.damage_stack_inc*self:GetCaster():GetUpgradeStack("modifier_puck_orb_distance"))/100)
    end

    if target:IsBuilding() then 
      self.damage = self.damage*self.building
    end

    local damageTable = {
      victim      = target,
      damage      = self.damage,
      damage_type   = self:GetAbilityDamageType(),
      damage_flags  = DOTA_DAMAGE_FLAG_NONE,
      attacker    = self:GetCaster(),
      ability     = self
    }


    ApplyDamage(damageTable)


  if  self:GetCaster():HasModifier("modifier_puck_orb_distance") and not target:IsBuilding() then 

      target:AddNewModifier(self:GetCaster(), self, "modifier_puck_coil_orb_damage", {duration = self.damage_stack_duration})

  end


  if self:GetCaster():HasModifier("modifier_puck_orb_blind") then 
    target:AddNewModifier(self:GetCaster(), self, "modifier_puck_coil_orb_slow", {duration = (1 - target:GetStatusResistance())* self.slow_duration})
  end


  else

    if data.orb_thinker then
      table.remove(self.orbs, 1)
      table.remove(self.orbs_effect, 1)

      EntIndexToHScript(data.orb_thinker):StopSound("Hero_Puck.Illusory_Orb")
      EntIndexToHScript(data.orb_thinker).Destroyed = true
      EntIndexToHScript(data.orb_thinker):Destroy()
    end

    if self.jaunt_ability and #self.orbs == 0 then
      self.jaunt_ability:SetActivated(false)
    end



end

end




function custom_puck_ethereal_jaunt:GetAssociatedPrimaryAbilities()
  return "custom_puck_illusory_orb"
end

function custom_puck_ethereal_jaunt:ProcsMagicStick() return false end


function custom_puck_ethereal_jaunt:OnUpgrade()
  self:SetActivated(false)

  local orb_ability = self:GetCaster():FindAbilityByName(self:GetAssociatedPrimaryAbilities())

  if orb_ability then
    self.orb_ability  = orb_ability
  end
end

function custom_puck_ethereal_jaunt:OnSpellStart()
  if self.orb_ability and self.orb_ability.orbs and #self.orb_ability.orbs >= 1 then
    self:GetCaster():EmitSound("Hero_Puck.EtherealJaunt")
  
    local jaunt_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_illusory_orb_blink_out.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
    ParticleManager:ReleaseParticleIndex(jaunt_particle)
  
    ProjectileManager:DestroyLinearProjectile(self.orb_ability.orbs_effect[#self.orb_ability.orbs_effect])
    EntIndexToHScript(self.orb_ability.orbs[#self.orb_ability.orbs]):StopSound("Hero_Puck.Illusory_Orb")


    FindClearSpaceForUnit(self:GetCaster(), EntIndexToHScript(self.orb_ability.orbs[#self.orb_ability.orbs]):GetAbsOrigin(), true)
    ProjectileManager:ProjectileDodge(self:GetCaster())
      
    local thinker = EntIndexToHScript(self.orb_ability.orbs[#self.orb_ability.orbs])

    thinker.Destroyed = true 
    thinker:Destroy()

    table.remove(self.orb_ability.orbs, #self.orb_ability.orbs)
    table.remove(self.orb_ability.orbs_effect, #self.orb_ability.orbs_effect)

    if  #self.orb_ability.orbs == 0 then 
      self:SetActivated(false)
    end

    if self:GetCaster():HasModifier("modifier_puck_orb_double") then 
      self:GetCaster():AddNewModifier(self:GetCaster(), self.orb_ability, "modifier_puck_coil_speed", {duration = self.orb_ability.cd_duration})
      if self.orb_ability:GetCooldownTimeRemaining() > 0 then 
        local cd = self.orb_ability:GetCooldownTimeRemaining()
        self.orb_ability:EndCooldown()

        if cd > self.orb_ability.cd_cd then 
          self.orb_ability:StartCooldown(cd - self.orb_ability.cd_cd)
        end

      end
    end


     if self:GetCaster():HasModifier("modifier_puck_orb_cd") then 
      self:GetCaster():AddNewModifier(self:GetCaster(), self.orb_ability, "modifier_puck_coil_orb_attackspeed", {duration = self.orb_ability.speed_duration})
    end


    if self:GetCaster():HasModifier("modifier_puck_orb_blind") then 
    
      local rift_particle = ParticleManager:CreateParticle("particles/puck_blind.vpcf", PATTACH_WORLDORIGIN, nil)
      ParticleManager:SetParticleControl(rift_particle, 0, self:GetCaster():GetAbsOrigin())
      ParticleManager:SetParticleControl(rift_particle, 1, self:GetCaster():GetAbsOrigin())
      ParticleManager:SetParticleControl(rift_particle, 2, Vector(self.blind_radius, 0, 0))
      ParticleManager:ReleaseParticleIndex(rift_particle)

           self:GetCaster():EmitSound("Phantom_Assassin.Blind")  
      local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.blind_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
       for _,enemy in ipairs(enemies) do  
            enemy:AddNewModifier(self:GetCaster(), self, "modifier_puck_coil_orb_blind", {duration = (1 - enemy:GetStatusResistance())* self.slow_blind})

        end


    end



    if self:GetCaster():GetName() == "npc_dota_hero_puck"  then
      self:GetCaster():EmitSound("puck_puck_ability_orb_0"..RandomInt(1, 3))
    end
    


  end
end

modifier_puck_coil_orb_thinker = class({})
function modifier_puck_coil_orb_thinker:IsHidden() return true end
function modifier_puck_coil_orb_thinker:IsPurgable() return false end
function modifier_puck_coil_orb_thinker:CheckState()
  local state =
  {
  [MODIFIER_STATE_INVULNERABLE]   = true,
  [MODIFIER_STATE_OUT_OF_GAME]  = true,
  [MODIFIER_STATE_UNSELECTABLE] = true
  }
  
  
  return state
end



modifier_puck_coil_wall_thinker = class({})



function modifier_puck_coil_wall_thinker:IsHidden() return true end
function modifier_puck_coil_wall_thinker:IsPurgable() return false end
function modifier_puck_coil_wall_thinker:OnCreated(table)
if not IsServer() then return end
self.pos1 = Vector(table.pos1x, table.pos1y, table.pos1z)
self.pos2 = Vector(table.pos2x, table.pos2y, table.pos2z)


self:GetParent():EmitSound("Puck.Orb_wall")
self.caster_abs = self:GetCaster():GetAbsOrigin()

self.vector = (self.pos2 - self.pos1):Normalized()


self.ability = self:GetCaster():FindAbilityByName("custom_puck_illusory_orb")

  self.wall = ParticleManager:CreateParticle("particles/duel_wall.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(self.wall, 0, self.pos1)
  ParticleManager:SetParticleControl(self.wall, 1, self.pos2)
  self:AddParticle(self.wall, false, false, -1, false, false)
  
self:StartIntervalThink(FrameTime())

end

function modifier_puck_coil_wall_thinker:OnIntervalThink()
if not IsServer() then return end


local thinkers = FindUnitsInLine(self:GetParent():GetTeamNumber(), self.pos1, self.pos2, nil, 30, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD)



for _,thinker in ipairs(thinkers) do
  if thinker ~= self:GetParent() and thinker:HasModifier("modifier_puck_coil_orb_thinker")
     and (thinker.Destroyed == nil or thinker.Destroyed == false) then 
  
      local location = thinker:GetAbsOrigin()


      local r_vector = thinker.vector

     local dir1 = RotatePosition(Vector(), QAngle(0,90,0), self.vector) 
     local dir2 = RotatePosition(Vector(), QAngle(0,-90,0), self.vector) 

      local a1 = GetAngle(r_vector.x , r_vector.y , dir1.x , dir1.y)
      local a2 = GetAngle(r_vector.x , r_vector.y , dir2.x , dir2.y)


      local dir = a1 < a2 and dir1 or dir2
      local a = a1 < a2 and a1 or a2

      local rat = math.atan2( r_vector.y, r_vector.x )
      local dat = math.atan2( dir.y, dir.x )

      local l = rat < dat 

      if  math.deg(math.abs(rat - dat)) > 180 then 
        l = not l
      end


      local k = 1
      if not l then 
        k = -1
      end
    
      if (math.abs(a) > 80 and math.abs(a) <= 90) then return end

      local target = RotatePosition(Vector() , QAngle(0, a*k , 0), dir ) + location


      local jaunt_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_illusory_orb_blink_out.vpcf", PATTACH_ABSORIGIN, thinker)
      ParticleManager:ReleaseParticleIndex(jaunt_particle)
  
      
      thinker:StopSound("Hero_Puck.Illusory_Orb")
      for id, orb in ipairs(self.ability.orbs) do
        if thinker:entindex() == orb then

           ProjectileManager:DestroyLinearProjectile(self.ability.orbs_effect[id])
           thinker.Destroyed = true 
           table.remove(self.ability.orbs, id)
           table.remove(self.ability.orbs_effect, id)
           thinker:Destroy()

           break
        end
      end
      self.ability:StartOrb(target ,location, self:GetCaster() )
      UTIL_Remove(self:GetParent())
    end
end


end


modifier_puck_coil_orb_slow = class({})
function modifier_puck_coil_orb_slow:IsHidden() return false end
function modifier_puck_coil_orb_slow:IsPurgable() return true end
function modifier_puck_coil_orb_slow:GetTexture() return "buffs/orb_slow" end

function modifier_puck_coil_orb_slow:GetEffectName() return "particles/puck_orb_slow.vpcf" end

function modifier_puck_coil_orb_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end
function modifier_puck_coil_orb_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow_slow
end





modifier_puck_coil_orb_blind = class({})


function modifier_puck_coil_orb_blind:IsHidden() return false end
function modifier_puck_coil_orb_blind:IsPurgable() return true end

function modifier_puck_coil_orb_blind:GetTexture() return "buffs/orb_blind" end

function modifier_puck_coil_orb_blind:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
  MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER,
}

end
function modifier_puck_coil_orb_blind:GetBonusVisionPercentage() 
if self:GetParent():IsHero() then 
 return  -100  else return 0 end end
 
function modifier_puck_coil_orb_blind:GetModifierNoVisionOfAttacker() 
if self:GetParent():IsHero() then 
 return  1  
else 
  return 0
   end 
 end 


function modifier_puck_coil_orb_blind:GetEffectName() return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf" end
 
function modifier_puck_coil_orb_blind:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end










modifier_puck_coil_speed = class({})

function modifier_puck_coil_speed:IsHidden() return false end
function modifier_puck_coil_speed:IsPurgable() return true end
function modifier_puck_coil_speed:GetTexture() return "buffs/orb_speed" end
function modifier_puck_coil_speed:GetEffectName() return "particles/puck_orb_speed.vpcf" end

function modifier_puck_coil_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_puck_coil_speed:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().cd_speed
end




modifier_puck_coil_orb_damage = class({})
function modifier_puck_coil_orb_damage:IsHidden() return false end
function modifier_puck_coil_orb_damage:IsPurgable() return false end
function modifier_puck_coil_orb_damage:GetTexture() return "buffs/orb_damage" end
function modifier_puck_coil_orb_damage:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true 

self:SetStackCount(1)  

local particle_cast = "particles/units/heroes/hero_marci/orb_damage_stack.vpcf"

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

self:AddParticle(effect_cast,false, false, -1, false, false)

self.effect_cast = effect_cast
end

function modifier_puck_coil_orb_damage:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().damage_stack_max then return end
self:IncrementStackCount()
end

function modifier_puck_coil_orb_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_puck_coil_orb_damage:OnTooltip()
return self:GetStackCount()*(self:GetAbility().damage_stack_init + self:GetAbility().damage_stack_inc*self:GetCaster():GetUpgradeStack("modifier_puck_orb_distance"))
end

function modifier_puck_coil_orb_damage:OnStackCountChanged(iStackCount)
if not self.effect_cast then return end
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end



modifier_puck_coil_orb_tracker = class({})
function modifier_puck_coil_orb_tracker:IsHidden() return true end
function modifier_puck_coil_orb_tracker:IsPurgable() return false end
function modifier_puck_coil_orb_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end
function modifier_puck_coil_orb_tracker:OnAttackLanded(params)
if not IsServer() then return end
if true then return end
if not self:GetParent():HasModifier("modifier_puck_orb_distance") then return end
if params.target:IsBuilding() then return end
if self:GetParent() ~= params.attacker then return end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_puck_coil_orb_damage", {duration = self:GetAbility().damage_stack_duration})


end












modifier_puck_coil_orb_attackspeed = class({})
function modifier_puck_coil_orb_attackspeed:IsHidden() return false end
function modifier_puck_coil_orb_attackspeed:GetTexture() return "buffs/orb_attack_speed" end
function modifier_puck_coil_orb_attackspeed:IsPurgable() return true end

function modifier_puck_coil_orb_attackspeed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

end
function modifier_puck_coil_orb_attackspeed:GetModifierAttackSpeedBonus_Constant()
return 
self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetCaster():GetUpgradeStack("modifier_puck_orb_cd")
end