

modifier_terror_sunder_amplify = class({})


function modifier_terror_sunder_amplify:IsHidden() return true end
function modifier_terror_sunder_amplify:IsPurgable() return false end



function modifier_terror_sunder_amplify:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_sunder_amplify:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_sunder_amplify:RemoveOnDeath() return false end