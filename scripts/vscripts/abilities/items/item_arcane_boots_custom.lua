item_arcane_boots_custom = class({})

LinkLuaModifier( "modifier_item_arcane_boots_custom", "abilities/items/item_arcane_boots_custom", LUA_MODIFIER_MOTION_NONE )

function item_arcane_boots_custom:GetIntrinsicModifierName()
	return "modifier_item_arcane_boots_custom"
end

function item_arcane_boots_custom:OnSpellStart()
	if not IsServer() then return end
	local replenish_amount = self:GetSpecialValueFor("replenish_amount")
	self:GetCaster():EmitSound("DOTA_Item.ArcaneBoots.Activate")
	local particle_1 = ParticleManager:CreateParticle("particles/items_fx/arcane_boots.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(particle_1)
	local particle_2 = ParticleManager:CreateParticle("particles/items_fx/arcane_boots_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(particle_2)
	self:GetCaster():GiveMana(replenish_amount)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD , self:GetCaster(), replenish_amount, nil)
end

modifier_item_arcane_boots_custom = class({})

function modifier_item_arcane_boots_custom:IsHidden()		return true end
function modifier_item_arcane_boots_custom:IsPurgable()		return false end
function modifier_item_arcane_boots_custom:RemoveOnDeath()	return false end
function modifier_item_arcane_boots_custom:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_arcane_boots_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MANA_BONUS,
	}
end

function modifier_item_arcane_boots_custom:GetModifierMoveSpeedBonus_Special_Boots()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_movement")
	end
end

function modifier_item_arcane_boots_custom:GetModifierManaBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_mana")
	end
end