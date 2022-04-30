

modifier_phantom_assassin_dagger_double = class({})


function modifier_phantom_assassin_dagger_double:IsHidden() return true end
function modifier_phantom_assassin_dagger_double:IsPurgable() return false end



function modifier_phantom_assassin_dagger_double:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1) 
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_dagger_double:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_dagger_double:RemoveOnDeath() return false end