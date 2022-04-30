

modifier_huskar_passive_active = class({})


function modifier_huskar_passive_active:IsHidden() return true end
function modifier_huskar_passive_active:IsPurgable() return false end



function modifier_huskar_passive_active:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_huskar_passive_active:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_passive_active:RemoveOnDeath() return false end