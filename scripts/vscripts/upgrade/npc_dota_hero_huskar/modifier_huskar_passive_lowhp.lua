

modifier_huskar_passive_lowhp = class({})


function modifier_huskar_passive_lowhp:IsHidden() return true end
function modifier_huskar_passive_lowhp:IsPurgable() return false end



function modifier_huskar_passive_lowhp:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_huskar_passive_lowhp:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_passive_lowhp:RemoveOnDeath() return false end