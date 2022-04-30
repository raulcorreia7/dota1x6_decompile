

modifier_huskar_leap_resist = class({})


function modifier_huskar_leap_resist:IsHidden() return true end
function modifier_huskar_leap_resist:IsPurgable() return false end



function modifier_huskar_leap_resist:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true
  self.ActiveTalent = true 
end


function modifier_huskar_leap_resist:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_leap_resist:RemoveOnDeath() return false end