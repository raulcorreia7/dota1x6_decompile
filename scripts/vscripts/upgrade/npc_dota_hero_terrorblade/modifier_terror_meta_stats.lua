

modifier_terror_meta_stats = class({})


function modifier_terror_meta_stats:IsHidden() return true end
function modifier_terror_meta_stats:IsPurgable() return false end



function modifier_terror_meta_stats:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_meta_stats:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_meta_stats:RemoveOnDeath() return false end