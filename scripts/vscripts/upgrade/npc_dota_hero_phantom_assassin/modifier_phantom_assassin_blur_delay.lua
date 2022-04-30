

modifier_phantom_assassin_blur_delay = class({})


function modifier_phantom_assassin_blur_delay:IsHidden() return true end
function modifier_phantom_assassin_blur_delay:IsPurgable() return false end



function modifier_phantom_assassin_blur_delay:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_phantom_assassin_blur_delay:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_blur_delay:RemoveOnDeath() return false end