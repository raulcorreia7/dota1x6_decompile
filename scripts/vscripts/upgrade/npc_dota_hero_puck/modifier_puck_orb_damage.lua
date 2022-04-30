

modifier_puck_orb_damage = class({})


function modifier_puck_orb_damage:IsHidden() return true end
function modifier_puck_orb_damage:IsPurgable() return false end



function modifier_puck_orb_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_orb_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_orb_damage:RemoveOnDeath() return false end