

modifier_juggernaut_bladefury_agility = class({})


function modifier_juggernaut_bladefury_agility:IsHidden() return true end
function modifier_juggernaut_bladefury_agility:IsPurgable() return false end



function modifier_juggernaut_bladefury_agility:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_juggernaut_bladefury_agility:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_juggernaut_bladefury_agility:RemoveOnDeath() return false end