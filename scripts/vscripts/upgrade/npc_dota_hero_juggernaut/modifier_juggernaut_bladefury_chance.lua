

modifier_juggernaut_bladefury_chance = class({})


function modifier_juggernaut_bladefury_chance:IsHidden() return true end
function modifier_juggernaut_bladefury_chance:IsPurgable() return false end



function modifier_juggernaut_bladefury_chance:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_juggernaut_bladefury_chance:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_juggernaut_bladefury_chance:RemoveOnDeath() return false end