

modifier_phantom_assassin_blur_stun = class({})


function modifier_phantom_assassin_blur_stun:IsHidden() return true end
function modifier_phantom_assassin_blur_stun:IsPurgable() return false end



function modifier_phantom_assassin_blur_stun:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_phantom_assassin_blur_stun:RemoveOnDeath() return false end