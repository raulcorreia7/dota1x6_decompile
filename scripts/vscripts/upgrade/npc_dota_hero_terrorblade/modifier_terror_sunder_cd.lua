

modifier_terror_sunder_cd = class({})


function modifier_terror_sunder_cd:IsHidden() return true end
function modifier_terror_sunder_cd:IsPurgable() return false end



function modifier_terror_sunder_cd:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_sunder_cd:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_sunder_cd:RemoveOnDeath() return false end