LinkLuaModifier("modifier_custom_puck_phase_shift", "abilities/puck/custom_puck_phase_shift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_phase_shift_damage", "abilities/puck/custom_puck_phase_shift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_phase_shift_stun", "abilities/puck/custom_puck_phase_shift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_phase_shift_crit", "abilities/puck/custom_puck_phase_shift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_phase_shift_tracker", "abilities/puck/custom_puck_phase_shift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_phase_shift_resist", "abilities/puck/custom_puck_phase_shift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_phase_shift_cooldown", "abilities/puck/custom_puck_phase_shift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_phase_shift_speed", "abilities/puck/custom_puck_phase_shift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_puck_phase_shift_slow", "abilities/puck/custom_puck_phase_shift", LUA_MODIFIER_MOTION_NONE)


custom_puck_phase_shift = class({})

custom_puck_phase_shift.regen_init = 1
custom_puck_phase_shift.regen_inc = 1

custom_puck_phase_shift.damage_init = 2
custom_puck_phase_shift.damage_inc = 2
custom_puck_phase_shift.damage_duration = 1.5

custom_puck_phase_shift.stun_duration = 1.2
custom_puck_phase_shift.stun_radius = 300

custom_puck_phase_shift.attacks_radius = 750
custom_puck_phase_shift.attacks_crit_init = 50
custom_puck_phase_shift.attacks_crit_inc = 50



custom_puck_phase_shift.resist_status = 30
custom_puck_phase_shift.resist_duration = 1
custom_puck_phase_shift.resist_damage = -30

custom_puck_phase_shift.speed_init = 0
custom_puck_phase_shift.speed_inc = 10
custom_puck_phase_shift.speed_duration = 3
custom_puck_phase_shift.speed_radius = 500


custom_puck_phase_shift.legendary_speed = 2.0

function custom_puck_phase_shift:GetCooldown(iLevel)
return self:GetSpecialValueFor("cd") / ( self:GetCaster():GetCooldownReduction())
end





function custom_puck_phase_shift:GetIntrinsicModifierName()
return "modifier_custom_puck_phase_shift_tracker"
end
function custom_puck_phase_shift:GetBehavior()
  if self:GetCaster():HasModifier("modifier_puck_shift_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES end
 return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES 
end

function custom_puck_phase_shift:GetChannelTime()
if not self:GetCaster():HasModifier("modifier_puck_shift_legendary") then
	return self:GetSpecialValueFor("duration")
end
end



function custom_puck_phase_shift:OnToggle() 
if not IsServer() then return end

  local caster = self:GetCaster()
  local modifier = caster:FindModifierByName( "modifier_custom_puck_phase_shift" )


  if self:GetToggleState() then
    self:EndCooldown()
    if not modifier then
     	

	  self:GetCaster():EmitSound("puck_puck_ability_phase_0"..RandomInt(1, 7))
      self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_puck_phase_shift", {duration = self:GetSpecialValueFor("duration") + FrameTime()})
	  self:StartCooldown(self:GetSpecialValueFor("cd"))
    
    end
  else
    if modifier then
      modifier:Destroy()
    end
  end
end



function custom_puck_phase_shift:OnSpellStart()
if self:GetCaster():HasModifier("modifier_puck_shift_legendary") then return end

	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("cd"))

	if self:GetCaster():GetName() == "npc_dota_hero_puck" then
		self:GetCaster():EmitSound("puck_puck_ability_phase_0"..RandomInt(1, 7))
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_puck_phase_shift", {duration = self:GetSpecialValueFor("duration") + FrameTime()})


end

function custom_puck_phase_shift:OnChannelFinish(interrupted)

	local phase_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_custom_puck_phase_shift", self:GetCaster())

	if phase_modifier then
		phase_modifier:StartIntervalThink(FrameTime())
	end
end


modifier_custom_puck_phase_shift = class({})

function modifier_custom_puck_phase_shift:OnRefresh(table)
self:OnCreated(table)
end

function modifier_custom_puck_phase_shift:IsPurgable() return false end

function modifier_custom_puck_phase_shift:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_seer_illusion.vpcf"
end



