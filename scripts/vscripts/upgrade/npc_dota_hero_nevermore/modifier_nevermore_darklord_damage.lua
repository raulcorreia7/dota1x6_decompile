

modifier_nevermore_darklord_damage = class({})


function modifier_nevermore_darklord_damage:IsHidden() return true end
function modifier_nevermore_darklord_damage:IsPurgable() return false end



function modifier_nevermore_darklord_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true
     local ability =  self:GetParent():FindAbilityByName("custom_nevermore_dark_lord")
   if ability then 
	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_custom_dark_lord_damage_aura", {})
   end
end


function modifier_nevermore_darklord_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_darklord_damage:RemoveOnDeath() return false end