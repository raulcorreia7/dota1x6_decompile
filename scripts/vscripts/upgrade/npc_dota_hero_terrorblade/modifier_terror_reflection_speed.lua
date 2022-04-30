

modifier_terror_reflection_speed = class({})


function modifier_terror_reflection_speed:IsHidden() return true end
function modifier_terror_reflection_speed:IsPurgable() return false end



function modifier_terror_reflection_speed:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_reflection_speed:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_reflection_speed:RemoveOnDeath() return false end