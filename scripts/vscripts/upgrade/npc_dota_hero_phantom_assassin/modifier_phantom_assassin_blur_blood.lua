modifier_phantom_assassin_blur_blood = class({})


function modifier_phantom_assassin_blur_blood:IsHidden() return true end
function modifier_phantom_assassin_blur_blood:IsPurgable() return false end



function modifier_phantom_assassin_blur_blood:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_blur_blood:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_blur_blood:RemoveOnDeath() return false end
