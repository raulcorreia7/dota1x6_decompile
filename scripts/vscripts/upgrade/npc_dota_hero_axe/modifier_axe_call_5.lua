

modifier_axe_call_5 = class({})


function modifier_axe_call_5:IsHidden() return true end
function modifier_axe_call_5:IsPurgable() return false end



function modifier_axe_call_5:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_axe_call_5:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_axe_call_5:RemoveOnDeath() return false end