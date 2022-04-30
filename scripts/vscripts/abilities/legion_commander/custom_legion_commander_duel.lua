LinkLuaModifier("modifier_duel_buff", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_damage", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_return", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_legendary_health", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_legendary_speed", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_legendary_cdr", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_legendary_count", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_win_duration", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_lowhp", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_tracker", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_mini", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_mini_speed", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_mini_cd", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)


custom_legion_commander_duel = class({})

custom_legion_commander_duel.damage_inc = 0.25

custom_legion_commander_duel.speed_init = 15
custom_legion_commander_duel.speed_inc = 15

custom_legion_commander_duel.return_init = 0.10
custom_legion_commander_duel.return_inc = 0.10

custom_legion_commander_duel.legendary_speed = 15
custom_legion_commander_duel.legendary_health = 150
custom_legion_commander_duel.legendary_cdr = 5
custom_legion_commander_duel.legendary_range = 150
custom_legion_commander_duel.legendary_cdr_max = 50

custom_legion_commander_duel.win_cd = 15
custom_legion_commander_duel.win_duration = 3

custom_legion_commander_duel.heal_heal = -30

custom_legion_commander_duel.passive_cd_min = 40
custom_legion_commander_duel.passive_cd_max = 80
custom_legion_commander_duel.passive_duration = 4
custom_legion_commander_duel.passive_damage_init = 2
custom_legion_commander_duel.passive_damage_inc = 2

custom_legion_commander_duel.scepter_cd = -25
custom_legion_commander_duel.scepter_damage = 10

function custom_legion_commander_duel:GetCastRange(vLocation, hTarget)
local upgrade = self.legendary_range*self:GetCaster():GetUpgradeStack("modifier_legion_duel_legendary")
 return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end


function custom_legion_commander_duel:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasScepter() then 
  upgrade_cooldown = self.scepter_cd
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end


function custom_legion_commander_duel:GetIntrinsicModifierName() return "modifier_duel_tracker" end

function custom_legion_commander_duel:OnSpellStart(target)

self.target = self:GetCursorTarget()
  if target ~= nil then 
    self.target = target
  end


self.caster = self:GetCaster()
self.duration = self:GetSpecialValueFor("duration")


if self.target:TriggerSpellAbsorb(self) then return end

if self:GetCaster():HasScepter() then 
  --self.duration = self:GetSpecialValueFor("duration_scepter")

end
 



local duration = (1 - self.target:GetStatusResistance())*self.duration


self.caster:EmitSound("Hero_LegionCommander.Duel.Cast")
self.caster:AddNewModifier(self.caster, self, "modifier_duel_buff", {duration = duration, target = self.target:entindex()})
self.target:AddNewModifier(self.caster, self, "modifier_duel_buff", {duration = duration, target = self.caster:entindex()})

if self.caster:HasModifier("modifier_legion_duel_return") then 
	self.caster:AddNewModifier(self.caster, self, "modifier_duel_return", {duration = duration})
end

if self.caster:HasModifier("modifier_legion_duel_blood") then 
  self.caster:AddNewModifier(self.caster, self, "modifier_duel_lowhp", {duration = duration})
  self.target:AddNewModifier(self.caster, self, "modifier_duel_lowhp", {duration = duration})
end


end


function custom_legion_commander_duel:WinDuel(caster, winner, loser)
if not IsServer() then return end
if loser:HasModifier("modifier_legion_duel_win") then return end

local mod = winner:FindModifierByName("modifier_duel_damage")

    if not mod then 
      mod = winner:AddNewModifier(winner, self, "modifier_duel_damage", {})
    end 

    local damage = self:GetSpecialValueFor("reward_damage")

    if caster:HasScepter() then 
        damage = damage + self.scepter_damage
    end


  mod:SetStackCount(mod:GetStackCount() + damage) 
  

  if winner:HasModifier("modifier_legion_duel_legendary") then 

    local count = winner:FindModifierByName("modifier_duel_legendary_count")
    if not count then 
      winner:AddNewModifier(winner, self, "modifier_duel_legendary_count", {})
    end
    local name = ""

    if loser:GetPrimaryAttribute() == 0 then name = "modifier_duel_legendary_health" end
    if loser:GetPrimaryAttribute() == 1 then name = "modifier_duel_legendary_speed" end
    if loser:GetPrimaryAttribute() == 2 then name = "modifier_duel_legendary_cdr" end

    winner:AddNewModifier(winner, self, name, {})

  end



  local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, winner)
  winner:EmitSound("Hero_LegionCommander.Duel.Victory")

  if winner == caster then 
    local ability = winner:FindAbilityByName("custom_legion_commander_press_the_attack")
    if ability and ability:GetLevel() > 0 then 

        ability:OnSpellStart(winner)
    end
  end  

