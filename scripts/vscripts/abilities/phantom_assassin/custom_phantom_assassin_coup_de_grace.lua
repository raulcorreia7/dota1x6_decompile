LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_stack", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_legendary", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_legendaryself", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_speed", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_stack_cd", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_armor", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_resist", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_kills", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_blood", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_blood_count", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )



    
custom_phantom_assassin_coup_de_grace = class({})

custom_phantom_assassin_coup_de_grace.legendary_damage = 20
custom_phantom_assassin_coup_de_grace.legendary_cd = 60
custom_phantom_assassin_coup_de_grace.legendary_cd_normal = 60
custom_phantom_assassin_coup_de_grace.legendary_duration = 60
custom_phantom_assassin_coup_de_grace.legendary_damage_inc = 20

custom_phantom_assassin_coup_de_grace.chance_init = 1
custom_phantom_assassin_coup_de_grace.chance_inc = 2

custom_phantom_assassin_coup_de_grace.blood_duration = 4
custom_phantom_assassin_coup_de_grace.blood_interval = 1
custom_phantom_assassin_coup_de_grace.blood_damage_init = 0.1
custom_phantom_assassin_coup_de_grace.blood_damage_inc = 0.1

custom_phantom_assassin_coup_de_grace.lowhp = 18

custom_phantom_assassin_coup_de_grace.speed = 120
custom_phantom_assassin_coup_de_grace.speed_hits = 1

custom_phantom_assassin_coup_de_grace.heal_init = 0.1
custom_phantom_assassin_coup_de_grace.heal_inc = 0.1

custom_phantom_assassin_coup_de_grace.resist_duration = 1
custom_phantom_assassin_coup_de_grace.resist = 50



function custom_phantom_assassin_coup_de_grace:GetIntrinsicModifierName()
  return "modifier_phantom_assassin_phantom_coup_de_grace"
end

function custom_phantom_assassin_coup_de_grace:GetBehavior()
  if self:GetCaster():HasModifier("modifier_phantom_assassin_crit_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end

--function custom_phantom_assassin_coup_de_grace:GetAbilityTargetTeam()
  --  return DOTA_UNIT_TARGET_TEAM_ENEMY

--end

--function custom_phantom_assassin_coup_de_grace:GetCastRange(vLocation, hTarget)
--if self:GetCaster():HasModifier("modifier_phantom_assassin_crit_legendary") then
 --return 1500
--else 
--return 0
--end
--end

--function custom_phantom_assassin_coup_de_grace:GetAbilityTargetType()
--return DOTA_UNIT_TARGET_HERO
--end


--function custom_phantom_assassin_coup_de_grace:OnAbilityPhaseInterrupted()
--if not IsServer() then return end


--self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)

 -- end

--function custom_phantom_assassin_coup_de_grace:OnAbilityPhaseStart()

--if self:GetCursorTarget():GetHealthPercent() < self.legendary_health then 
--CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerID()), "CreateIngameErrorMessage", {message = "#vendetta_health"})
 --return false end

--self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.9)
--return true 
--end


