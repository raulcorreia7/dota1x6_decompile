

modifier_void_step_legendary = class({})


function modifier_void_step_legendary:IsHidden() return true end
function modifier_void_step_legendary:IsPurgable() return false end



function modifier_void_step_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  local ability = self:GetParent():FindAbilityByName("void_spirit_astral_replicant")
  if not ability then return end

  ability:SetHidden(false)  

  if not ability:IsTrained() then      
      ability:SetLevel(1)
  end
  
end


function modifier_void_step_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_void_step_legendary:RemoveOnDeath() return false end