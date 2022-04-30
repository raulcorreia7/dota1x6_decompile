

modifier_skeleton_reincarnation_legendary = class({})


function modifier_skeleton_reincarnation_legendary:IsHidden() return true end
function modifier_skeleton_reincarnation_legendary:IsPurgable() return false end



function modifier_skeleton_reincarnation_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_skeleton_reincarnation_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_skeleton_reincarnation_legendary:RemoveOnDeath() return false end