

modifier_troll_fervor_6 = class({})


function modifier_troll_fervor_6:IsHidden() return true end
function modifier_troll_fervor_6:IsPurgable() return false end



function modifier_troll_fervor_6:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_troll_fervor_6:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_troll_fervor_6:RemoveOnDeath() return false end