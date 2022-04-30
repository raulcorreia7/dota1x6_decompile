

modifier_terror_meta_start = class({})


function modifier_terror_meta_start:IsHidden() return true end
function modifier_terror_meta_start:IsPurgable() return false end



function modifier_terror_meta_start:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_meta_start:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_meta_start:RemoveOnDeath() return false end