function custom_phantom_assassin_coup_de_grace:OnSpellStart()
if not IsServer() then return end


  local p = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES +  DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false)
  
  if #p < 1 then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerID()), "CreateIngameErrorMessage", {message = "#vendetta_notargets"})
    return 
  end


  self:GetCaster():EmitSound("Phantom_Assassin.SuperCrit")

  --self.target = self:GetCursorTarget()
  --if target then 
   -- self.target = target
 -- end

 local particle = ParticleManager:CreateParticle( "particles/pa_cry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() ) 
     
   ParticleManager:ReleaseParticleIndex( particle )


  self.target = p[RandomInt(1, #p)]


  self:SetActivated(false)
  local mod = self.target:AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_coup_de_grace_legendary", {duration = self.legendary_duration})
  mod.pa_mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_coup_de_grace_legendaryself", {duration = self.legendary_duration})
 

end


modifier_phantom_assassin_phantom_coup_de_grace_legendary = class({})

function modifier_phantom_assassin_phantom_coup_de_grace_legendary:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendary:IsHidden() return true end
function modifier_phantom_assassin_phantom_coup_de_grace_legendary:GetTexture() return "buffs/odds_fow" end
function modifier_phantom_assassin_phantom_coup_de_grace_legendary:RemoveOnDeath() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendary:OnCreated(table) 
if not IsServer() then  return end
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.RemoveForDuel = true

self.duration = 0


self.particle_trail = ParticleManager:CreateParticleForTeam("particles/lc_odd_charge_mark.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent, self.caster:GetTeamNumber())
self:AddParticle(self.particle_trail, false, false, -1, false, false)

self.particle_trail_fx = ParticleManager:CreateParticleForTeam("particles/pa_vendetta.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.caster:GetTeamNumber())
self:AddParticle(self.particle_trail_fx, false, false, -1, false, false)

self.kill_done = false
self:StartIntervalThink(FrameTime())
end


function modifier_phantom_assassin_phantom_coup_de_grace_legendary:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

 AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, FrameTime(), false)

end


function modifier_phantom_assassin_phantom_coup_de_grace_legendary:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
  MODIFIER_EVENT_ON_DEATH,
  MODIFIER_EVENT_ON_RESPAWN
}

end

function modifier_phantom_assassin_phantom_coup_de_grace_legendary:OnDeath(params)
if not IsServer() then return end

if params.unit == self:GetCaster() and not self:GetCaster():IsReincarnating() then 
  self:Destroy()
end

  if params.unit == self:GetParent() then 
    if self:GetCaster() == params.attacker then  
      self.kill_done = true 
      self:Destroy()
    else 

     -- self.duration = self:GetRemainingTime()

      --self:SetDuration(99999, true)
     -- if self.pa_mod then 

        --self.pa_mod:SetDuration(99999, true)
      --end

    end

  end

end


function modifier_phantom_assassin_phantom_coup_de_grace_legendary:OnRespawn(params)
if self:GetParent() ~= params.unit then return end

--self:SetDuration(self.duration, true)


--if self.pa_mod then 
    --self.pa_mod:SetDuration(self.duration, true)
--end

end



function modifier_phantom_assassin_phantom_coup_de_grace_legendary:OnDestroy()
if not IsServer() then return end
self:GetAbility():SetActivated(true)
local mod = self:GetCaster():FindModifierByName("modifier_phantom_assassin_phantom_coup_de_grace_legendaryself")
if mod then 
  mod:Destroy()
end

if self.kill_done == false then 
  self:GetAbility():StartCooldown(self:GetAbility().legendary_cd)
else 
  if self:GetParent():IsRealHero() then 
     self:GetAbility():StartCooldown(self:GetAbility().legendary_cd_normal)

     local mod = self:GetCaster():FindModifierByName("modifier_phantom_assassin_phantom_coup_de_grace_kills")

     if mod then 
       mod:IncrementStackCount()
       mod:PlayEffect()
     end

     
   end
end

end

function modifier_phantom_assassin_phantom_coup_de_grace_legendary:GetModifierIncomingDamage_Percentage(params) 
if params.attacker == self:GetCaster() then 
  return self:GetAbility().legendary_damage_inc 
end
return
end



modifier_phantom_assassin_phantom_coup_de_grace = class({})

function modifier_phantom_assassin_phantom_coup_de_grace:IsHidden()
  return true
end

function modifier_phantom_assassin_phantom_coup_de_grace:IsPurgable()
  return false
end

function modifier_phantom_assassin_phantom_coup_de_grace:OnCreated( kv )

  self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
  self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
 
end

function modifier_phantom_assassin_phantom_coup_de_grace:OnRefresh( kv )

  self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
  self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
end

function modifier_phantom_assassin_phantom_coup_de_grace:GetCritDamage() return self:GetAbility():GetSpecialValueFor( "damage" ) end

function modifier_phantom_assassin_phantom_coup_de_grace:DeclareFunctions()
 return  {
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }

end


function modifier_phantom_assassin_phantom_coup_de_grace:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_crit_damage") then return end
if params.attacker ~= self:GetParent() then return end
if params.inflictor ~= nil then return end
if params.unit:IsBuilding() then return end

if self.record then 

    local heal = params.damage*(self:GetAbility().heal_init + self:GetAbility().heal_inc*self:GetParent():GetUpgradeStack("modifier_phantom_assassin_crit_damage"))

    self:GetParent():Heal(heal, self:GetParent())

    local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:ReleaseParticleIndex( particle )
end

end

function modifier_phantom_assassin_phantom_coup_de_grace:GetModifierPreAttack_CriticalStrike( params )
  if not IsServer() then return end
  if self:GetParent():PassivesDisabled() then return end

  if params.target:IsBuilding() then return end 
   
      self.chance = self:GetAbility():GetSpecialValueFor( "chance" )

    if self:GetParent():HasModifier("modifier_phantom_assassin_crit_chance") then 
      local bonus = 0
      bonus = self:GetAbility().chance_init + self:GetAbility().chance_inc*my_game:GetUpgradeStack(self:GetParent(),"modifier_phantom_assassin_crit_chance")
      self.chance = self.chance + bonus
    end
    

     local random = RollPseudoRandomPercentage(self.chance,123,self:GetParent())

 


      self.record = nil
    
    if random 
      or (params.target:GetHealthPercent() <= self:GetAbility().lowhp and self:GetParent():HasModifier("modifier_phantom_assassin_crit_lowhp")) then
      self.record = params.record

         self.damagelose = true 
         self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) 

         if self:GetParent():HasModifier("modifier_phantom_assassin_phantom_coup_de_grace_kills") then 
          self.damage = self.damage + self:GetAbility().legendary_damage*self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_phantom_coup_de_grace_kills")
        end

      return self.damage
    end

end


function modifier_phantom_assassin_phantom_coup_de_grace:GetModifierProcAttack_Feedback( params )
if self:GetParent():PassivesDisabled() then return end
if not IsServer() then return end
if not self.record or params.target:IsBuilding() then return end


if self:GetParent():HasModifier("modifier_phantom_assassin_crit_stack") then 
  local damage = params.damage*(self:GetAbility().blood_damage_init + self:GetAbility().blood_damage_inc*self:GetParent():GetUpgradeStack("modifier_phantom_assassin_crit_stack"))

  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_blood", {duration = self:GetAbility().blood_duration, damage = damage})
  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_blood_count", {duration = self:GetAbility().blood_duration})
end
--------------------------------------------ТАЛАНТ СКОРОСТЬ-------------------------------------------------
  if self:GetParent():HasModifier("modifier_phantom_assassin_crit_speed") then 
   
      self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_speed", {})
  end


--------------------------------------------ТАЛАНТ ВОРОВСТВО ХП-------------------------------------------------
    if  (self:GetParent():HasModifier("modifier_phantom_assassin_crit_steal")) then 

        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_resist", {duration = self:GetAbility().resist_duration})
  
    end

---------------------------------------------------------------------------------------------------------------------------------
      
      self:PlayEffects( params.target )
   


end



function modifier_phantom_assassin_phantom_coup_de_grace:PlayEffects( target )

  local sound_cast = "Hero_PhantomAssassin.CoupDeGrace"

  -- if target:IsMechanical() then
  --  particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_mechanical.vpcf"
  --  sound_cast = "Hero_PhantomAssassin.CoupDeGrace.Mech"
  -- end

  -- Create Particle
 local coup_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControlEnt(coup_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(coup_pfx, 1, target:GetAbsOrigin())
        local line = (target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
        ParticleManager:SetParticleControlOrientation(coup_pfx, 1, line*-1, self:GetParent():GetRightVector(), self:GetParent():GetUpVector())
        ParticleManager:ReleaseParticleIndex(coup_pfx)

      target:EmitSound(sound_cast)

     if self:GetCaster():GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then 
       target:EmitSound("Hero_PhantomAssassin.Arcana_Layer")
        local coup_pfx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControlEnt(coup_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(coup_pfx, 1, target:GetAbsOrigin())
        local line = (target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
        ParticleManager:SetParticleControlOrientation(coup_pfx, 1, line*-1, self:GetParent():GetRightVector(), self:GetParent():GetUpVector())
        ParticleManager:ReleaseParticleIndex(coup_pfx)

       
    end


end

----------------------------------------------ТАЛАНТ ГАРАНТИРОВАННЫЙ КРИТ--------------------------------------------------------------------------------------------
modifier_phantom_assassin_phantom_coup_de_grace_stack = class({})

function modifier_phantom_assassin_phantom_coup_de_grace_stack:IsHidden() 

if self:GetParent():HasModifier("modifier_phantom_assassin_phantom_coup_de_grace_stack_cd") then 
  return true end
  return false
   end
function modifier_phantom_assassin_phantom_coup_de_grace_stack:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_stack:GetTexture() return "buffs/Crit_stack" end
function modifier_phantom_assassin_phantom_coup_de_grace_stack:RemoveOnDeath() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_stack:DeclareFunctions()

return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_phantom_assassin_phantom_coup_de_grace_stack:OnTooltip()
return 10
end



modifier_phantom_assassin_phantom_coup_de_grace_stack_cd = class({})

function modifier_phantom_assassin_phantom_coup_de_grace_stack_cd:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_stack_cd:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_stack_cd:RemoveOnDeath() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_stack_cd:GetTexture() return "buffs/Crit_stack" end
function modifier_phantom_assassin_phantom_coup_de_grace_stack_cd:OnCreated(table)
  
  self.RemoveForDuel = true
end
function modifier_phantom_assassin_phantom_coup_de_grace_stack_cd:IsDebuff() return true end




modifier_phantom_assassin_phantom_coup_de_grace_armor = class({})


function modifier_phantom_assassin_phantom_coup_de_grace_armor:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_armor:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_armor:GetTexture() return "buffs/Crit_stack" end

function modifier_phantom_assassin_phantom_coup_de_grace_armor:OnCreated(table)
if not IsServer() then return end
self.armor = self:GetParent():GetPhysicalArmorValue(false)*self:GetAbility().crit_armor
if self.armor > 0 then 
  self.armor = 0
end

end

function modifier_phantom_assassin_phantom_coup_de_grace_armor:DeclareFunctions()
  return 
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
  MODIFIER_PROPERTY_TOOLTIP,
  MODIFIER_EVENT_ON_TAKEDAMAGE
}

end

function modifier_phantom_assassin_phantom_coup_de_grace_armor:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker == self:GetCaster() then 
  self:Destroy()
end
end



function modifier_phantom_assassin_phantom_coup_de_grace_armor:OnTooltip()
return  -self:GetAbility().crit_armor
end


function modifier_phantom_assassin_phantom_coup_de_grace_armor:GetModifierPhysicalArmorBonus() return self.armor end




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------ТАЛАНТ CКОРОСТЬ--------------------------------------------------------------------------------------------
modifier_phantom_assassin_phantom_coup_de_grace_speed = class({})


function modifier_phantom_assassin_phantom_coup_de_grace_speed:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_speed:IsPurgable() return true end


function modifier_phantom_assassin_phantom_coup_de_grace_speed:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.stack =  self:GetAbility().speed_hits*my_game:GetUpgradeStack(self:GetParent(),"modifier_phantom_assassin_crit_speed")
self:SetStackCount(self.stack + 1)
end

function modifier_phantom_assassin_phantom_coup_de_grace_speed:OnRefresh(table)
if not IsServer() then return end
  self:OnCreated()
end

function modifier_phantom_assassin_phantom_coup_de_grace_speed:GetTexture() return "buffs/Crit_speed" end

function modifier_phantom_assassin_phantom_coup_de_grace_speed:DeclareFunctions()

  return
  {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
      MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
  MODIFIER_PROPERTY_TOOLTIP}
end



function modifier_phantom_assassin_phantom_coup_de_grace_speed:OnTooltip()
return self:GetAbility().speed
end


function modifier_phantom_assassin_phantom_coup_de_grace_speed:GetModifierAttackSpeedBonus_Constant() return self:GetAbility().speed
 end



function modifier_phantom_assassin_phantom_coup_de_grace_speed:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_custom_phantom_assassin_stifling_dagger_attack") and self:GetStackCount() ~= self.stack + 1
 then return end

if self:GetParent() == params.attacker then 
  self:SetStackCount(self:GetStackCount()-1)
  if self:GetStackCount() == 0 then 
    self:Destroy()
  end
end

end



------------------------------------------------------------------------------------------------------------------------------------------



----------------------------------------ТАЛАНТ ВОРОВСТВО ХП--------------------------------------------------------------------------------
modifier_phantom_assassin_phantom_coup_de_grace_resist = class({})

function modifier_phantom_assassin_phantom_coup_de_grace_resist:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_resist:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_resist:IsDebuff() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_resist:GetTexture() return "buffs/Crit_resist" end
function modifier_phantom_assassin_phantom_coup_de_grace_resist:GetEffectName() return "particles/items4_fx/ascetic_cap.vpcf" end


function modifier_phantom_assassin_phantom_coup_de_grace_resist:DeclareFunctions()
return 
{

  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}

end

function modifier_phantom_assassin_phantom_coup_de_grace_resist:GetModifierStatusResistanceStacking()
return self:GetAbility().resist end


------------------------------------------------------------------------------------------------------------------------

modifier_phantom_assassin_phantom_coup_de_grace_kills = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_kills:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_kills:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_kills:RemoveOnDeath() return false end




function modifier_phantom_assassin_phantom_coup_de_grace_kills:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_phantom_assassin_phantom_coup_de_grace_kills:OnTooltip()
return 
self:GetAbility():GetSpecialValueFor("damage") + self:GetAbility().legendary_damage*self:GetStackCount()
end

function modifier_phantom_assassin_phantom_coup_de_grace_kills:PlayEffect()
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle( "particles/pa_arc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() ) 
     
  self:GetCaster():EmitSound("Phantom_Assassin.SuperCrit")

        Timers:CreateTimer(1,function()
   ParticleManager:DestroyParticle( self.particle , false)
   ParticleManager:ReleaseParticleIndex( self.particle )
    end)
end
 


modifier_phantom_assassin_phantom_coup_de_grace_legendaryself = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_legendaryself:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendaryself:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendaryself:RemoveOnDeath() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendaryself:GetTexture() return "buffs/odds_fow" end



modifier_phantom_assassin_phantom_coup_de_grace_blood = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_blood:IsHidden() return true end
function modifier_phantom_assassin_phantom_coup_de_grace_blood:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_blood:GetTexture() return "buffs/Crit_blood" end
function modifier_phantom_assassin_phantom_coup_de_grace_blood:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_phantom_assassin_phantom_coup_de_grace_blood:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true

self.damage = table.damage/self:GetRemainingTime()

self:StartIntervalThink(1)
end 

function modifier_phantom_assassin_phantom_coup_de_grace_blood:OnIntervalThink()
if not IsServer() then return end


local damageTable = 
{
  victim      = self:GetParent(),
  damage      = self.damage,
  damage_type   = DAMAGE_TYPE_MAGICAL,
  damage_flags  = DOTA_DAMAGE_FLAG_NONE,
  attacker    = self:GetCaster(),
  ability     = self:GetAbility()
}
                  
ApplyDamage(damageTable)
      
SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.damage, nil)


end

function modifier_phantom_assassin_phantom_coup_de_grace_blood:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_phantom_assassin_phantom_coup_de_grace_blood_count")

if mod then 
  mod:DecrementStackCount()
end

end



modifier_phantom_assassin_phantom_coup_de_grace_blood_count = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_blood_count:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_blood_count:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_blood_count:GetTexture() return "buffs/Crit_blood" end
function modifier_phantom_assassin_phantom_coup_de_grace_blood_count:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(1)
end

function modifier_phantom_assassin_phantom_coup_de_grace_blood_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end