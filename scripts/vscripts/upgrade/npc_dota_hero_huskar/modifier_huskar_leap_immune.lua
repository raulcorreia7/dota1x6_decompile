

modifier_huskar_leap_immune = class({})


function modifier_huskar_leap_immune:IsHidden() return true end
function modifier_huskar_leap_immune:IsPurgable() return false end



function modifier_huskar_leap_immune:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

end


function modifier_huskar_leap_immune:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_leap_immune:RemoveOnDeath() return false end