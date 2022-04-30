
modifier_juggernaut_bladefury_damage = class({})


function modifier_juggernaut_bladefury_damage:IsHidden() return true end
function modifier_juggernaut_bladefury_damage:IsPurgable() return false end



function modifier_juggernaut_bladefury_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_juggernaut_bladefury_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_juggernaut_bladefury_damage:RemoveOnDeath() return false end