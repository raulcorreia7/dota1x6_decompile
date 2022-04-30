LinkLuaModifier("modifier_item_custom_observer_ward", "abilities/items/item_observer_stackable", LUA_MODIFIER_MOTION_NONE)

item_observer_stackable = class({})

function item_observer_stackable:OnAbilityPhaseStart()

    if  self:GetCurrentCharges() <= 0 then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerID()), "CreateIngameErrorMessage", {message = "#dota_hud_error_no_charges"})
        return false
    end
    return true
end

function item_observer_stackable:OnSpellStart()
    if not IsServer() then return end

    self:GetCaster():EmitSound("DOTA_Item.ObserverWard.Activate")

        local hWard = CreateUnitByName("npc_dota_observer_wards", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
        hWard:AddNewModifier(self:GetCaster(), self, "modifier_item_custom_observer_ward", {})
        hWard:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = Observer_duration})

    self:SetCurrentCharges(self:GetCurrentCharges()-1)
end


modifier_item_custom_observer_ward = class({})

function modifier_item_custom_observer_ward:IsHidden() return true end

function modifier_item_custom_observer_ward:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
    }

    return state
end