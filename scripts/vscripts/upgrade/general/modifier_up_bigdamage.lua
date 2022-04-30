LinkLuaModifier("modifier_up_bigdamage_heal", "upgrade/general/modifier_up_bigdamage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_up_bigdamage_heal_mod", "upgrade/general/modifier_up_bigdamage.lua", LUA_MODIFIER_MOTION_NONE)

modifier_up_bigdamage = class({})


function modifier_up_bigdamage:IsHidden() return true end
function modifier_up_bigdamage:IsPurgable() return false end




function modifier_up_bigdamage:DeclareFunctions()
    return {

        MODIFIER_EVENT_ON_TAKEDAMAGE

    } end



function modifier_up_bigdamage:OnTakeDamage( params )
if not IsServer() then return end
    
    if (self:GetParent() == params.unit)  then 
  
        if params.damage >= (self:GetParent():GetMaxHealth()*0.2) then
          self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_bigdamage_heal", {duration = 5})
          self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_bigdamage_heal_mod", {duration = 5})
          
        end
    end


end
 

function modifier_up_bigdamage:OnCreated(table)
if not IsServer() then return end
self.heal = 2
  self:SetStackCount(1)
end


function modifier_up_bigdamage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end


function modifier_up_bigdamage:RemoveOnDeath() return false end
  

modifier_up_bigdamage_heal = class({})

function modifier_up_bigdamage_heal:GetTexture() return "tinker_defense_matrix" end

function modifier_up_bigdamage_heal:IsPurgable() return false end

function modifier_up_bigdamage_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_up_bigdamage_heal:IsHidden() return true end


function modifier_up_bigdamage_heal:DeclareFunctions()
  return
{

  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end
 

function modifier_up_bigdamage_heal:GetModifierHealthRegenPercentage() return 
(1 + 1*self:GetParent():GetUpgradeStack("modifier_up_bigdamage"))
end



function modifier_up_bigdamage_heal:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_up_bigdamage_heal_mod")
if mod then 
  mod:DecrementStackCount()
end


end




modifier_up_bigdamage_heal_mod = class({})

function modifier_up_bigdamage_heal_mod:IsHidden() return false end
function modifier_up_bigdamage_heal_mod:GetTexture() return "tinker_defense_matrix" end
function modifier_up_bigdamage_heal_mod:IsPurgable() return false end
function modifier_up_bigdamage_heal_mod:GetEffectName() return "particles/units/heroes/hero_tinker/tinker_defense_matrix.vpcf" end
function modifier_up_bigdamage_heal_mod:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_up_bigdamage_heal_mod:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_up_bigdamage_heal_mod:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_up_bigdamage_heal_mod:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}

end

function modifier_up_bigdamage_heal_mod:OnTooltip()
return (1 + 1*self:GetParent():GetUpgradeStack("modifier_up_bigdamage"))*self:GetStackCount()
end