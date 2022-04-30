

modifier_terror_illusion_resist = class({})


function modifier_terror_illusion_resist:IsHidden() return true end
function modifier_terror_illusion_resist:IsPurgable() return false end



function modifier_terror_illusion_resist:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
    local ab = self:GetParent():FindAbilityByName("custom_terrorblade_conjure_image")
  if ab then  
  	self:GetParent():AddNewModifier(self:GetParent(), ab, "modifier_conjure_image_reduce_aura", {}) 
end
end


function modifier_terror_illusion_resist:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_illusion_resist:RemoveOnDeath() return false end