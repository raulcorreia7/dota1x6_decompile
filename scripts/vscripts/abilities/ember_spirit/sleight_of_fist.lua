LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_target", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_caster", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_armor", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_crit", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_legendary", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_evasion", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_speed", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)

ember_spirit_sleight_of_fist_custom = class({})

ember_spirit_sleight_of_fist_custom.cleave_init = 0
ember_spirit_sleight_of_fist_custom.cleave_inc = 0.2

ember_spirit_sleight_of_fist_custom.armor_reduction = 0.3

ember_spirit_sleight_of_fist_custom.speed_init = 5
ember_spirit_sleight_of_fist_custom.speed_inc = 5
ember_spirit_sleight_of_fist_custom.speed_duration = 5
ember_spirit_sleight_of_fist_custom.speed_max = 5


ember_spirit_sleight_of_fist_custom.crit_init = 100
ember_spirit_sleight_of_fist_custom.crit_inc = 40

ember_spirit_sleight_of_fist_custom.cd_init = 1
ember_spirit_sleight_of_fist_custom.cd_inc = 1

ember_spirit_sleight_of_fist_custom.legendary_duration = 10
ember_spirit_sleight_of_fist_custom.legendary_max = 2

ember_spirit_sleight_of_fist_custom.evasion_chance = 100
ember_spirit_sleight_of_fist_custom.evasion_duration = 2


function ember_spirit_sleight_of_fist_custom:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function ember_spirit_sleight_of_fist_custom:OnOwnerDied()
	if not self:IsActivated() then
		self:SetActivated(true)
	end
end

function ember_spirit_sleight_of_fist_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0 

