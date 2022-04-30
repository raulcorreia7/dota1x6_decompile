LinkLuaModifier("modifier_antimage_resist", "abilities/npc_antimage_resist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_bkb", "abilities/npc_antimage_resist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_antimage_bkb_cd", "abilities/npc_antimage_resist", LUA_MODIFIER_MOTION_NONE)

npc_antimage_resist = class({})


function npc_antimage_resist:GetIntrinsicModifierName() return "modifier_antimage_resist" end
 
modifier_antimage_resist = class ({})

function modifier_antimage_resist:IsHidden() return true end
function modifier_antimage_resist:IsPurgable() return false end

function modifier_antimage_resist:DeclareFunctions() return {

    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    MODIFIER_EVENT_ON_TAKEDAMAGE

} end


function modifier_antimage_resist:GetModifierMagicalResistanceBonus() return self:GetAbility():GetSpecialValueFor("resist") end

function modifier_antimage_resist:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent():HasModifier("modifier_antimage_bkb_cd") then return end
if self:GetParent():GetHealthPercent() > self:GetAbility():GetSpecialValueFor("health") then return end
if not self:GetParent():IsAlive() then return end

self:GetParent():Purge(false, true, false, true, false)
self:GetParent():EmitSound("DOTA_Item.MinotaurHorn.Cast")
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_bkb", {duration = self:GetAbility():GetSpecialValueFor("bkb")})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_bkb_cd", {})

end


modifier_antimage_bkb_cd = class({})
function modifier_antimage_bkb_cd:IsHidden() return true end
function modifier_antimage_bkb_cd:IsPurgable() return false end



modifier_antimage_bkb = class({})
function modifier_antimage_bkb:IsHidden() return false end
function modifier_antimage_bkb:IsPurgable() return false end
function modifier_antimage_bkb:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true} end
function modifier_antimage_bkb:GetEffectName() return "particles/items5_fx/minotaur_horn.vpcf" end