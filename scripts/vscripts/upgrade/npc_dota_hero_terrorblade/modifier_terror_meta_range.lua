

modifier_terror_meta_range = class({})


function modifier_terror_meta_range:IsHidden() return true end
function modifier_terror_meta_range:IsPurgable() return false end



function modifier_terror_meta_range:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_meta_range:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_meta_range:RemoveOnDeath() return false end