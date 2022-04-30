LinkLuaModifier("item_aeon_disk_custom_passive", "abilities/items/item_aeon_disk_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_aeon_disk_custom_cd", "abilities/items/item_aeon_disk_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_aeon_disk_custom_proc", "abilities/items/item_aeon_disk_custom", LUA_MODIFIER_MOTION_NONE)


item_aeon_disk_custom = class({})

function item_aeon_disk_custom:GetIntrinsicModifierName() return
    "item_aeon_disk_custom_passive"
end



item_aeon_disk_custom_passive = class({})
function item_aeon_disk_custom_passive:IsHidden() return true end
function item_aeon_disk_custom_passive:IsPurgable() return false end
function item_aeon_disk_custom_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function item_aeon_disk_custom_passive:RemoveOnDeath() return false end
function item_aeon_disk_custom_passive:DeclareFunctions()
return
{
   MODIFIER_PROPERTY_HEALTH_BONUS,
   MODIFIER_PROPERTY_MANA_BONUS,
   MODIFIER_EVENT_ON_TAKEDAMAGE

}
end


function item_aeon_disk_custom_passive:GetModifierHealthBonus()
    self:GetAbility():GetSpecialValueFor("bonus_health") end

function item_aeon_disk_custom_passive:GetModifierManaBonus()
    self:GetAbility():GetSpecialValueFor("bonus_mana") end


function item_aeon_disk_custom_passive:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end
if not params.attacker then return end
if not self:GetParent():IsAlive() then return end
if not params.attacker:IsHero() then return end
if self:GetParent() ~= params.unit then return end 
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():GetHealthPercent() > self:GetAbility():GetSpecialValueFor("health_threshold_pct") then return end
if self:GetParent():HasModifier("item_aeon_disk_custom_cd") then return end

local health_threshold_pct	= self:GetAbility():GetSpecialValueFor("health_threshold_pct") / 100.0
local cd = self:GetAbility():GetSpecialValueFor("cd")

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "item_aeon_disk_custom_cd", {duration = cd})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "item_aeon_disk_custom_proc", {duration = self:GetAbility():GetSpecialValueFor("duration")})
self:GetParent():EmitSound("DOTA_Item.ComboBreaker")
self:GetParent():Purge( false, true, false, true, true )

self:GetParent():SetHealth(math.min(self:GetParent():GetHealth(), self:GetParent():GetMaxHealth() * health_threshold_pct))

end


item_aeon_disk_custom_cd = class({})
function item_aeon_disk_custom_cd:IsHidden() return false end
function item_aeon_disk_custom_cd:IsPurgable() return false end
function item_aeon_disk_custom_cd:RemoveOnDeath() return false end
function item_aeon_disk_custom_cd:OnCreated(table)
self.RemoveForDuel = true
end
function item_aeon_disk_custom_cd:IsDebuff() return true end






item_aeon_disk_custom_proc = class({})
function item_aeon_disk_custom_proc:IsHidden() return false end
function item_aeon_disk_custom_proc:IsPurgable() return false end

function item_aeon_disk_custom_proc:OnCreated(table)
self.status = self:GetAbility():GetSpecialValueFor("status_resistance")
self.damage = -100


if not IsServer() then return end

local combo_breaker_particle = ParticleManager:CreateParticle("particles/items4_fx/combo_breaker_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(combo_breaker_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(combo_breaker_particle, false, false, -1, true, false)

end

function item_aeon_disk_custom_proc:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}

end

function item_aeon_disk_custom_proc:GetModifierStatusResistanceStacking() 
	return self.status
end


function item_aeon_disk_custom_proc:GetModifierIncomingDamage_Percentage()
	return self.damage
end
function item_aeon_disk_custom_proc:GetModifierTotalDamageOutgoing_Percentage()
	return self.damage
end