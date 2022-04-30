

modifier_antimage_void_7 = class({})


function modifier_antimage_void_7:IsHidden() return true end
function modifier_antimage_void_7:IsPurgable() return false end



function modifier_antimage_void_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  local ability = self:GetParent():FindAbilityByName("antimage_spell_seal_custom")
  if ability then 
  	ability:SetHidden(false)
  end
end


function modifier_antimage_void_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_antimage_void_7:RemoveOnDeath() return false end