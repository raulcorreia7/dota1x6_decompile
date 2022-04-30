

modifier_huskar_leap_damage = class({})


function modifier_huskar_leap_damage:IsHidden() return true end
function modifier_huskar_leap_damage:IsPurgable() return false end



function modifier_huskar_leap_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_huskar_leap_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_leap_damage:RemoveOnDeath() return false end