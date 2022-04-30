

modifier_skeleton_vampiric_legendary = class({})


function modifier_skeleton_vampiric_legendary:IsHidden() return true end
function modifier_skeleton_vampiric_legendary:IsPurgable() return false end



function modifier_skeleton_vampiric_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_skeleton_vampiric_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_skeleton_vampiric_legendary:RemoveOnDeath() return false end