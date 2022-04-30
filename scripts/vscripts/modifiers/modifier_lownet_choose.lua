LinkLuaModifier( "modifier_lownet_choose", "modifiers/modifier_lownet_choose", LUA_MODIFIER_MOTION_NONE )

modifier_lownet_choose = class({})


function modifier_lownet_choose:IsHidden() return true end
function modifier_lownet_choose:IsPurgable() return false end
function modifier_lownet_choose:RemoveOnDeath() return false end
function modifier_lownet_choose:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0)
end

function modifier_lownet_choose:OnIntervalThink()
if not IsServer() then return end
if self:GetParent().IsChoosing == true then return end 

upgrade:init_upgrade(self:GetParent(),10,nil,after_legen)
self:Destroy()
end

