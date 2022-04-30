

modifier_axe_culling_legendary = class({})


function modifier_axe_culling_legendary:IsHidden() return true end
function modifier_axe_culling_legendary:IsPurgable() return false end



function modifier_axe_culling_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  local ability = self:GetCaster():FindAbilityByName("axe_culling_blade_custom_legendary")
  if ability then 
  	ability:SetHidden(false)
  end
end


function modifier_axe_culling_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_axe_culling_legendary:RemoveOnDeath() return false end