end








modifier_duel_buff = class({})
function modifier_duel_buff:IsHidden() return false end
function modifier_duel_buff:IsPurgable() return false end
function modifier_duel_buff:IsDebuff() return true end
function modifier_duel_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_duel_buff:DeclareFunctions()
if self:GetCaster():HasModifier("modifier_legion_duel_speed") then 
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_duel_buff:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end
if not self:GetCaster():HasScepter() then return end
if params.attacker == self.target then return end

return -50

end




function modifier_duel_buff:GetModifierAttackSpeedBonus_Constant()
return
self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetCaster():GetUpgradeStack("modifier_legion_duel_speed")
end



function modifier_duel_buff:OnCreated(table)
 if not IsServer() then return end	

  self.RemoveForDuel = true
  self.target = EntIndexToHScript(table.target)

  self:GetParent():SetForceAttackTarget(self.target)
  self:GetParent():MoveToTargetToAttack(self.target)

  if self:GetCaster() == self:GetParent() then 
  	self:GetCaster().particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_duel_ring.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
  	
	self:GetCaster():EmitSound("Hero_LegionCommander.Duel")
    local center_point = self.target:GetAbsOrigin() + ((self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()) / 1)
    ParticleManager:SetParticleControl(self:GetCaster().particle, 0, center_point)
    ParticleManager:SetParticleControl(self:GetCaster().particle, 7, center_point)

  end

  self:StartIntervalThink(0.1)
end

function modifier_duel_buff:OnIntervalThink()
if not IsServer() then return end	
  self:GetParent():SetForceAttackTarget(self.target)
  self:GetParent():MoveToTargetToAttack(self.target)


  if not self.target:IsAlive()  then 


  	if self:GetParent() == self:GetCaster() and self:GetParent():HasModifier("modifier_legion_duel_win") then
  		local ability = self:GetParent():FindAbilityByName("custom_legion_commander_duel")
  		if ability then 
  			local cd = ability:GetCooldownTimeRemaining()
			ability:EndCooldown()
			ability:StartCooldown(cd - self:GetAbility().win_cd)
  		end
  	end

  	if not self.target:IsRealHero() then 
  		self:Destroy()
  		return
  	end

  	self:GetAbility():WinDuel(self:GetCaster(), self:GetParent(), self.target)


  	self:Destroy()
  end

  if (self:GetParent():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() > self:GetAbility():GetSpecialValueFor("victory_range") then 
  	self:Destroy()
  end

end

function modifier_duel_buff:OnDestroy()
  if not IsServer() then return end


  if self:GetParent():HasModifier("modifier_duel_return") then 
  	self:GetParent():RemoveModifierByName("modifier_duel_return")
  end

	if self:GetParent():HasModifier("modifier_duel_lowhp") then 
   self:GetParent():RemoveModifierByName("modifier_duel_lowhp")
  end

  if self.target:HasModifier("modifier_duel_lowhp") then 
   self.target:RemoveModifierByName("modifier_duel_lowhp")
  end

 self:GetCaster():StopSound("Hero_LegionCommander.Duel")

  if self:GetCaster().particle then 
  	ParticleManager:DestroyParticle(self:GetCaster().particle, false)
  end

  if self:GetParent():IsAlive() and self.target:IsAlive() and self:GetCaster():HasModifier("modifier_legion_duel_win") then 
    if self:GetParent() ~= self:GetCaster() then 
      self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_duel_win_duration", {duration = self:GetAbility().win_duration})
    end
  end

  self:GetParent():SetForceAttackTarget(nil)
end

function modifier_duel_buff:CheckState()

return {
  [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  [MODIFIER_STATE_TAUNTED] = true, 
  [MODIFIER_STATE_SILENCED] = true
}
 
end



modifier_duel_damage = class({})
function modifier_duel_damage:IsHidden() return false end
function modifier_duel_damage:IsPurgable() return false end
function modifier_duel_damage:RemoveOnDeath() return false end
function modifier_duel_damage:GetTexture() return "legion_commander_duel" end
function modifier_duel_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end

function modifier_duel_damage:GetModifierPreAttack_BonusDamage() return self:GetStackCount() end



modifier_duel_return = class({})
function modifier_duel_return:IsHidden() return true end
function modifier_duel_return:IsPurgable() return false end
function modifier_duel_return:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}

end



function modifier_duel_return:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() == params.unit then
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

	local target = params.attacker
	local damage_return = self:GetAbility().return_init + self:GetAbility().return_inc*self:GetParent():GetUpgradeStack("modifier_legion_duel_return")
   ApplyDamage({victim = target, attacker = self:GetParent(), damage = params.original_damage*damage_return, damage_type = params.damage_type,  damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION, ability = self:GetAbility()})


end

end





modifier_duel_legendary_speed = class({})
function modifier_duel_legendary_speed:IsHidden() return true  end
function modifier_duel_legendary_speed:IsPurgable() return false end
function modifier_duel_legendary_speed:RemoveOnDeath() return false end
function modifier_duel_legendary_speed:OnCreated(table)

if not IsServer() then return end
self:SetStackCount(self:GetAbility().legendary_speed)
end

function modifier_duel_legendary_speed:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount() + self:GetAbility().legendary_speed)
end




