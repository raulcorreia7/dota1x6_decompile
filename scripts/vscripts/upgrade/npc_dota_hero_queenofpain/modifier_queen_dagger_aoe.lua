

modifier_queen_Dagger_aoe = class({})


function modifier_queen_Dagger_aoe:IsHidden() return true end
function modifier_queen_Dagger_aoe:IsPurgable() return false end



function modifier_queen_Dagger_aoe:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_queen_Dagger_aoe:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Dagger_aoe:RemoveOnDeath() return false end