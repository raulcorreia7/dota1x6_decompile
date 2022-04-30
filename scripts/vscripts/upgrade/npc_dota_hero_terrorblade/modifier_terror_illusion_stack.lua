

modifier_terror_illusion_stack = class({})


function modifier_terror_illusion_stack:IsHidden() return true end
function modifier_terror_illusion_stack:IsPurgable() return false end



function modifier_terror_illusion_stack:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.StackOnIllusion = true 

  local ability = self:GetParent():FindAbilityByName("custom_terrorblade_conjure_image")
  if ability then 
  	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_conjure_image_legendary_aura", {})
  end

end


function modifier_terror_illusion_stack:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_illusion_stack:RemoveOnDeath() return false end