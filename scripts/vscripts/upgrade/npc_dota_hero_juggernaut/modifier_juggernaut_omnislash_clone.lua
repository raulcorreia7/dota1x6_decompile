
modifier_juggernaut_omnislash_clone = class({})


function modifier_juggernaut_omnislash_clone:IsHidden() return true end
function modifier_juggernaut_omnislash_clone:IsPurgable() return false end



function modifier_juggernaut_omnislash_clone:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end



function modifier_juggernaut_omnislash_clone:RemoveOnDeath() return false end