

modifier_huskar_disarm_legendary = class({})


function modifier_huskar_disarm_legendary:IsHidden() return true end
function modifier_huskar_disarm_legendary:IsPurgable() return false end



function modifier_huskar_disarm_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_huskar_disarm_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_disarm_legendary:RemoveOnDeath() return false end