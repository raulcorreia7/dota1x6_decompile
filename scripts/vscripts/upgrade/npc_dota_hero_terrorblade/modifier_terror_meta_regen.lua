

modifier_terror_meta_regen = class({})


function modifier_terror_meta_regen:IsHidden() return true end
function modifier_terror_meta_regen:IsPurgable() return false end



function modifier_terror_meta_regen:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_meta_regen:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_meta_regen:RemoveOnDeath() return false end