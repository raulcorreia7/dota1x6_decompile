

modifier_lina_array_2 = class({})


function modifier_lina_array_2:IsHidden() return true end
function modifier_lina_array_2:IsPurgable() return false end



function modifier_lina_array_2:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_lina_array_2:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_lina_array_2:RemoveOnDeath() return false end