
modifier_juggernaut_omnislash_stack = class({})


function modifier_juggernaut_omnislash_stack:IsHidden() return true end
function modifier_juggernaut_omnislash_stack:IsPurgable() return false end



function modifier_juggernaut_omnislash_stack:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_juggernaut_omnislash_stack:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_juggernaut_omnislash_stack:RemoveOnDeath() return false end