modifier_duel_legendary_health = class({})
function modifier_duel_legendary_health:IsHidden() return true end
function modifier_duel_legendary_health:IsPurgable() return false end
function modifier_duel_legendary_health:RemoveOnDeath() return false end

function modifier_duel_legendary_health:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(self:GetAbility().legendary_health)
end

function modifier_duel_legendary_health:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount() + self:GetAbility().legendary_health)
end



modifier_duel_legendary_cdr = class({})
function modifier_duel_legendary_cdr:IsHidden() return true  end
function modifier_duel_legendary_cdr:IsPurgable() return false end
function modifier_duel_legendary_cdr:RemoveOnDeath() return false end

function modifier_duel_legendary_cdr:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(self:GetAbility().legendary_cdr)
end

function modifier_duel_legendary_cdr:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().legendary_cdr_max then return end
self:SetStackCount(self:GetStackCount() + self:GetAbility().legendary_cdr)
end

modifier_duel_legendary_count = class({})
function modifier_duel_legendary_count:IsHidden() return false end
function modifier_duel_legendary_count:IsPurgable() return false end
function modifier_duel_legendary_count:RemoveOnDeath() return false end
function modifier_duel_legendary_count:GetTexture() return "buffs/duel_win" end
function modifier_duel_legendary_count:DeclareFunctions()
return
{
MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
MODIFIER_PROPERTY_HEALTH_BONUS,
MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_duel_legendary_count:GetModifierPercentageCooldown()
return self:GetParent():GetUpgradeStack("modifier_duel_legendary_cdr")
end


function modifier_duel_legendary_count:GetModifierHealthBonus()
return self:GetParent():GetUpgradeStack("modifier_duel_legendary_health")
end



function modifier_duel_legendary_count:GetModifierAttackSpeedBonus_Constant()
	return self:GetParent():GetUpgradeStack("modifier_duel_legendary_speed")
end



modifier_duel_win_duration = class({})
function modifier_duel_win_duration:IsHidden() return false end
function modifier_duel_win_duration:IsPurgable() return false end
function modifier_duel_win_duration:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_DEATH
}

end
function modifier_duel_win_duration:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if not self:GetCaster():IsAlive() then return end  
    
    self:GetAbility():WinDuel(self:GetCaster(), self:GetCaster(), self:GetParent())
    self:Destroy()
end




modifier_duel_lowhp = class({})
function modifier_duel_lowhp:IsHidden() return false end
function modifier_duel_lowhp:IsPurgable() return false end
function modifier_duel_lowhp:GetTexture() return "buffs/duel_lowhp" end




function modifier_duel_lowhp:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
    }
 end

function modifier_duel_lowhp:GetModifierLifestealRegenAmplify_Percentage() 
local k = 1
if self:GetCaster() == self:GetParent() then 
  k = -1
end 
    return self:GetAbility().heal_heal*k

end
function modifier_duel_lowhp:GetModifierHealAmplify_PercentageTarget() 
local k = 1
if self:GetCaster() == self:GetParent() then 
  k = -1
end 
    return self:GetAbility().heal_heal*k

end

function modifier_duel_lowhp:GetModifierHPRegenAmplify_Percentage() 
local k = 1
if self:GetCaster() == self:GetParent() then 
  k = -1
end 
    return self:GetAbility().heal_heal*k

end




