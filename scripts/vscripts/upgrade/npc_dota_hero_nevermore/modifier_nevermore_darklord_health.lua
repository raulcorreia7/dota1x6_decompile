

modifier_nevermore_darklord_health = class({})


function modifier_nevermore_darklord_health:IsHidden() return true end
function modifier_nevermore_darklord_health:IsPurgable() return false end



function modifier_nevermore_darklord_health:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_nevermore_darklord_health:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_darklord_health:RemoveOnDeath() return false end