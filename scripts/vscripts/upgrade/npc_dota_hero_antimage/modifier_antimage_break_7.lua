

modifier_antimage_break_7 = class({})


function modifier_antimage_break_7:IsHidden() return true end
function modifier_antimage_break_7:IsPurgable() return false end



function modifier_antimage_break_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_antimage_break_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_antimage_break_7:RemoveOnDeath() return false end