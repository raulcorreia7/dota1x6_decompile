

modifier_legion_duel_blood = class({})


function modifier_legion_duel_blood:IsHidden() return true end
function modifier_legion_duel_blood:IsPurgable() return false end



function modifier_legion_duel_blood:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_legion_duel_blood:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_duel_blood:RemoveOnDeath() return false end