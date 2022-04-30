

modifier_terror_sunder_heal = class({})


function modifier_terror_sunder_heal:IsHidden() return true end
function modifier_terror_sunder_heal:IsPurgable() return false end



function modifier_terror_sunder_heal:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_sunder_heal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_sunder_heal:RemoveOnDeath() return false end