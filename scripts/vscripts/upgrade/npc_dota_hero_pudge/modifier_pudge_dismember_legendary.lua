

modifier_pudge_dismember_legendary = class({})


function modifier_pudge_dismember_legendary:IsHidden() return true end
function modifier_pudge_dismember_legendary:IsPurgable() return false end



function modifier_pudge_dismember_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_pudge_dismember_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_pudge_dismember_legendary:RemoveOnDeath() return false end