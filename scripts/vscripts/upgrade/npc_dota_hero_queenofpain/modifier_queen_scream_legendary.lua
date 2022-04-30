

modifier_queen_Scream_legendary = class({})


function modifier_queen_Scream_legendary:IsHidden() return true end
function modifier_queen_Scream_legendary:IsPurgable() return false end



function modifier_queen_Scream_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_queen_Scream_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Scream_legendary:RemoveOnDeath() return false end