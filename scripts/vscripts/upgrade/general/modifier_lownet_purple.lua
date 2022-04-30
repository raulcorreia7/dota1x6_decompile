LinkLuaModifier( "modifier_lownet_purple_buff", "upgrade/general/modifier_lownet_purple", LUA_MODIFIER_MOTION_NONE )



modifier_lownet_purple = class({})


function modifier_lownet_purple:IsHidden() return true end
function modifier_lownet_purple:IsPurgable() return false end


function modifier_lownet_purple:OnCreated(table)
if not IsServer() then return end
self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_lownet_purple_buff", {})
end


modifier_lownet_purple_buff = class({})
function modifier_lownet_purple_buff:IsHidden() return false end
function modifier_lownet_purple_buff:IsPurgable() return false end
function modifier_lownet_purple_buff:RemoveOnDeath() return false end
function modifier_lownet_purple_buff:GetTexture() return "buffs/purple" end
