

modifier_juggernaut_bladedance_speed = class({})


function modifier_juggernaut_bladedance_speed:IsHidden() return true end
function modifier_juggernaut_bladedance_speed:IsPurgable() return false end



function modifier_juggernaut_bladedance_speed:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end

function modifier_juggernaut_bladedance_speed:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end


function modifier_juggernaut_bladedance_speed:RemoveOnDeath() return false end