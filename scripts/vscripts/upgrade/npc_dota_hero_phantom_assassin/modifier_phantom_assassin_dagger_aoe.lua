

modifier_phantom_assassin_dagger_aoe = class({})


function modifier_phantom_assassin_dagger_aoe:IsHidden() return true end
function modifier_phantom_assassin_dagger_aoe:IsPurgable() return false end



function modifier_phantom_assassin_dagger_aoe:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_phantom_assassin_dagger_aoe:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_dagger_aoe:RemoveOnDeath() return false end