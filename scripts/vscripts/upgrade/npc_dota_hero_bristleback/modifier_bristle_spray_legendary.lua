

modifier_bristle_spray_legendary = class({})


function modifier_bristle_spray_legendary:IsHidden() return true end
function modifier_bristle_spray_legendary:IsPurgable() return false end



function modifier_bristle_spray_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.ActiveTalent = true
end




function modifier_bristle_spray_legendary:RemoveOnDeath() return false end