

modifier_phantom_assassin_dagger_duration = class({})


function modifier_phantom_assassin_dagger_duration:IsHidden() return true end
function modifier_phantom_assassin_dagger_duration:IsPurgable() return false end



function modifier_phantom_assassin_dagger_duration:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_dagger_duration:RemoveOnDeath() return false end