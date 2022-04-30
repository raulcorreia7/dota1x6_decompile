

modifier_terror_reflection_duration = class({})


function modifier_terror_reflection_duration:IsHidden() return true end
function modifier_terror_reflection_duration:IsPurgable() return false end



function modifier_terror_reflection_duration:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_reflection_duration:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_reflection_duration:RemoveOnDeath() return false end