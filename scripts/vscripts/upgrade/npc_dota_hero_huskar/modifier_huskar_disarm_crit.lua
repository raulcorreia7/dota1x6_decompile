

modifier_huskar_disarm_crit = class({})


function modifier_huskar_disarm_crit:IsHidden() return true end
function modifier_huskar_disarm_crit:IsPurgable() return false end



function modifier_huskar_disarm_crit:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_huskar_disarm_crit:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_disarm_crit:RemoveOnDeath() return false end