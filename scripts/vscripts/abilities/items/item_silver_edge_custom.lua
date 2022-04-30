LinkLuaModifier("item_silver_edge_custom_surge", "abilities/items/item_silver_edge_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_silver_edge_custom_strike", "abilities/items/item_silver_edge_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_silver_edge_custom_passive", "abilities/items/item_silver_edge_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_silver_edge_custom_break", "abilities/items/item_silver_edge_custom", LUA_MODIFIER_MOTION_NONE)

item_silver_edge_custom = class({})


function item_silver_edge_custom:OnSpellStart()
if not IsServer() then return end
    self:GetCaster():EmitSound("DOTA_Item.InvisibilitySword.Activate")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "item_silver_edge_custom_surge", {duration = self:GetSpecialValueFor("duration")})


end


function item_silver_edge_custom:GetIntrinsicModifierName() return  
"item_silver_edge_custom_passive"
end



item_silver_edge_custom_surge = class({})

function item_silver_edge_custom_surge:IsHidden() 
return self:GetStackCount() > 0 
end

function item_silver_edge_custom_surge:IsPurgable()   return false end

function item_silver_edge_custom_surge:GetEffectName() return "particles/silver_edge_speed_.vpcf" end
function item_silver_edge_custom_surge:OnCreated(table)

self.particle = ParticleManager:CreateParticle("particles/silver_edge_sword.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle, false, false, -1, false, false)


self.speed = self:GetAbility():GetSpecialValueFor("movement_speed")
self.proc = false
end

function item_silver_edge_custom_surge:GetCritDamage() return self:GetAbility():GetSpecialValueFor( "crit_multiplier" ) end


function item_silver_edge_custom_surge:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
}
end

function item_silver_edge_custom_surge:CheckState() return 
{[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
[MODIFIER_STATE_CANNOT_MISS] = true}
end

function item_silver_edge_custom_surge:GetModifierPreAttack_CriticalStrike( params )
if self:GetParent() ~= params.attacker then return end
if self.proc == true then return end


return self:GetAbility():GetSpecialValueFor("crit_multiplier") 
end


function item_silver_edge_custom_surge:GetModifierMoveSpeedBonus_Percentage() 
if self.proc == true then return end	
return self.speed 
end

function item_silver_edge_custom_surge:OnAttack(params)
if self:GetParent() ~= params.attacker then return end
if self.proc == true then return end

self.proc = true
self.record = params.record
self:SetStackCount(1) 

end



function item_silver_edge_custom_surge:GetModifierProcAttack_BonusDamage_Physical(params)
if params.attacker ~= self:GetParent() then return end
if self.proc == false then return end
if self.record ~= params.record then return end

    params.target:EmitSound("DOTA_Item.SilverEdge.Target")
    params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "item_silver_edge_custom_break", {duration = (1 - params.target:GetStatusResistance())*self:GetAbility():GetSpecialValueFor("backstab_duration")})
    self:Destroy()
    return self:GetAbility():GetSpecialValueFor("windwalk_bonus_damage") 
end







item_silver_edge_custom_strike = class({})
function item_silver_edge_custom_strike:IsHidden() return true end
function item_silver_edge_custom_strike:IsPurgable() return false end
function item_silver_edge_custom_strike:RemoveOnDeath() return false end

function item_silver_edge_custom_strike:OnCreated(table)
self.damage = self:GetAbility():GetSpecialValueFor("windwalk_bonus_damage")
end

function item_silver_edge_custom_strike:DeclareFunctions()
return
{
   MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
  }
end















item_silver_edge_custom_passive = class({})
function item_silver_edge_custom_passive:IsHidden() return true end
function item_silver_edge_custom_passive:IsPurgable() return false end
function item_silver_edge_custom_passive:RemoveOnDeath() return false end
function item_silver_edge_custom_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function item_silver_edge_custom_passive:GetCritDamage() return self:GetAbility():GetSpecialValueFor( "crit_multiplier" ) end
function item_silver_edge_custom_passive:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
   MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    
}
end
function item_silver_edge_custom_passive:GetModifierPreAttack_BonusDamage() return
self:GetAbility():GetSpecialValueFor("bonus_damage")
end


function item_silver_edge_custom_passive:GetModifierAttackSpeedBonus_Constant() return
self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function item_silver_edge_custom_passive:GetModifierPreAttack_CriticalStrike( params )
if not IsServer() then return end
local chance = self:GetAbility():GetSpecialValueFor("crit_chance")

local random = RollPseudoRandomPercentage(chance,112,self:GetParent())

if not random then return end

return self:GetAbility():GetSpecialValueFor("crit_multiplier") 

end




item_silver_edge_custom_break = class({})
function item_silver_edge_custom_break:IsHidden() return false end
function item_silver_edge_custom_break:IsPurgable() return false end
function item_silver_edge_custom_break:CheckState() return {[MODIFIER_STATE_PASSIVES_DISABLED] = true} end
function item_silver_edge_custom_break:GetEffectName() return "particles/items3_fx/silver_edge.vpcf" end
function item_silver_edge_custom_break:OnCreated(table)
if not IsServer() then return end
  self.particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_break.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)
end
