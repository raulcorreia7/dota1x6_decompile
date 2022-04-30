LinkLuaModifier("modifier_item_cleansing_blade", "abilities/items/item_cleansing_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_cleansing_blade_debuff", "abilities/items/item_cleansing_blade", LUA_MODIFIER_MOTION_NONE)

item_cleansing_blade = class({})

function item_cleansing_blade:GetIntrinsicModifierName()
	return "modifier_item_cleansing_blade"
end

function item_cleansing_blade:GetAOERadius()
return self:GetSpecialValueFor("debuff_radius")
end

function item_cleansing_blade:OnSpellStart()
if not IsServer() then return end
self:GetParent():EmitSound("DOTA_Item.DiffusalBlade.Target")
self:GetCursorTarget():EmitSound("Brewmaster_Storm.DispelMagic")



local duration = self:GetSpecialValueFor("purge_slow_duration")*(1 - self:GetCursorTarget():GetStatusResistance())

local friend = self:GetCaster():GetTeamNumber() == self:GetCursorTarget():GetTeamNumber()

local before = #self:GetCursorTarget():FindAllModifiers()

if friend then 
    local effect_cast = ParticleManager:CreateParticle( "particles/cleance_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCursorTarget())
    ParticleManager:SetParticleControl( effect_cast, 0, self:GetCursorTarget():GetAbsOrigin())
    ParticleManager:SetParticleControl( effect_cast, 1, Vector(200,0,0) )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    self:GetCursorTarget():Purge(not friend, friend, false, false, false)
end


local after = #self:GetCursorTarget():FindAllModifiers()


local count = math.min((before - after),self:GetSpecialValueFor("heal_max")/self:GetSpecialValueFor("heal_count"))

local heal = count*self:GetCaster():GetMaxHealth()*self:GetSpecialValueFor("heal_count")/100

if heal > 0 then 

    self:GetCaster():Heal(heal, self:GetCaster())
    local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:ReleaseParticleIndex( particle )
    local particle_2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:ReleaseParticleIndex( particle_2 )
    SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

end



if not friend then 

    if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end

    self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_item_cleansing_blade_debuff", {duration = duration})

    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/pulse/void_spirit_int.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetCursorTarget(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCursorTarget():GetAbsOrigin(),  true )
    ParticleManager:SetParticleControlEnt( effect_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true  )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end


end


modifier_item_cleansing_blade = class({})

function modifier_item_cleansing_blade:IsHidden() return true end
function modifier_item_cleansing_blade:IsPurgable() return false end
function modifier_item_cleansing_blade:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_cleansing_blade:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    }

    return funcs
end


function modifier_item_cleansing_blade:GetModifierBonusStats_Strength()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_strength") end
end
function modifier_item_cleansing_blade:GetModifierBonusStats_Agility()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_agility") end
end
function modifier_item_cleansing_blade:GetModifierBonusStats_Intellect()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
end

function modifier_item_cleansing_blade:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end
if params.attacker:FindAllModifiersByName(self:GetName())[1] ~= self then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.attacker ~= self:GetParent() then return end
if params.target:IsMagicImmune() then return end
if self:GetParent():HasModifier("modifier_item_diffusal_blade") then return end

local mana = self:GetAbility():GetSpecialValueFor("feedback_mana_burn") + self:GetAbility():GetSpecialValueFor("feedback_mana_burn_pct")*params.target:GetMaxMana()/100
if self:GetParent():IsIllusion() then 
    if self:GetParent():IsRangedAttacker() then 
        mana = self:GetAbility():GetSpecialValueFor("feedback_mana_burn_illusion_ranged")
    else 
        mana = self:GetAbility():GetSpecialValueFor("feedback_mana_burn_illusion_melee")
    end
end

if params.target:GetMana() < mana then 
    mana = params.target:GetMana()
end

local effect = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)

params.target:ReduceMana(mana)

return mana

end





modifier_item_cleansing_blade_debuff = class({})
function modifier_item_cleansing_blade_debuff:IsHidden() return false end
function modifier_item_cleansing_blade_debuff:IsPurgable() return true end
function modifier_item_cleansing_blade_debuff:GetEffectName() return "particles/items_fx/diffusal_slow.vpcf" end


function modifier_item_cleansing_blade_debuff:OnCreated(table)
self.slow = -100
self.tick = 20

self.interval = self:GetRemainingTime()/self:GetAbility():GetSpecialValueFor("purge_rate")
self:StartIntervalThink(self.interval)
end

function modifier_item_cleansing_blade_debuff:OnRefresh(table)
self:OnCreated(table)
end

function modifier_item_cleansing_blade_debuff:OnIntervalThink()
self.slow = self.slow + self.tick
end

function modifier_item_cleansing_blade_debuff:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end


function modifier_item_cleansing_blade_debuff:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end