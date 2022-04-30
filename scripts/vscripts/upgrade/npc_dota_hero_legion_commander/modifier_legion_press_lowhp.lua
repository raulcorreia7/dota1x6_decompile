

modifier_legion_press_lowhp = class({})


function modifier_legion_press_lowhp:IsHidden() return true end
function modifier_legion_press_lowhp:IsPurgable() return false end



function modifier_legion_press_lowhp:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_legion_press_lowhp:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_press_lowhp:RemoveOnDeath() return false end