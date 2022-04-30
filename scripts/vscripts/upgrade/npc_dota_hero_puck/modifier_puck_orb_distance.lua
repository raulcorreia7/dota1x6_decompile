

modifier_puck_orb_distance = class({})


function modifier_puck_orb_distance:IsHidden() return true end
function modifier_puck_orb_distance:IsPurgable() return false end



function modifier_puck_orb_distance:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_orb_distance:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_orb_distance:RemoveOnDeath() return false end