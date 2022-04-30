LinkLuaModifier("modifier_siege_melting", "abilities/npc_siege_melting.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_siege_armor", "abilities/npc_siege_melting.lua", LUA_MODIFIER_MOTION_NONE)

npc_siege_melting = class({})


function npc_siege_melting:GetIntrinsicModifierName() return "modifier_siege_melting" end
 
modifier_siege_melting = class ({})

function modifier_siege_melting:IsHidden() return true end
function modifier_siege_melting:IsPurgable() return false end





function modifier_siege_melting:DoScript(target)
if not IsServer() then return end
target:EmitSound("Item_Desolator.Target")
target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_siege_armor", {duration = self:GetAbility():GetSpecialValueFor("duration")*(1 - target:GetStatusResistance())})

end

modifier_siege_armor = class ({})

function modifier_siege_armor:IsHidden() return false end
function modifier_siege_armor:IsPurgable() return false end

function modifier_siege_armor:OnCreated(table)
self.armor = -self:GetAbility():GetSpecialValueFor("armor")
if not IsServer() then return end
self:GetParent():EmitSound("Item.StarEmblem.Enemy")
self:SetStackCount(1)
end

function modifier_siege_armor:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("max") then return end
self:SetStackCount(self:GetStackCount() + 1)
end

function modifier_siege_armor:DeclareFunctions()
	return
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_siege_armor:GetModifierPhysicalArmorBonus() return self.armor*self:GetStackCount() end

function modifier_siege_armor:OnTooltip() return self.armor*self:GetStackCount() end

function modifier_siege_armor:GetEffectName() return "particles/items3_fx/star_emblem.vpcf" end
function modifier_siege_armor:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end