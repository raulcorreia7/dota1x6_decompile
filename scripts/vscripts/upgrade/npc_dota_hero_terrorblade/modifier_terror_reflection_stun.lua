

modifier_terror_reflection_stun = class({})


function modifier_terror_reflection_stun:IsHidden() return true end
function modifier_terror_reflection_stun:IsPurgable() return false end



function modifier_terror_reflection_stun:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_reflection_stun:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_reflection_stun:RemoveOnDeath() return false end