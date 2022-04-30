
modifier_phantom_assassin_blur_chance = class({})


function modifier_phantom_assassin_blur_chance:IsHidden() return true end
function modifier_phantom_assassin_blur_chance:IsPurgable() return false end



function modifier_phantom_assassin_blur_chance:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_blur_chance:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_blur_chance:RemoveOnDeath() return false end