

modifier_huskar_disarm_lowhp = class({})


function modifier_huskar_disarm_lowhp:IsHidden() return true end
function modifier_huskar_disarm_lowhp:IsPurgable() return false end



function modifier_huskar_disarm_lowhp:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_huskar_disarm_lowhp:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_disarm_lowhp:RemoveOnDeath() return false end