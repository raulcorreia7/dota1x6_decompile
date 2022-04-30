LinkLuaModifier("modifier_troll_warlord_whirling_axes_ranged_custom", "abilities/troll_warlord/troll_warlord_whirling_axes_ranged_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_attack", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_silence", "abilities/troll_warlord/troll_warlord_whirling_axes_ranged_custom", LUA_MODIFIER_MOTION_NONE)

troll_warlord_whirling_axes_ranged_custom = class({})

troll_warlord_whirling_axes_ranged_custom.scepter_manacost = 30


troll_warlord_whirling_axes_ranged_custom.damage_init = 20
troll_warlord_whirling_axes_ranged_custom.damage_inc = 20

troll_warlord_whirling_axes_ranged_custom.slow_init = -5
troll_warlord_whirling_axes_ranged_custom.slow_inc = -5

troll_warlord_whirling_axes_ranged_custom.healing = -35


function troll_warlord_whirling_axes_ranged_custom:OnUpgrade()
	if self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then
		if not self:GetCaster():HasModifier("modifier_troll_axes_legendary") then 
			self:SetActivated(false)
		end
	else
		self:SetActivated(true)
	end
end

function troll_warlord_whirling_axes_ranged_custom:OnAbilityPhaseStart()
	if self:GetCaster():HasModifier("modifier_troll_warlord_battle_trance_custom") then
		self:SetOverrideCastPoint(0)
	else
		self:SetOverrideCastPoint(0.2)
	end
	
	return true
end

function troll_warlord_whirling_axes_ranged_custom:GetCooldown(level)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_cooldown")
	end
    return self.BaseClass.GetCooldown( self, level )
end

function troll_warlord_whirling_axes_ranged_custom:GetManaCost(level)
	if self:GetCaster():HasScepter() then
		return troll_warlord_whirling_axes_ranged_custom.scepter_manacost
	end
    return self.BaseClass.GetManaCost(self, level)
end

function troll_warlord_whirling_axes_ranged_custom:OnSpellStart(new_target)
	if not IsServer() then return end
	local point = self:GetCursorPosition()

	if self:GetCursorTarget() ~= nil then 
		point = self:GetCursorTarget():GetAbsOrigin()
	end

	if new_target ~= nil then 
		point = new_target:GetAbsOrigin()
	end

		
	local meel_ability = self:GetCaster():FindAbilityByName("troll_warlord_whirling_axes_melee_custom")

	if self:GetCaster():HasModifier("modifier_troll_axes_3") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), meel_ability, "modifier_troll_warlord_whirling_axes_attack", {duration = meel_ability.attack_duration})
	end

	local caster_abs = self:GetCaster():GetAbsOrigin()
	local axe_width = self:GetSpecialValueFor("axe_width")
	local axe_speed = self:GetSpecialValueFor("axe_speed")
	local axe_range = self:GetSpecialValueFor("axe_range") + self:GetCaster():GetCastRangeBonus()
	local axe_damage = self:GetSpecialValueFor("axe_damage")
	local duration = self:GetSpecialValueFor("axe_slow_duration")
	local axe_spread = self:GetSpecialValueFor("axe_spread")
	local axe_count = self:GetSpecialValueFor("axe_count")





	local silence = 0


	local particle = "particles/troll_ranged.vpcf"



	if false and self:GetCaster():HasModifier("modifier_troll_axes_6") and not self:GetCaster():HasModifier("modifier_troll_warlord_whirling_axes_proc_cd") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), meel_ability, "modifier_troll_warlord_whirling_axes_proc_cd", {duration = meel_ability.proc_cd})
		particle = "particles/troll_ranged_legen.vpcf"
		silence = 1
	end


	Timers:CreateTimer(0.2, function()

	if self:GetCaster():HasModifier("modifier_troll_axes_4") then 

		local random = meel_ability.refresh_chance_init + meel_ability.refresh_chance_inc*self:GetCaster():GetUpgradeStack("modifier_troll_axes_4")

		if RollPseudoRandomPercentage(random, 534, self:GetCaster()) then

			self:GetCaster():EmitSound("Troll.Axed_cd")

			local particle = ParticleManager:CreateParticle("particles/sf_refresh_a.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
   			ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
   			ParticleManager:ReleaseParticleIndex(particle)
    


			local name = "troll_warlord_whirling_axes_melee_custom"
			local cd = self:GetCaster():FindAbilityByName(name):GetCooldownTimeRemaining()
			if cd > 0 then 
				self:GetCaster():FindAbilityByName(name):EndCooldown()
			end

			local name = "troll_warlord_whirling_axes_ranged_custom"
			local cd = self:GetCaster():FindAbilityByName(name):GetCooldownTimeRemaining()
			if cd > 0 then 

				self:GetCaster():FindAbilityByName(name):EndCooldown()
			end

		end

	end
	end)


	if self:GetCaster():HasModifier("modifier_troll_axes_1") then 
		axe_damage = axe_damage + self.damage_init + self.damage_inc*self:GetCaster():GetUpgradeStack("modifier_troll_axes_1")
	end

	local direction
	if point == caster_abs then
		direction = self:GetCaster():GetForwardVector()
	else
		direction = (point - caster_abs):Normalized()
	end

	self:GetCaster():EmitSound("Hero_TrollWarlord.WhirlingAxes.Ranged")
	local index = DoUniqueString("index")
	self[index] = {}

	local start_angle
	local interval_angle = 0

	start_angle = axe_spread / 2 * (-1)
	interval_angle = axe_spread / (axe_count - 1)

	for i=1, axe_count do
		local angle = start_angle + (i-1) * interval_angle
		local velocity = RotateVector2D(direction,angle,true) * axe_speed

		local projectile =
			{
				Ability				= self,
				EffectName			= particle,
				vSpawnOrigin		= caster_abs,
				fDistance			= axe_range,
				fStartRadius		= axe_width,
				fEndRadius			= axe_width,
				Source				= self:GetCaster(),
				bHasFrontalCone		= false,
				bReplaceExisting	= false,
				iUnitTargetTeam		= self:GetAbilityTargetTeam(),
				iUnitTargetFlags	= self:GetAbilityTargetFlags(),
				iUnitTargetType		= self:GetAbilityTargetType(),
				fExpireTime 		= GameRules:GetGameTime() + 10.0,
				bDeleteOnHit		= false,
				vVelocity			= Vector(velocity.x,velocity.y,0),
				bProvidesVision		= false,
				ExtraData			= {index = index, damage = axe_damage, duration = duration, axe_count = axe_count, on_hit_pct = on_hit_pct, silence = silence}
			}
		ProjectileManager:CreateLinearProjectile(projectile)
	end
end

function troll_warlord_whirling_axes_ranged_custom:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target then
		local was_hit = false
		for _, stored_target in ipairs(self[ExtraData.index]) do
			if target == stored_target then
				was_hit = true
				break
			end
		end
		if was_hit then return end
		table.insert(self[ExtraData.index],target)


		local melle = self:GetCaster():FindAbilityByName("troll_warlord_whirling_axes_melee_custom")

		local current_damage = ExtraData.damage
		if self:GetCaster():HasModifier("modifier_troll_warlord_whirling_axes_stack") then 
			current_damage = current_damage*(  (melle.legendary_damage)*self:GetCaster():GetUpgradeStack("modifier_troll_warlord_whirling_axes_stack") + 1)
		end


		if not target:HasModifier("modifier_troll_warlord_whirling_axes_proc_cd") and self:GetCaster():HasModifier("modifier_troll_axes_6") then
			target:AddNewModifier(self:GetCaster(), melle, "modifier_troll_warlord_whirling_axes_proc_cd", {duration = melle.proc_cd}) 
			target:AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_whirling_axes_silence", {duration = melle.proc_silence*(1 - target:GetStatusResistance())})
		end


		ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self, damage = current_damage, damage_type = self:GetAbilityDamageType()})


		target:AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_whirling_axes_ranged_custom", {duration = ExtraData.duration * (1 - target:GetStatusResistance())})
		target:EmitSound("Hero_TrollWarlord.WhirlingAxes.Target")
		if self:GetCaster():HasScepter() then
			target:Purge(true, false, false, false, false)
		end
	else
		self[ExtraData.index]["count"] = self[ExtraData.index]["count"] or 0
		self[ExtraData.index]["count"] = self[ExtraData.index]["count"] + 1
		if self[ExtraData.index]["count"] == ExtraData.axe_count then
			self[ExtraData.index] = nil
		end
	end
