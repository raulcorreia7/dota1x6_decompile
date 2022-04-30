

modifier_queen_Dagger_poison = class({})


function modifier_queen_Dagger_poison:IsHidden() return true end
function modifier_queen_Dagger_poison:IsPurgable() return false end



function modifier_queen_Dagger_poison:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_queen_Dagger_poison:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Dagger_poison:RemoveOnDeath() return false end