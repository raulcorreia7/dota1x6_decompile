LinkLuaModifier("modifier_centaur_aura", "abilities/neutral_centaur_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_centaur_aura_buff", "abilities/neutral_centaur_aura", LUA_MODIFIER_MOTION_NONE)



neutral_centaur_aura = class({})

function neutral_centaur_aura:GetIntrinsicModifierName() return "modifier_centaur_aura" end


modifier_centaur_aura = class({})

function modifier_centaur_aura:IsPurgable() return false end

function modifier_centaur_aura:IsHidden() return true end

function modifier_centaur_aura:IsAura() return true end

function modifier_centaur_aura:GetAuraDuration() return 0.1 end

function modifier_centaur_aura:GetAuraRadius() return 500 end

function modifier_centaur_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_centaur_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_centaur_aura:GetModifierAura() return "modifier_centaur_aura_buff" end

modifier_centaur_aura_buff = class({})
function modifier_centaur_aura_buff:IsPurgable() return false end
function modifier_centaur_aura_buff:IsHidden() return false end



function modifier_centaur_aura_buff:OnCreated(table)
    if not IsServer() then
        return
    end
    self:SetHasCustomTransmitterData(true)

	local ability = self:GetAbility()
	if not IsValidEntity(ability) then return end

    self.armor = ability:GetSpecialValueFor("armor")
    self.magic = ability:GetSpecialValueFor("magic")
end


function modifier_centaur_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
end

function modifier_centaur_aura_buff:OnTooltip() return self:GetAbility():GetSpecialValueFor("armor") end
function modifier_centaur_aura_buff:OnTooltip2() return self:GetAbility():GetSpecialValueFor("magic") end



function modifier_centaur_aura_buff:AddCustomTransmitterData() return {
magic = self.magic,
armor = self.armor

} end

function modifier_centaur_aura_buff:HandleCustomTransmitterData(data)
self.magic = data.magic
self.armor = data.armor
end

function modifier_centaur_aura_buff:GetAttributes()
 return  MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_centaur_aura_buff:GetModifierMagicalResistanceBonus() return self.magic end

function modifier_centaur_aura_buff:GetModifierPhysicalArmorBonus() return self.armor end