function modifier_custom_puck_phase_shift:OnCreated(table)
	if not IsServer() then return end
	

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_puck_phase_shift_cooldown", {duration = 0.5})


	if self:GetParent():HasModifier("modifier_puck_shift_legendary") and not self:GetAbility():GetToggleState() then
		self:GetAbility():ToggleAbility()
	end

	if self:GetParent():HasModifier("modifier_puck_shift_lowhp")  then
	
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().speed_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
		for _,enemy in ipairs(enemies) do
			enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_puck_phase_shift_slow", {duration = (1 - enemy:GetStatusResistance())*self:GetAbility().speed_duration})
		end
	
	end

	if self:GetParent():HasModifier("modifier_puck_shift_legendary") then 	
		self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	end

	self:GetParent():EmitSound("Hero_Puck.Phase_Shift")
	self.RemoveForDuel = true


	ProjectileManager:ProjectileDodge(self:GetParent())
	
	if self:GetParent():HasModifier("modifier_puck_shift_damage") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_puck_phase_shift_damage", {})
	end

	if self:GetParent():HasModifier("modifier_puck_shift_stun")  then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_puck_phase_shift_stun", {})
	end



	if self:GetParent():HasModifier("modifier_puck_shift_attacks") then 
		local crit = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_puck_phase_shift_crit", {})

		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().attacks_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
		for _,enemy in ipairs(enemies) do
			self:GetParent():PerformAttack(enemy, false, true, true, false, true, false, false)
		end

		if crit then 
			crit:Destroy()
		end
	end

	if not self:GetParent():HasModifier("modifier_puck_shift_legendary") then 

		local caster = self:GetCaster()
		caster:AddEffects(EF_NODRAW)
		local pos = self:GetParent():GetAbsOrigin()
		pos.z = pos.z + 120

		self.effect_cast = ParticleManager:CreateParticle("particles/puck_phase_shift.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(self.effect_cast, 0, pos)
		ParticleManager:SetParticleControl(self.effect_cast, 1, Vector(35,0,0))
		self:AddParticle(self.effect_cast, false, false, -1, false, false)

	else 

		local phase_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_phase_shift.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(phase_particle, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(phase_particle, false, false, -1, false, false)
	

	end

end



function modifier_custom_puck_phase_shift:OnIntervalThink()
	if not IsServer() then return end

	if not self:GetAbility() or not self:GetAbility():IsChanneling() then
		self:Destroy()
	end
end

function modifier_custom_puck_phase_shift:OnDestroy()
if not IsServer() then return end
	self:GetParent():RemoveEffects(EF_NODRAW)
	self:GetParent():StopSound("Hero_Puck.Phase_Shift")


	if self:GetAbility():GetToggleState() then
		self:GetAbility():ToggleAbility()
	end

	--if self:GetParent():HasModifier("modifier_puck_shift_legendary")  then 	
		self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	--end

	local damage_mod = self:GetParent():FindModifierByName("modifier_custom_puck_phase_shift_damage")
	if damage_mod then 
		 damage_mod:SetDuration(self:GetAbility().damage_duration, true)
	end


	if self:GetParent():HasModifier("modifier_custom_puck_phase_shift_stun") then 
		self:GetParent():RemoveModifierByName("modifier_custom_puck_phase_shift_stun")
	end

	if self:GetParent():HasModifier("modifier_puck_shift_resist") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_puck_phase_shift_resist", {duration = self:GetAbility().resist_duration})
	end

	if self:GetParent():HasModifier("modifier_puck_shift_lowhp") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_puck_phase_shift_speed", {duration = self:GetAbility().speed_duration})
	end

end

function modifier_custom_puck_phase_shift:CheckState()
	local state =
	{
	[MODIFIER_STATE_INVULNERABLE] 	= true,
	[MODIFIER_STATE_OUT_OF_GAME]	= true,
	[MODIFIER_STATE_UNSELECTABLE]	= true,
	[MODIFIER_STATE_NO_HEALTH_BAR]  = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION]  = true,
	}
	
	
	return state
end

function modifier_custom_puck_phase_shift:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
	--MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE

    }
end

function modifier_custom_puck_phase_shift:GetModifierBaseAttackTimeConstant()
if self:GetCaster():HasModifier("modifier_puck_shift_legendary") then 
	return self:GetAbility().legendary_speed
end
end


function modifier_custom_puck_phase_shift:GetModifierMoveSpeed_Absolute()
--return 1
end

function modifier_custom_puck_phase_shift:GetModifierHealthRegenPercentage()
local bonus = 0
if self:GetCaster():HasModifier("modifier_puck_shift_regen") then 
	bonus = self:GetAbility().regen_init + self:GetAbility().regen_inc*self:GetParent():GetUpgradeStack("modifier_puck_shift_regen")
end
return bonus 
end


modifier_custom_puck_phase_shift_damage = class({})
function modifier_custom_puck_phase_shift_damage:IsHidden() return false end
function modifier_custom_puck_phase_shift_damage:IsPurgable() return true end
function modifier_custom_puck_phase_shift_damage:GetTexture() return "buffs/shift_damage" end
function modifier_custom_puck_phase_shift_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end
function modifier_custom_puck_phase_shift_damage:GetModifierTotalDamageOutgoing_Percentage() 
return self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetCaster():GetUpgradeStack("modifier_puck_shift_damage")
end



modifier_custom_puck_phase_shift_stun = class({})

function modifier_custom_puck_phase_shift_stun:IsHidden() return true end
function modifier_custom_puck_phase_shift_stun:IsPurgable() return false end
function modifier_custom_puck_phase_shift_stun:OnCreated(table)
if not IsServer() then return end
	
	self:StartIntervalThink(0.1)
	self.max = 32
	local time = self:GetParent():FindModifierByName("modifier_custom_puck_phase_shift"):GetRemainingTime()
	local k = 1
	if time > 2 then 
		k = 1.7
	end

	local particle_cast = "particles/puck_shift_stun.vpcf"

	if self:GetParent():HasModifier("modifier_puck_shift_legendary") then 
		self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	else 
		self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
	end

	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetAbility().stun_radius, 0, -self:GetAbility().stun_radius/k) )
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( time, 0, 0 ) )

