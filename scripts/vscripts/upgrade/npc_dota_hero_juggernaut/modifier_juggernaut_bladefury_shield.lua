

modifier_juggernaut_bladefury_shield = class({})


function modifier_juggernaut_bladefury_shield:IsHidden() return true end
function modifier_juggernaut_bladefury_shield:IsPurgable() return false end




function modifier_juggernaut_bladefury_shield:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end




function modifier_juggernaut_bladefury_shield:RemoveOnDeath() return false end