

modifier_phantom_assassin_dagger_heal = class({})


function modifier_phantom_assassin_dagger_heal:IsHidden() return true end
function modifier_phantom_assassin_dagger_heal:IsPurgable() return false end



function modifier_phantom_assassin_dagger_heal:OnCreated(table)
if not IsServer() then return end
   self.StackOnIllusion = true 
  self:SetStackCount(1) 
end


function modifier_phantom_assassin_dagger_heal:RemoveOnDeath() return false end