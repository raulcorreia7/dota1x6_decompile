

modifier_nevermore_darklord_silence = class({})


function modifier_nevermore_darklord_silence:IsHidden() return true end
function modifier_nevermore_darklord_silence:IsPurgable() return false end



function modifier_nevermore_darklord_silence:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1) 
   self.StackOnIllusion = true 
     local ability =  self:GetParent():FindAbilityByName("custom_nevermore_dark_lord")
   if ability  then 
	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_custom_dark_lord_silence_aura", {})
   end
end


function modifier_nevermore_darklord_silence:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_darklord_silence:RemoveOnDeath() return false end