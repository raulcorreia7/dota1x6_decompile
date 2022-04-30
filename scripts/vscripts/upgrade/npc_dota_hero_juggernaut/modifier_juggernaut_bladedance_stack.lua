
modifier_juggernaut_bladedance_stack = class({})


function modifier_juggernaut_bladedance_stack:IsHidden() return true end
function modifier_juggernaut_bladedance_stack:IsPurgable() return false end



function modifier_juggernaut_bladedance_stack:OnCreated(table)
if not IsServer() then return end

   self.StackOnIllusion = true 
  self:SetStackCount(1) 
end


function modifier_juggernaut_bladedance_stack:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_juggernaut_bladedance_stack:RemoveOnDeath() return false end