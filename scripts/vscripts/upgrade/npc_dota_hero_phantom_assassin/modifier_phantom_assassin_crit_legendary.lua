

modifier_phantom_assassin_crit_legendary = class({})


function modifier_phantom_assassin_crit_legendary:IsHidden() return true end
function modifier_phantom_assassin_crit_legendary:IsPurgable() return false end



function modifier_phantom_assassin_crit_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.ActiveTalent = true

  local ability = self:GetCaster():FindAbilityByName("custom_phantom_assassin_coup_de_grace")
  if ability then 
 	 self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_phantom_assassin_phantom_coup_de_grace_kills", {})
 end
end




function modifier_phantom_assassin_crit_legendary:RemoveOnDeath() return false end