
modifier_phantom_assassin_blur_heal = class({})


function modifier_phantom_assassin_blur_heal:IsHidden() return true end
function modifier_phantom_assassin_blur_heal:IsPurgable() return false end



function modifier_phantom_assassin_blur_heal:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_phantom_assassin_blur_heal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_blur_heal:RemoveOnDeath() return false end