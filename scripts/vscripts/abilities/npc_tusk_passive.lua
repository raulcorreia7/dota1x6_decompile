LinkLuaModifier("modifier_tusk_passive", "abilities/npc_tusk_passive.lua", LUA_MODIFIER_MOTION_NONE)

npc_tusk_passive = class({})


function npc_tusk_passive:GetIntrinsicModifierName() return "modifier_tusk_passive" end
 
modifier_tusk_passive = class ({})

function modifier_tusk_passive:IsHidden() return true end

function modifier_tusk_passive:DeclareFunctions() return {

    MODIFIER_EVENT_ON_DEATH

} end

function modifier_tusk_passive:OnCreated(table)
    if not IsServer() then return end
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phased", {})
end

function modifier_tusk_passive:OnDeath( param )
    if not IsServer() then end 
      
    if param.unit == self:GetParent() then

         local new_ghost = CreateUnitByName("npc_tusk_ghost", self:GetParent():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_CUSTOM_5)
         new_ghost:AddNewModifier(self:GetParent(), self, "modifier_invulnerable", {})
    end
end


