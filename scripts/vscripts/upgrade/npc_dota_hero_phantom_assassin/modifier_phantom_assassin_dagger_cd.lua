

modifier_phantom_assassin_dagger_cd = class({})


function modifier_phantom_assassin_dagger_cd:IsHidden() return true end
function modifier_phantom_assassin_dagger_cd:IsPurgable() return false end



function modifier_phantom_assassin_dagger_cd:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_phantom_assassin_dagger_cd:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_dagger_cd:RemoveOnDeath() return false end