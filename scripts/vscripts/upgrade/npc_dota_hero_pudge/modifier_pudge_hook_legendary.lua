

modifier_pudge_hook_legendary = class({})


function modifier_pudge_hook_legendary:IsHidden() return true end
function modifier_pudge_hook_legendary:IsPurgable() return false end



function modifier_pudge_hook_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_pudge_hook_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_pudge_hook_legendary:RemoveOnDeath() return false end