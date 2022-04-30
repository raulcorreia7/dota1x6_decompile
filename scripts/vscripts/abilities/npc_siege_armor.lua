LinkLuaModifier("modifier_siege_attack", "abilities/npc_siege_armor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_siege_plusarmor", "abilities/npc_siege_armor.lua", LUA_MODIFIER_MOTION_NONE)

npc_siege_armor = class({})


function npc_siege_armor:GetIntrinsicModifierName() return "modifier_siege_attack" end
 
modifier_siege_attack = class ({})

function modifier_siege_attack:IsHidden() return true end
function modifier_siege_attack:IsPurgable() return false end


function modifier_siege_attack:DoScript(target)
if not IsServer() then return end
		local friends = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE , FIND_ANY_ORDER, false)
		if #friends > 0 then 

		target:EmitSound("Item_Desolator.Target")
  			for _,i in ipairs(friends) do
				i:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_siege_plusarmor", {duration = self:GetAbility():GetSpecialValueFor("duration")*(1 - i:GetStatusResistance())})
			end
		end
end


modifier_siege_plusarmor = class ({})

function modifier_siege_plusarmor:IsHidden() return false end
function modifier_siege_plusarmor:IsPurgable() return false end

function modifier_siege_plusarmor:OnCreated(table)
self.armor = self:GetAbility():GetSpecialValueFor("armor")
if not IsServer() then return end
 self:GetParent():EmitSound("Juggernaut.WardDeath")  
self:SetStackCount(1)
end

function modifier_siege_plusarmor:GetEffectName() return "particles/items2_fx/medallion_of_courage_friend.vpcf" end
function modifier_siege_plusarmor:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_siege_plusarmor:OnRefresh(table)
	if not IsServer() then return end
self:SetStackCount(self:GetStackCount() + 1)
end

function modifier_siege_plusarmor:DeclareFunctions()
	return
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_siege_plusarmor:GetModifierPhysicalArmorBonus() return self.armor*self:GetStackCount() end

function modifier_siege_plusarmor:OnTooltip() return self.armor*self:GetStackCount() end