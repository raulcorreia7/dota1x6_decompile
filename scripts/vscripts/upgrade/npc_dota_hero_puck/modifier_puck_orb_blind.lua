

modifier_puck_orb_blind = class({})


function modifier_puck_orb_blind:IsHidden() return true end
function modifier_puck_orb_blind:IsPurgable() return false end



function modifier_puck_orb_blind:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_orb_blind:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_orb_blind:RemoveOnDeath() return false end