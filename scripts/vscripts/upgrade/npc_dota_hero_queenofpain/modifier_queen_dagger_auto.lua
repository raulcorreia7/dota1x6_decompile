

modifier_queen_Dagger_auto = class({})


function modifier_queen_Dagger_auto:IsHidden() return true end
function modifier_queen_Dagger_auto:IsPurgable() return false end



function modifier_queen_Dagger_auto:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   local ability = self:GetParent():FindAbilityByName("custom_queenofpain_shadow_strike")
   if ability and self:GetParent():IsRealHero()  then 
   		self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_custom_shadowstrike_auto", {})
   end
end


function modifier_queen_Dagger_auto:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
   local ability = self:GetParent():FindAbilityByName("custom_queenofpain_shadow_strike")
   if ability then 
   		self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_custom_shadowstrike_auto", {})
   end
  
end

function modifier_queen_Dagger_auto:RemoveOnDeath() return false end