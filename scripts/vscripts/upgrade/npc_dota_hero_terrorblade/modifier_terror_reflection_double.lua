

modifier_terror_reflection_double = class({})


function modifier_terror_reflection_double:IsHidden() return true end
function modifier_terror_reflection_double:IsPurgable() return false end



function modifier_terror_reflection_double:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_terror_reflection_double:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_reflection_double:RemoveOnDeath() return false end