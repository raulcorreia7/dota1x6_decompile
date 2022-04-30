

modifier_terror_meta_legendary = class({})


function modifier_terror_meta_legendary:IsHidden() return true end
function modifier_terror_meta_legendary:IsPurgable() return false end



function modifier_terror_meta_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.ActiveTalent = true
  local ability = self:GetParent():FindAbilityByName("custom_terrorblade_metamorphosis")
  if ability and ability:GetCooldownTimeRemaining() > 0 then 
  	ability:EndCooldown()
  end
end




function modifier_terror_meta_legendary:RemoveOnDeath() return false end