end

function modifier_custom_puck_phase_shift_stun:OnRefresh(table)
if not IsServer() then return end

	ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	local time = self:GetParent():FindModifierByName("modifier_custom_puck_phase_shift"):GetRemainingTime()
	local k = 1
	if time > 2 then 
		k = 1.5
	end

	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"

	if self:GetParent():HasModifier("modifier_puck_shift_legendary") then 
		self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	else 
		self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
	end

	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetAbility().stun_radius, 0, -self:GetAbility().stun_radius/k) )
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( time, 0, 0 ) )

end


function modifier_custom_puck_phase_shift_stun:OnIntervalThink()
if not IsServer() then return end
	self:IncrementStackCount()
end


function modifier_custom_puck_phase_shift_stun:OnDestroy()
if not IsServer() then return end
		ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	local effect =  ParticleManager:CreateParticle("particles/puck_stun.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl( effect, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect, 1, Vector(self:GetAbility().stun_radius,0,0) )

	self:GetParent():EmitSound("Puck.Shift_Stun")

	local stun = math.min(self:GetStackCount()/self.max,1)

	stun = stun*(self:GetAbility().stun_duration)

	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	for _,enemy in ipairs(enemies) do
			enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = stun*(1 - enemy:GetStatusResistance())})

			ParticleManager:CreateParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			

	end

end




modifier_custom_puck_phase_shift_crit = class({})
function modifier_custom_puck_phase_shift_crit:IsHidden() return true end
function modifier_custom_puck_phase_shift_crit:IsPurgable() return false end
function modifier_custom_puck_phase_shift_crit:GetCritDamage() return
self:GetAbility().attacks_crit_init + self:GetAbility().attacks_crit_inc*self:GetParent():GetUpgradeStack("modifier_puck_shift_attacks")
end

function modifier_custom_puck_phase_shift_crit:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
}
end

function modifier_custom_puck_phase_shift_crit:GetModifierPreAttack_CriticalStrike( params )
return self:GetAbility().attacks_crit_init + self:GetAbility().attacks_crit_inc*self:GetParent():GetUpgradeStack("modifier_puck_shift_attacks")
end



modifier_custom_puck_phase_shift_tracker = class({})
function modifier_custom_puck_phase_shift_tracker:IsHidden() return true end
function modifier_custom_puck_phase_shift_tracker:IsPurgable() return false end
function modifier_custom_puck_phase_shift_tracker:DeclareFunctions()
return
{
}
end






modifier_custom_puck_phase_shift_resist = class({})
function modifier_custom_puck_phase_shift_resist:IsHidden() return false end
function modifier_custom_puck_phase_shift_resist:IsPurgable() return false end
function modifier_custom_puck_phase_shift_resist:GetEffectName() return "particles/puck_resist.vpcf" end
function modifier_custom_puck_phase_shift_resist:GetTexture() return "buffs/shift_resist" end
function modifier_custom_puck_phase_shift_resist:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_custom_puck_phase_shift_resist:GetModifierStatusResistanceStacking() return self:GetAbility().resist_status end
function modifier_custom_puck_phase_shift_resist:GetModifierIncomingDamage_Percentage()
 return self:GetAbility().resist_damage end





modifier_custom_puck_phase_shift_cooldown = class({})
function modifier_custom_puck_phase_shift_cooldown:IsHidden() return true end
function modifier_custom_puck_phase_shift_cooldown:IsPurgable() return false end


modifier_custom_puck_phase_shift_speed = class({})
function modifier_custom_puck_phase_shift_speed:IsHidden() return false end
function modifier_custom_puck_phase_shift_speed:IsPurgable() return true end
function modifier_custom_puck_phase_shift_speed:GetEffectName() return "particles/puck_orb_speed.vpcf" end
function modifier_custom_puck_phase_shift_speed:GetTexture() return "buffs/shift_lowhp" end

function modifier_custom_puck_phase_shift_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_custom_puck_phase_shift_speed:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetCaster():GetUpgradeStack("modifier_puck_shift_lowhp")
end


modifier_custom_puck_phase_shift_slow = class({})
function modifier_custom_puck_phase_shift_slow:IsHidden() return false end
function modifier_custom_puck_phase_shift_slow:IsPurgable() return true end
function modifier_custom_puck_phase_shift_slow:GetTexture() return "buffs/shift_lowhp" end

function modifier_custom_puck_phase_shift_slow:GetEffectName()
  return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end


function modifier_custom_puck_phase_shift_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end

function modifier_custom_puck_phase_shift_slow:GetModifierMoveSpeedBonus_Percentage()
return -self:GetAbility().speed_init - self:GetAbility().speed_inc*self:GetCaster():GetUpgradeStack("modifier_puck_shift_lowhp")
end
