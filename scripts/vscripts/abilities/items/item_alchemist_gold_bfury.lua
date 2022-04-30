LinkLuaModifier("modifier_item_alchemist_gold_bfury", "abilities/items/item_alchemist_gold_bfury", LUA_MODIFIER_MOTION_NONE)

item_alchemist_gold_bfury = class({})

function item_alchemist_gold_bfury:GetCooldown(level)
	if IsClient() then
		return self.BaseClass.GetCooldown(self, level)
	elseif self:GetCursorTarget() and self:GetCursorTarget().CutDown then
		return 4
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function item_alchemist_gold_bfury:GetIntrinsicModifierName()
	return "modifier_item_alchemist_gold_bfury"
end

function item_alchemist_gold_bfury:OnSpellStart()
	local target = self:GetCursorTarget()
	local gold = self:GetSpecialValueFor("gold_steal")
	if target.CutDown then
		target:CutDown(self:GetCaster():GetTeamNumber())
	else
		target:EmitSound("DOTA_Item.IronTalon.Activate")
		local talon_particle = ParticleManager:CreateParticle("particles/items3_fx/iron_talon_active.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(talon_particle, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(talon_particle)

		target:SetHealth(math.max(1,target:GetHealth()*(1 - self:GetSpecialValueFor("damage_from_current_hp")/100)))

	end
end

modifier_item_alchemist_gold_bfury	= class({})

function modifier_item_alchemist_gold_bfury:AllowIllusionDuplicate()	return false end
function modifier_item_alchemist_gold_bfury:IsPurgable()		return false end
function modifier_item_alchemist_gold_bfury:RemoveOnDeath()	return false end
function modifier_item_alchemist_gold_bfury:IsHidden()	return true end

function modifier_item_alchemist_gold_bfury:OnCreated()
	self.damage_bonus			= self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.hp_regen			= self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.mp_regen	= self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.damage_bonus_creep_quelling = self:GetAbility():GetSpecialValueFor("quelling_bonus")
end

function modifier_item_alchemist_gold_bfury:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}

	return funcs
end

function modifier_item_alchemist_gold_bfury:GetModifierPreAttack_BonusDamage(keys)
	return self.damage_bonus
end

function modifier_item_alchemist_gold_bfury:GetModifierProcAttack_BonusDamage_Physical( keys )
	if not IsServer() then return end
	if keys.target and not keys.target:IsHero() and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		return self.damage_bonus_creep_quelling
	end
end

function modifier_item_alchemist_gold_bfury:GetModifierConstantManaRegen()
	return self.mp_regen
end

function modifier_item_alchemist_gold_bfury:GetModifierConstantHealthRegen()
	return self.hp_regen
end

function modifier_item_alchemist_gold_bfury:GetModifierProcAttack_Feedback(params)
	if params.attacker ~= self:GetParent() then return end
	local target = params.target
	if target:IsBuilding() then return end

	local target_loc = target:GetAbsOrigin()



	local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("cleave_distance"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	for _, unit in pairs(units) do
		if unit ~= target then

			local cleave_damage = self:GetAbility():GetSpecialValueFor("cleave_damage_hero")
			if params.target:IsCreep() then 
				cleave_damage = self:GetAbility():GetSpecialValueFor("cleave_damage_creep")
			end

			local damage = params.original_damage * cleave_damage * 0.01
			
			ApplyDamage({victim = unit, attacker = params.attacker, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
		end
	end
	local particle = ParticleManager:CreateParticle("particles/alchemist_special/gold_bfury.vpcf", PATTACH_WORLDORIGIN, nil)	
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
end



