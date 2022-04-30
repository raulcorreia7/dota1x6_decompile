

modifier_skeleton_strike_legendary = class({})


function modifier_skeleton_strike_legendary:IsHidden() return true end
function modifier_skeleton_strike_legendary:IsPurgable() return false end



function modifier_skeleton_strike_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_skeleton_strike_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_skeleton_strike_legendary:RemoveOnDeath() return false end