if self:GetCaster():HasModifier("modifier_ember_fist_4") then 
  upgrade_cooldown = (self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_ember_fist_4"))*(self:GetCaster():GetAttackSpeed() / 7)
end

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
 end



function ember_spirit_sleight_of_fist_custom:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		local disarmed = self:GetCaster():IsDisarmed()


		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()
		local original_direction = (caster:GetAbsOrigin() - target_loc):Normalized()
		local effect_radius = self:GetSpecialValueFor("radius")
		local attack_interval = self:GetSpecialValueFor("attack_interval")
		local sleight_targets = {}

		caster:EmitSound("Hero_EmberSpirit.SleightOfFist.Cast")
		local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(cast_pfx, 0, target_loc)
		ParticleManager:SetParticleControl(cast_pfx, 1, Vector(effect_radius, 1, 1))
		ParticleManager:ReleaseParticleIndex(cast_pfx)

		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, effect_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		
		local c = 0
		if caster:HasModifier("modifier_ember_spirit_sleight_of_fist_custom_legendary") then 
			c = caster:FindModifierByName("modifier_ember_spirit_sleight_of_fist_custom_legendary"):GetStackCount()
		end

		c = c + 1

		for i = 1,c do

			for _,enemy in pairs(nearby_enemies) do
				if enemy:GetUnitName() ~= "npc_teleport" then 
					sleight_targets[#sleight_targets + 1] = enemy:GetEntityIndex()
					enemy:AddNewModifier(caster, self, "modifier_ember_spirit_sleight_of_fist_custom_target", {duration = (#sleight_targets - 1) * attack_interval})
				end
			end

		end



		if #sleight_targets >= 1 then


			if caster:HasModifier("modifier_ember_spirit_sleight_of_fist_custom_legendary") then 
				local mod_l = caster:FindModifierByName("modifier_ember_spirit_sleight_of_fist_custom_legendary")
				mod_l:SetDuration(-1, true)
			end



			local previous_position = caster:GetAbsOrigin()
			local current_count = 1
			local current_target = EntIndexToHScript(sleight_targets[current_count])
			caster:AddNewModifier(caster, self, "modifier_ember_spirit_sleight_of_fist_custom_caster", {})

			Timers:CreateTimer(0, function()
				if current_target and not current_target:IsNull() and current_target:IsAlive() and not (current_target:IsInvisible() and not caster:CanEntityBeSeenByMyTeam(current_target)) and not current_target:IsAttackImmune() then
					caster:EmitSound("Hero_EmberSpirit.SleightOfFist.Damage")
					local slash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, current_target)
					ParticleManager:SetParticleControl(slash_pfx, 0, current_target:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(slash_pfx)

					local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(trail_pfx, 0, current_target:GetAbsOrigin())
					ParticleManager:SetParticleControl(trail_pfx, 1, previous_position)
					ParticleManager:ReleaseParticleIndex(trail_pfx)

					if caster:HasModifier("modifier_ember_spirit_sleight_of_fist_custom_caster") then
						caster:SetAbsOrigin(current_target:GetAbsOrigin() + original_direction * 64)
						local mod = nil 
						
						if current_count == 1 and caster:HasModifier("modifier_ember_fist_3") then 
							mod = caster:AddNewModifier(caster, self, "modifier_ember_spirit_sleight_of_fist_custom_crit", {})
						end


						if not disarmed then 
							caster:PerformAttack(current_target, true, true, true, false, false, false, false)
						end

						if caster:HasModifier("modifier_ember_fist_2") then 
							caster:AddNewModifier(caster, self, "modifier_ember_spirit_sleight_of_fist_speed", {duration = self.speed_duration})
						end
				

						if mod ~= nil then 
							mod:Destroy()
						end

					end
				end

				current_count = current_count + 1

				if #sleight_targets >= current_count and caster:HasModifier("modifier_ember_spirit_sleight_of_fist_custom_caster") then
					previous_position = current_target:GetAbsOrigin()
					current_target = EntIndexToHScript(sleight_targets[current_count])
					
					if not (current_target:IsInvisible() and not caster:CanEntityBeSeenByMyTeam(current_target)) and not current_target:IsAttackImmune() and current_target:IsAlive() then
						return attack_interval
					else
						return 0
					end
				else
					Timers:CreateTimer(attack_interval + FrameTime(), function()
						if caster:HasModifier("modifier_ember_spirit_sleight_of_fist_custom_caster") then
							local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
                    		ParticleManager:SetParticleControl(trail_pfx, 0, caster_loc)
                    		ParticleManager:SetParticleControl(trail_pfx, 1, caster:GetAbsOrigin())
                   			 ParticleManager:ReleaseParticleIndex(trail_pfx) 
							FindClearSpaceForUnit(caster, caster_loc, true)
						end
						caster:RemoveModifierByName("modifier_ember_spirit_sleight_of_fist_custom_caster")
						for _, target in pairs(sleight_targets) do
							EntIndexToHScript(target):RemoveModifierByName("modifier_ember_spirit_sleight_of_fist_custom_target")
						end

						if caster:HasModifier("modifier_ember_fist_legendary") then 
							local mod_l = caster:AddNewModifier(caster, self, "modifier_ember_spirit_sleight_of_fist_custom_legendary", {duration = self.legendary_duration})
							mod_l:SetDuration(self.legendary_duration, true)
						end

						if caster:HasModifier("modifier_ember_fist_6") then 
							caster:AddNewModifier(caster, self, "modifier_ember_spirit_sleight_of_fist_evasion", {duration = self.evasion_duration})
						end

					end)
				end
			end)
		else
	
		end
	end
end


modifier_ember_spirit_sleight_of_fist_custom_target = class({})

function modifier_ember_spirit_sleight_of_fist_custom_target:IsDebuff() return true end
function modifier_ember_spirit_sleight_of_fist_custom_target:IsHidden() return true end
function modifier_ember_spirit_sleight_of_fist_custom_target:IsPurgable() return false end

function modifier_ember_spirit_sleight_of_fist_custom_target:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf"
end

function modifier_ember_spirit_sleight_of_fist_custom_target:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


modifier_ember_spirit_sleight_of_fist_custom_caster = class({})

function modifier_ember_spirit_sleight_of_fist_custom_caster:IsPurgable() return false end

function modifier_ember_spirit_sleight_of_fist_custom_caster:OnCreated()
if not IsServer() then return end

self.RemoveForDuel = true

		--self.sleight_caster_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		--ParticleManager:SetParticleControl(self.sleight_caster_particle, 0, self:GetCaster():GetAbsOrigin())
		--ParticleManager:SetParticleControlForward(self.sleight_caster_particle, 1, self:GetCaster():GetForwardVector())
		--ParticleManager:SetParticleControl(self.sleight_caster_particle, 62, Vector(10, 0, 0))

		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(self.particle, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_CUSTOMORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlForward(self.particle, 1, self:GetParent():GetForwardVector())
		self:AddParticle(self.particle, false, false, -1, false, false)
		
		self:GetParent():AddNoDraw()
		self:GetAbility():SetActivated(false)

end

function modifier_ember_spirit_sleight_of_fist_custom_caster:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveNoDraw()
		self:GetAbility():SetActivated(true)
	end
end

function modifier_ember_spirit_sleight_of_fist_custom_caster:CheckState()
if not IsServer() then return end

local state = {}

if self:GetParent():HasModifier("modifier_ember_fist_5") then 
 	state = {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_CANNOT_MISS] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_DISARMED] = true
		}
else 
 	state = {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_DISARMED] = true
		}

end
		return state
end

function modifier_ember_spirit_sleight_of_fist_custom_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end
function modifier_ember_spirit_sleight_of_fist_custom_caster:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_ember_fist_5") then 
	local mod = params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ember_spirit_sleight_of_fist_custom_armor", {duration = 0.1})
end

end


function modifier_ember_spirit_sleight_of_fist_custom_caster:GetModifierDamageOutgoing_Percentage(params)
if not IsServer() then return end
if params.target and params.target:IsHero() then return end 

return self:GetAbility():GetSpecialValueFor("creep_damage_penalty")
end


function modifier_ember_spirit_sleight_of_fist_custom_caster:GetModifierPreAttack_BonusDamage(keys)

	if keys.target and keys.target:IsHero() then
		return self:GetAbility():GetSpecialValueFor("bonus_hero_damage")
	end
end

function modifier_ember_spirit_sleight_of_fist_custom_caster:GetModifierIgnoreCastAngle()
	return 1
end

function modifier_ember_spirit_sleight_of_fist_custom_caster:OnAttackLanded( params )
if not self:GetParent():HasModifier("modifier_ember_fist_1") then return end
if self:GetParent() ~= params.attacker then return end 

local k = self:GetAbility().cleave_init + self:GetAbility().cleave_inc*self:GetParent():GetUpgradeStack("modifier_ember_fist_1")

DoCleaveAttack(self:GetParent(), params.target, nil, params.damage * k  , 150, 360, 650, "particles/ember_cleave.vpcf")

end



modifier_ember_spirit_sleight_of_fist_custom_armor = class({})
function modifier_ember_spirit_sleight_of_fist_custom_armor:IsHidden() return true end
function modifier_ember_spirit_sleight_of_fist_custom_armor:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_custom_armor:OnCreated(table)
self.armor = -1*self:GetParent():GetPhysicalArmorValue(false)*(self:GetAbility().armor_reduction)
end

function modifier_ember_spirit_sleight_of_fist_custom_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}

end
function modifier_ember_spirit_sleight_of_fist_custom_armor:GetModifierPhysicalArmorBonus()
return self.armor
end

function modifier_ember_spirit_sleight_of_fist_custom_armor:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
self:Destroy()

end



modifier_ember_spirit_sleight_of_fist_custom_crit = class({})
function modifier_ember_spirit_sleight_of_fist_custom_crit:IsHidden() return false end
function modifier_ember_spirit_sleight_of_fist_custom_crit:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_custom_crit:GetCritDamage() return
self:GetAbility().crit_init + self:GetAbility().crit_inc*self:GetParent():GetUpgradeStack("modifier_ember_fist_3")
end

function modifier_ember_spirit_sleight_of_fist_custom_crit:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
}
end

function modifier_ember_spirit_sleight_of_fist_custom_crit:GetModifierPreAttack_CriticalStrike( params )
return self:GetAbility().crit_init + self:GetAbility().crit_inc*self:GetParent():GetUpgradeStack("modifier_ember_fist_3")
end



modifier_ember_spirit_sleight_of_fist_custom_legendary = class({})

function modifier_ember_spirit_sleight_of_fist_custom_legendary:IsHidden() return false end
function modifier_ember_spirit_sleight_of_fist_custom_legendary:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_custom_legendary:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_ember_spirit_sleight_of_fist_custom_legendary:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() < self:GetAbility().legendary_max then 
	self:IncrementStackCount()
else 
	self:Destroy()
end

end


function modifier_ember_spirit_sleight_of_fist_custom_legendary:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

	local particle_cast = "particles/units/heroes/hero_drow/fist_count.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end

function modifier_ember_spirit_sleight_of_fist_custom_legendary:RemoveOnDeath() return false end

function modifier_ember_spirit_sleight_of_fist_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}

