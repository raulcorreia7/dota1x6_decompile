

modifier_huskar_leap_cd = class({})


function modifier_huskar_leap_cd:IsHidden() return true end
function modifier_huskar_leap_cd:IsPurgable() return false end



function modifier_huskar_leap_cd:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_huskar_leap_cd:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_leap_cd:RemoveOnDeath() return false end