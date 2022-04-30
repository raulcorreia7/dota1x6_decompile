

modifier_legion_duel_passive = class({})


function modifier_legion_duel_passive:IsHidden() return true end
function modifier_legion_duel_passive:IsPurgable() return false end



function modifier_legion_duel_passive:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   local ability = self:GetParent():FindAbilityByName("custom_legion_commander_duel")
   if ability then 
   	  local duration_cd = RandomInt(ability.passive_cd_min, ability.passive_cd_max)

   	self:GetParent():AddNewModifier(self:GetParent(), ability,"modifier_duel_mini_cd", {duration = duration_cd})
   end

end


function modifier_legion_duel_passive:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_duel_passive:RemoveOnDeath() return false end