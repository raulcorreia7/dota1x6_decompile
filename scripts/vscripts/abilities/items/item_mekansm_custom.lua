LinkLuaModifier( "modifier_item_mekansm_custom", "abilities/items/item_mekansm_custom", LUA_MODIFIER_MOTION_NONE )	

item_mekansm_custom = class({})


function item_mekansm_custom:GetIntrinsicModifierName()
	return "modifier_item_mekansm_custom"
end

function item_mekansm_custom:OnSpellStart()
	if not IsServer() then return end
	local heal_amount = self:GetSpecialValueFor("heal_amount")*self:GetCaster():GetMaxHealth()/100
	local heal_cooldown = self:GetSpecialValueFor("heal_cooldown")
	self:GetCaster():EmitSound("DOTA_Item.Mekansm.Activate")
	local particle_1 = ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(particle_1)

		self:GetCaster():Heal(heal_amount, self)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetCaster(), heal_amount, nil)
		self:GetCaster():EmitSound("DOTA_Item.Mekansm.Target")
		local particle_2 = ParticleManager:CreateParticle("particles/items2_fx/mekanism_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(particle_2, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_2, 1, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_2)
	
end

modifier_item_mekansm_custom = class({})

function modifier_item_mekansm_custom:IsHidden()		return true end
function modifier_item_mekansm_custom:IsPurgable()	return false end
function modifier_item_mekansm_custom:RemoveOnDeath()	return false end
function modifier_item_mekansm_custom:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_mekansm_custom:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_item_mekansm_custom:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_mekansm_custom:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("health_regen")
end