end

function modifier_ember_spirit_sleight_of_fist_custom_legendary:OnTooltip()
return self:GetStackCount() + 1
end



modifier_ember_spirit_sleight_of_fist_evasion = class({})
function modifier_ember_spirit_sleight_of_fist_evasion:IsHidden() return false end
function modifier_ember_spirit_sleight_of_fist_evasion:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_evasion:GetEffectName() return "particles/units/heroes/hero_clinkz/clinkz_strafe.vpcf" end
function modifier_ember_spirit_sleight_of_fist_evasion:GetStatusEffectName() return "particles/status_fx/status_effect_pangolier_shield.vpcf" end

function modifier_ember_spirit_sleight_of_fist_evasion:StatusEffectPriority()
    return 10010
end


function modifier_ember_spirit_sleight_of_fist_evasion:GetTexture() return "buffs/fist_evasion" end
function modifier_ember_spirit_sleight_of_fist_evasion:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_EVASION_CONSTANT
}
end

function modifier_ember_spirit_sleight_of_fist_evasion:GetModifierEvasion_Constant()
return self:GetAbility().evasion_chance
end

function modifier_ember_spirit_sleight_of_fist_evasion:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(FrameTime())
end

function modifier_ember_spirit_sleight_of_fist_evasion:OnIntervalThink()
if not IsServer() then return end

ProjectileManager:ProjectileDodge(self:GetParent())
end


modifier_ember_spirit_sleight_of_fist_speed = class({})
function modifier_ember_spirit_sleight_of_fist_speed:IsHidden() return false end
function modifier_ember_spirit_sleight_of_fist_speed:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_speed:GetTexture() return "buffs/Blade_dance_legendary" end

function modifier_ember_spirit_sleight_of_fist_speed:OnCreated(table)
if not IsServer() then return end
	self:SetStackCount(1)
end

function modifier_ember_spirit_sleight_of_fist_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().speed_max then return end
	self:IncrementStackCount()
end

function modifier_ember_spirit_sleight_of_fist_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_ember_spirit_sleight_of_fist_speed:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()*(self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetCaster():GetUpgradeStack("modifier_ember_fist_2"))
end