modifier_duel_tracker = class({})
function modifier_duel_tracker:IsHidden() return true end
function modifier_duel_tracker:IsPurgable() return false end
function modifier_duel_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED
}

end
function modifier_duel_tracker:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if not params.target:IsCreep() then return end
if not self:GetParent():HasModifier("modifier_legion_duel_passive") then return end
if params.target:HasModifier("modifier_duel_mini") then return end
if self:GetParent():HasModifier("modifier_duel_mini_cd") then return end


  local duration_cd = RandomInt(self:GetAbility().passive_cd_min, self:GetAbility().passive_cd_max)
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_duel_mini_cd", {duration = duration_cd})

  local duration = self:GetAbility().passive_duration
  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_duel_mini", {duration = duration})

  if self:GetParent():HasModifier("modifier_legion_duel_return") then 
      self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_duel_return", {duration = duration})
  end


  if self:GetParent():HasModifier("modifier_legion_duel_blood") then 
   self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_duel_lowhp", {duration = duration})
  end


   if self:GetParent():HasModifier("modifier_legion_duel_speed") then 
     self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_duel_mini_speed", {duration = duration})
  end



end


modifier_duel_mini = class({})
function modifier_duel_mini:IsHidden() return false end
function modifier_duel_mini:IsPurgable() return false end
function modifier_duel_mini:GetTexture() return "buffs/duel_mini" end
function modifier_duel_mini:GetEffectName() return "particles/lc_odd_charge_mark.vpcf" end
function modifier_duel_mini:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_duel_mini:OnCreated(table)
if not IsServer() then return end
  
  self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_duel_ring.vpcf", PATTACH_ABSORIGIN, self:GetParent())
    
  self:GetParent():EmitSound("Hero_LegionCommander.Duel")
    local center_point = self:GetParent():GetAbsOrigin()
    ParticleManager:SetParticleControl(self.particle, 0, center_point)
    ParticleManager:SetParticleControl(self.particle, 7, center_point)

end

function modifier_duel_mini:OnDestroy()
if not  IsServer() then return end
  self:GetParent():StopSound("Hero_LegionCommander.Duel")
 if self.particle then 
    ParticleManager:DestroyParticle(self.particle, false)
  end

    if self:GetCaster():HasModifier("modifier_duel_return") then 
    self:GetCaster():RemoveModifierByName("modifier_duel_return")
  end

    if self:GetCaster():HasModifier("modifier_duel_mini_speed") then 
   self:GetCaster():RemoveModifierByName("modifier_duel_mini_speed")
  end


  if self:GetCaster():HasModifier("modifier_duel_lowhp") then 
   self:GetCaster():RemoveModifierByName("modifier_duel_lowhp")
  end


end

function modifier_duel_mini:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_DEATH,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

end



function modifier_duel_mini:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
  
  local winner = self:GetCaster()

  local mod = winner:FindModifierByName("modifier_duel_damage")

    if not mod then 
      mod = winner:AddNewModifier(winner, self:GetAbility(), "modifier_duel_damage", {})
    end 

    local damage =  self:GetAbility().passive_damage_init + self:GetAbility().passive_damage_inc*winner:GetUpgradeStack("modifier_legion_duel_passive")
   

    mod:SetStackCount(mod:GetStackCount() + damage) 

      local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, winner)
      winner:EmitSound("Hero_LegionCommander.Duel.Victory")


    local ability = winner:FindAbilityByName("custom_legion_commander_press_the_attack")
    if ability and ability:GetLevel() > 0 then 

        ability:OnSpellStart(winner)
    end
   

end


function modifier_duel_mini:GetModifierAttackSpeedBonus_Constant() 
if self:GetCaster():HasModifier("modifier_legion_duel_speed") then 
 return self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetCaster():GetUpgradeStack("modifier_legion_duel_speed")
end
end


modifier_duel_mini_speed = class({})
function modifier_duel_mini_speed:IsHidden() return true end
function modifier_duel_mini_speed:IsPurgable() return false end
function modifier_duel_mini_speed:DeclareFunctions()
return
{

  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

end
function modifier_duel_mini_speed:GetModifierAttackSpeedBonus_Constant() 
if self:GetCaster():HasModifier("modifier_legion_duel_speed") then 
 return self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetCaster():GetUpgradeStack("modifier_legion_duel_speed")
end
end


modifier_duel_mini_cd = class({})
function modifier_duel_mini_cd:IsHidden() return true end
function modifier_duel_mini_cd:IsPurgable() return false end
function modifier_duel_mini_cd:RemoveOnDeath() return false end