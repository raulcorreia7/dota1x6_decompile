

modifier_huskar_disarm_duration = class({})


function modifier_huskar_disarm_duration:IsHidden() return true end
function modifier_huskar_disarm_duration:IsPurgable() return false end



function modifier_huskar_disarm_duration:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_huskar_disarm_duration:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_disarm_duration:RemoveOnDeath() return false end