

modifier_terror_sunder_damage = class({})


function modifier_terror_sunder_damage:IsHidden() return true end
function modifier_terror_sunder_damage:IsPurgable() return false end



function modifier_terror_sunder_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_sunder_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_sunder_damage:RemoveOnDeath() return false end