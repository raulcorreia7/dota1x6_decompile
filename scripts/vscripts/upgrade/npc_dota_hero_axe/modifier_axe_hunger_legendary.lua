

modifier_axe_hunger_legendary = class({})


function modifier_axe_hunger_legendary:IsHidden() return true end
function modifier_axe_hunger_legendary:IsPurgable() return false end



function modifier_axe_hunger_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_axe_hunger_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_axe_hunger_legendary:RemoveOnDeath() return false end