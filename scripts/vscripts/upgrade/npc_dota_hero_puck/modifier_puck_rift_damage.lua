

modifier_puck_rift_damage = class({})


function modifier_puck_rift_damage:IsHidden() return true end
function modifier_puck_rift_damage:IsPurgable() return false end



function modifier_puck_rift_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_rift_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_rift_damage:RemoveOnDeath() return false end