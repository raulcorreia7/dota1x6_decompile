

modifier_terror_reflection_slow = class({})


function modifier_terror_reflection_slow:IsHidden() return true end
function modifier_terror_reflection_slow:IsPurgable() return false end



function modifier_terror_reflection_slow:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_reflection_slow:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_reflection_slow:RemoveOnDeath() return false end