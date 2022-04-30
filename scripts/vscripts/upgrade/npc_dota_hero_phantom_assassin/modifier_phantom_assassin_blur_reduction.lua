

modifier_phantom_assassin_blur_reduction = class({})


function modifier_phantom_assassin_blur_reduction:IsHidden() return true end
function modifier_phantom_assassin_blur_reduction:IsPurgable() return false end



function modifier_phantom_assassin_blur_reduction:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_phantom_assassin_blur_reduction:RemoveOnDeath() return false end