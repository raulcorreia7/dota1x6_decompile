

modifier_phantom_assassin_dagger_legendary = class({})


function modifier_phantom_assassin_dagger_legendary:IsHidden() return true end
function modifier_phantom_assassin_dagger_legendary:IsPurgable() return false end



function modifier_phantom_assassin_dagger_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_dagger_legendary:RemoveOnDeath() return false end