

modifier_queen_Dagger_heal = class({})


function modifier_queen_Dagger_heal:IsHidden() return true end
function modifier_queen_Dagger_heal:IsPurgable() return false end



function modifier_queen_Dagger_heal:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_queen_Dagger_heal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Dagger_heal:RemoveOnDeath() return false end