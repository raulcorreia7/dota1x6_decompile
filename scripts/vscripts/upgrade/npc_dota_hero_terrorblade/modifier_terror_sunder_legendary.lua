

modifier_terror_sunder_legendary = class({})


function modifier_terror_sunder_legendary:IsHidden() return true end
function modifier_terror_sunder_legendary:IsPurgable() return false end



function modifier_terror_sunder_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_sunder_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_sunder_legendary:RemoveOnDeath() return false end