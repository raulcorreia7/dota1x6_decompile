

modifier_huskar_leap_shield = class({})


function modifier_huskar_leap_shield:IsHidden() return true end
function modifier_huskar_leap_shield:IsPurgable() return false end



function modifier_huskar_leap_shield:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_huskar_leap_shield:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_leap_shield:RemoveOnDeath() return false end