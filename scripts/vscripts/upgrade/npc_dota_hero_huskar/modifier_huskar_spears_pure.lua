

modifier_huskar_spears_pure = class({})


function modifier_huskar_spears_pure:IsHidden() return true end
function modifier_huskar_spears_pure:IsPurgable() return false end



function modifier_huskar_spears_pure:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_huskar_spears_pure:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_spears_pure:RemoveOnDeath() return false end