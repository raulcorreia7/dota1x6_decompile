

modifier_puck_orb_cd = class({})


function modifier_puck_orb_cd:IsHidden() return true end
function modifier_puck_orb_cd:IsPurgable() return false end



function modifier_puck_orb_cd:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_orb_cd:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_orb_cd:RemoveOnDeath() return false end