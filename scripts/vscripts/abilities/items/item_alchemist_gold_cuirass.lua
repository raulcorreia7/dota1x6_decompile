LinkLuaModifier("modifier_item_alchemist_gold_cuirass", "abilities/items/item_alchemist_gold_cuirass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_cuirass_active_debuff", "abilities/items/item_alchemist_gold_cuirass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_cuirass_active_suck_debuff", "abilities/items/item_alchemist_gold_cuirass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_cuirass_active_suck_buff", "abilities/items/item_alchemist_gold_cuirass", LUA_MODIFIER_MOTION_NONE)

item_alchemist_gold_cuirass = class({})

function item_alchemist_gold_cuirass:GetIntrinsicModifierName()
	return "modifier_item_alchemist_gold_cuirass"
end


function item_alchemist_gold_cuirass:OnSpellStart()
    if not IsServer() then return end
    local duration = self:GetSpecialValueFor("duration")
	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
	
	if #units <= 0 then return end

	self:GetCaster():EmitSound("Hero_Visage.GraveChill.Cast")
	--units[1]:EmitSound("Hero_Visage.GraveChill.Target")

	local heroes = 0
	local creeps = 0


	for _, target in pairs(units) do
		
		if target:IsCreep() then 
			creeps = creeps + 1
		end

		if target:IsRealHero() then 
			heroes = heroes + 1
		end

		local suck_particle = ParticleManager:CreateParticle("particles/alchemist_special/gold_cuirass_suckbeams.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(suck_particle, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(suck_particle, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(suck_particle)
		target:AddNewModifier(self:GetCaster(), self, "modifier_item_alchemist_gold_cuirass_active_suck_debuff", {duration = duration})
	end    
	local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_alchemist_gold_cuirass_active_suck_buff", {duration = duration})
	if buff then 
		buff:SetStackCount(creeps + heroes*self:GetSpecialValueFor("creeps"))
	end
end







modifier_item_alchemist_gold_cuirass	= class({})

function modifier_item_alchemist_gold_cuirass:IsPurgable()		return false end
function modifier_item_alchemist_gold_cuirass:RemoveOnDeath()	return false end
function modifier_item_alchemist_gold_cuirass:IsHidden()	return true end

function modifier_item_alchemist_gold_cuirass:OnCreated()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_all_attributes = self:GetAbility():GetSpecialValueFor("bonus_all_attributes")
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")

end



function modifier_item_alchemist_gold_cuirass:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_item_alchemist_gold_cuirass:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_alchemist_gold_cuirass:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_alchemist_gold_cuirass:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_alchemist_gold_cuirass:GetModifierBonusStats_Strength()
	return self.bonus_all_attributes
end

function modifier_item_alchemist_gold_cuirass:GetModifierBonusStats_Agility()
	return self.bonus_all_attributes
end

function modifier_item_alchemist_gold_cuirass:GetModifierBonusStats_Intellect()
	return self.bonus_all_attributes
end

function modifier_item_alchemist_gold_cuirass:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_movement_speed
end

function modifier_item_alchemist_gold_cuirass:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end


function modifier_item_alchemist_gold_cuirass:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("radius")
	end
end

function modifier_item_alchemist_gold_cuirass:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_item_alchemist_gold_cuirass:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_alchemist_gold_cuirass:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_item_alchemist_gold_cuirass:GetModifierAura()
	return "modifier_item_alchemist_gold_cuirass_active_debuff"
end

function modifier_item_alchemist_gold_cuirass:IsAura()
	return true
end






modifier_item_alchemist_gold_cuirass_active_debuff = class({})

function modifier_item_alchemist_gold_cuirass_active_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	self.armor = self:GetAbility():GetSpecialValueFor("aura_negative_armor")
end

function modifier_item_alchemist_gold_cuirass_active_debuff:IsHidden() return false end
function modifier_item_alchemist_gold_cuirass_active_debuff:IsPurgable() return false end
function modifier_item_alchemist_gold_cuirass_active_debuff:IsDebuff() return true end

function modifier_item_alchemist_gold_cuirass_active_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_item_alchemist_gold_cuirass_active_debuff:GetModifierPhysicalArmorBonus()
	return self.armor
end






modifier_item_alchemist_gold_cuirass_active_suck_debuff = class({})

function modifier_item_alchemist_gold_cuirass_active_suck_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	self.armor = -1*self:GetAbility():GetSpecialValueFor("active_armor")
	self.speed = -1*self:GetAbility():GetSpecialValueFor("active_speed")
	self.move = -1*self:GetAbility():GetSpecialValueFor("active_move")
	self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

function modifier_item_alchemist_gold_cuirass_active_suck_debuff:IsHidden() return false end
function modifier_item_alchemist_gold_cuirass_active_suck_debuff:IsPurgable() return false end
function modifier_item_alchemist_gold_cuirass_active_suck_debuff:IsDebuff() return true end

function modifier_item_alchemist_gold_cuirass_active_suck_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_alchemist_gold_cuirass_active_suck_debuff:GetModifierPhysicalArmorBonus()
	return self.armor
end


function modifier_item_alchemist_gold_cuirass_active_suck_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.speed
end
function modifier_item_alchemist_gold_cuirass_active_suck_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.move
end




modifier_item_alchemist_gold_cuirass_active_suck_buff = class({})

function modifier_item_alchemist_gold_cuirass_active_suck_buff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	self.armor = self:GetAbility():GetSpecialValueFor("active_armor")
	self.speed = self:GetAbility():GetSpecialValueFor("active_speed")
	self.move = self:GetAbility():GetSpecialValueFor("active_move")
	self.creeps = self:GetAbility():GetSpecialValueFor("creeps")
end

function modifier_item_alchemist_gold_cuirass_active_suck_buff:IsHidden() return false end
function modifier_item_alchemist_gold_cuirass_active_suck_buff:IsPurgable() return false end

function modifier_item_alchemist_gold_cuirass_active_suck_buff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_alchemist_gold_cuirass_active_suck_buff:GetModifierPhysicalArmorBonus()
	return self.armor*self:GetStackCount() / self.creeps
end


function modifier_item_alchemist_gold_cuirass_active_suck_buff:GetModifierAttackSpeedBonus_Constant()
	return self.speed*self:GetStackCount() / self.creeps
end
function modifier_item_alchemist_gold_cuirass_active_suck_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.move*self:GetStackCount() / self.creeps
end


function modifier_item_alchemist_gold_cuirass_active_suck_buff:GetEffectName()
	return "particles/alchemist_special/cuirass_buff_overhead.vpcf"
end

function modifier_item_alchemist_gold_cuirass_active_suck_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