end

modifier_troll_warlord_whirling_axes_ranged_custom = class({})

function modifier_troll_warlord_whirling_axes_ranged_custom:IsPurgable() return true end
function modifier_troll_warlord_whirling_axes_ranged_custom:IsPurgeException() return false end

function modifier_troll_warlord_whirling_axes_ranged_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
	}
end

function modifier_troll_warlord_whirling_axes_ranged_custom:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	self.slow = self:GetAbility():GetSpecialValueFor("movement_speed") * (-1)
	self.healing = 0


	if self:GetCaster():HasModifier("modifier_troll_axes_2") then 
		self.slow = self.slow + self:GetAbility().slow_init + self:GetAbility().slow_inc*self:GetCaster():GetUpgradeStack("modifier_troll_axes_2")
	end

	if self:GetCaster():HasModifier("modifier_troll_axes_5") then 
		self.healing = self:GetAbility().healing
	end
end

function modifier_troll_warlord_whirling_axes_ranged_custom:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end


function modifier_troll_warlord_whirling_axes_ranged_custom:GetModifierLifestealRegenAmplify_Percentage() return self.healing end
function modifier_troll_warlord_whirling_axes_ranged_custom:GetModifierHealAmplify_PercentageTarget() return self.healing end
function modifier_troll_warlord_whirling_axes_ranged_custom:GetModifierHPRegenAmplify_Percentage() return self.healing end








function RotateVector2D(v,angle,bIsDegree)
    if bIsDegree then angle = math.rad(angle) end
    local xp = v.x * math.cos(angle) - v.y * math.sin(angle)
    local yp = v.x * math.sin(angle) + v.y * math.cos(angle)

    return Vector(xp,yp,v.z):Normalized()
end




modifier_troll_warlord_whirling_axes_silence = class({})

function modifier_troll_warlord_whirling_axes_silence:IsHidden() return false end

function modifier_troll_warlord_whirling_axes_silence:IsPurgable() return true end

function modifier_troll_warlord_whirling_axes_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_troll_warlord_whirling_axes_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_troll_warlord_whirling_axes_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
