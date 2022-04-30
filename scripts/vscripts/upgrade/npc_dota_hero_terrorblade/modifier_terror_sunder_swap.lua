

modifier_terror_sunder_swap = class({})


function modifier_terror_sunder_swap:IsHidden() return true end
function modifier_terror_sunder_swap:IsPurgable() return false end



function modifier_terror_sunder_swap:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_terror_sunder_swap:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_sunder_swap:RemoveOnDeath() return false end