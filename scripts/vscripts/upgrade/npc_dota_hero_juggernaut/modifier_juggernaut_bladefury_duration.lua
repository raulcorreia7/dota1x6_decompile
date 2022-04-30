

modifier_juggernaut_bladefury_duration = class({})


function modifier_juggernaut_bladefury_duration:IsHidden() return true end
function modifier_juggernaut_bladefury_duration:IsPurgable() return false end



function modifier_juggernaut_bladefury_duration:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_juggernaut_bladefury_duration:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_juggernaut_bladefury_duration:RemoveOnDeath() return false end