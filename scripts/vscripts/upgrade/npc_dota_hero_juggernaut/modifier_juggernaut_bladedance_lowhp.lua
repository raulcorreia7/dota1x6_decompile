
modifier_juggernaut_bladedance_lowhp = class({})


function modifier_juggernaut_bladedance_lowhp:IsHidden() return true end
function modifier_juggernaut_bladedance_lowhp:IsPurgable() return false end



function modifier_juggernaut_bladedance_lowhp:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1) 
end


function modifier_juggernaut_bladedance_lowhp:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_juggernaut_bladedance_lowhp:RemoveOnDeath() return false end