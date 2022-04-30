

modifier_puck_rift_mana = class({})


function modifier_puck_rift_mana:IsHidden() return true end
function modifier_puck_rift_mana:IsPurgable() return false end



function modifier_puck_rift_mana:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_rift_mana:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_rift_mana:RemoveOnDeath() return false end