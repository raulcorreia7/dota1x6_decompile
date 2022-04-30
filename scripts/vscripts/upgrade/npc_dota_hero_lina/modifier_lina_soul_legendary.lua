

modifier_lina_soul_legendary = class({})


function modifier_lina_soul_legendary:IsHidden() return true end
function modifier_lina_soul_legendary:IsPurgable() return false end



function modifier_lina_soul_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  local ability = self:GetCaster():FindAbilityByName("lina_fiery_soul_custom")
  if ability and ability:GetLevel() > 0 then 
  	ability:SetActivated(false)
  end
end


function modifier_lina_soul_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_lina_soul_legendary:RemoveOnDeath() return false end