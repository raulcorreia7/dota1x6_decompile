LinkLuaModifier("modifier_skeleton_king_reincarnation_custom", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_slow", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skelet_reincarnation", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_silence", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_damage", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_shield", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_active", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_legendary", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_legendary_start", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_legendary_cd", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)



skeleton_king_reincarnation_custom = class({})

skeleton_king_reincarnation_custom.silence_duration = 5

skeleton_king_reincarnation_custom.damage_init = 3
skeleton_king_reincarnation_custom.damage_inc = 3

skeleton_king_reincarnation_custom.res_init = -0.3
skeleton_king_reincarnation_custom.res_inc = -0.3

skeleton_king_reincarnation_custom.shield_init = 0.05
skeleton_king_reincarnation_custom.shield_inc = 0.05
skeleton_king_reincarnation_custom.shield_duration = 20

skeleton_king_reincarnation_custom.cd_health = 0.15
skeleton_king_reincarnation_custom.cd_init = 0.5
skeleton_king_reincarnation_custom.cd_inc = 0.5

skeleton_king_reincarnation_custom.active_health = 20
skeleton_king_reincarnation_custom.active_duration = 5
skeleton_king_reincarnation_custom.active_resist = 50
skeleton_king_reincarnation_custom.active_damage = 30

skeleton_king_reincarnation_custom.legendary_duration = 5
skeleton_king_reincarnation_custom.legendary_health = 0.5
skeleton_king_reincarnation_custom.legendary_start = 0.5

function skeleton_king_reincarnation_custom:GetIntrinsicModifierName()
	return "modifier_skeleton_king_reincarnation_custom"
end

function  skeleton_king_reincarnation_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_skeleton_reincarnation_6") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function skeleton_king_reincarnation_custom:OnAbilityPhaseStart()
if not IsServer() then return end

if self:GetCaster():GetHealthPercent() < self.active_health then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerID()), "CreateIngameErrorMessage", {message = "#reinc_health"})
    return false
end
    return true
end

function skeleton_king_reincarnation_custom:OnSpellStart()
if not self:GetCaster():HasModifier("modifier_skeleton_reincarnation_6") then return end
if not IsServer() then return end
self:EndCooldown()

self:GetCaster().active_res = true
self:GetCaster():Kill(self,self:GetCaster())

end


function skeleton_king_reincarnation_custom:GetManaCost(level)
    if self:GetCaster():HasShard() then
        return 0
    end
    return self.BaseClass.GetManaCost(self, level)
end

modifier_skeleton_king_reincarnation_custom = class({})

function modifier_skeleton_king_reincarnation_custom:RemoveOnDeath() return false end
function modifier_skeleton_king_reincarnation_custom:IsHidden() return true end
function modifier_skeleton_king_reincarnation_custom:IsPurgable() return false end

function modifier_skeleton_king_reincarnation_custom:OnCreated(table)
if not IsServer() then return end
self:GetParent().reincarnate_res = false
end

function modifier_skeleton_king_reincarnation_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_REINCARNATION,                      
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_RESPAWN,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_MIN_HEALTH
    }

end


function modifier_skeleton_king_reincarnation_custom:GetMinHealth()
if self:GetParent():HasModifier("modifier_death") and not self:GetParent():HasModifier("modifier_axe_culling_blade_custom_aegis") then return end
if self:GetAbility():IsFullyCastable() then return end
if not self:GetParent():IsRealHero() then return end
if self:GetParent():HasModifier("modifier_skeleton_king_reincarnation_custom_legendary") then return end
if not self:GetParent():HasModifier("modifier_skeleton_reincarnation_legendary")then return end
if self:GetParent():HasModifier("modifier_skeleton_king_reincarnation_custom_legendary_cd") then return end
return 1
end


function modifier_skeleton_king_reincarnation_custom:OnTakeDamage(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end

if self:GetParent():HasModifier("modifier_skeleton_reincarnation_legendary") and self:GetParent():GetHealth() == 1 and
    not self:GetAbility():IsFullyCastable() and not self:GetParent():HasModifier("modifier_skeleton_king_reincarnation_custom_legendary") then 
    self:GetParent():SetHealth(self:GetParent():GetMaxHealth()*self:GetAbility().legendary_health)

    self:GetParent():EmitSound("WK.res_legen")
    self:GetParent():Purge(false, true, false, true, false)
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_reincarnation_custom_legendary", {target = params.attacker:entindex(), duration = self:GetAbility().legendary_duration + self:GetAbility().legendary_start})
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_reincarnation_custom_legendary_start", {duration = self:GetAbility().legendary_start})
end

if not self:GetParent():HasModifier("modifier_skeleton_reincarnation_4") then return end

if self:GetAbility():GetCooldownTimeRemaining() < 1 then 
    self:SetStackCount(0)
    return
end


self:SetStackCount(self:GetStackCount() + params.damage)
if self:GetStackCount() >= self:GetAbility().cd_health*self:GetParent():GetMaxHealth() then 
    self:SetStackCount(0)

    local cd = self:GetAbility():GetCooldownTimeRemaining()
    self:GetAbility():EndCooldown()

    local reduce_cd = self:GetAbility().cd_init + self:GetAbility().cd_inc*self:GetParent():GetUpgradeStack("modifier_skeleton_reincarnation_4")

    if cd > reduce_cd then 
        self:GetAbility():StartCooldown(cd - reduce_cd)
    end

end


end

function modifier_skeleton_king_reincarnation_custom:OnRespawn(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end

self.reincarnation_death = false
if self:GetParent().active_res and self:GetParent().active_res == true then 
    self:GetParent().active_res = false
    local duration = self:GetAbility().active_duration
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_reincarnation_custom_active", {duration = duration})
end


if self:GetParent().reincarnate_res == false then return end

self:GetParent().reincarnate_res = false

if self:GetParent():HasModifier("modifier_skeleton_reincarnation_1") then 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_reincarnation_custom_shield", {duration = self:GetAbility().shield_duration})
end

if self:GetParent():HasScepter() then 
    local crit = self:GetParent():FindAbilityByName("skeleton_king_mortal_strike_custom")
    if crit and crit:GetLevel() > 0 then 


        self:GetParent():AddNewModifier(self:GetParent(), crit, "modifier_skeleton_king_mortal_strike_scepter", {stack = self:GetAbility():GetSpecialValueFor("scepter_strikes"), duration = self:GetAbility():GetSpecialValueFor("scepter_duration")})
    end
end

end

function modifier_skeleton_king_reincarnation_custom:ReincarnateTime()
    if IsServer() then
        local bonus = 0

        if self:GetCaster():HasModifier("modifier_skeleton_reincarnation_3") then 
            bonus = self:GetAbility().res_init + self:GetAbility().res_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_reincarnation_3")
        end

        if self:GetParent():IsRealHero() and (not self:GetParent():HasModifier("modifier_death") or self:GetParent():HasModifier("modifier_axe_culling_blade_custom_aegis")) and self:GetAbility():IsFullyCastable() then

            return self:GetAbility():GetSpecialValueFor("reincarnate_time") + bonus
        end

        return nil
    end
end

function modifier_skeleton_king_reincarnation_custom:GetActivityTranslationModifiers()
    if self.reincarnation_death then
        return "reincarnate"
    end
    return nil
end

function modifier_skeleton_king_reincarnation_custom:OnDeath(params)
    if not IsServer() then return end
    local unit = params.unit
    local reincarnate = params.reincarnate
    if self:GetParent() ~= unit then return end
    if not self:GetAbility():IsFullyCastable() then return end
    self:GetAbility():ReincarnationStart( params, self, self:GetParent() )
end

function skeleton_king_reincarnation_custom:ReincarnationStart( params, modifier, caster )
    local unit = params.unit
    local reincarnate = params.reincarnate

    if reincarnate then
        modifier.reincarnation_death = true

        caster.reincarnate_res = true

        self:UseResources(true, false, true)
        local slow_duration = self:GetSpecialValueFor("slow_duration")
        local slow_radius = self:GetSpecialValueFor("slow_radius")
        local reincarnation_time = self:GetSpecialValueFor("reincarnate_time")

        local heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER,false)
        
        for _, target in ipairs(heroes) do
            if target:GetUnitName() ~= "npc_teleport" then 
                if self:GetCaster():HasScepter() then 
                    local stun = self:GetCaster():FindAbilityByName("skeleton_king_hellfire_blast_custom")
                    if stun and stun:GetLevel() > 0 then 
                        stun:OnSpellStart(target)
                    end
                end

                target:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_reincarnation_custom_slow", {duration = (1 - target:GetStatusResistance())*slow_duration})

                if caster:HasModifier("modifier_skeleton_reincarnation_5") then 
                    target:AddNewModifier(caster, self, "modifier_skeleton_king_reincarnation_custom_silence", {duration = (1 - target:GetStatusResistance())*self.silence_duration})
                end

                if target:IsRealHero() then
                    if self:GetCaster():HasShard()  then
                        local ability_skeletons = self:GetCaster():FindAbilityByName("skeleton_king_vampiric_aura_custom")
                        for i=0, 2 do
                            if ability_skeletons:GetLevel() > 0 then
                                ability_skeletons:CreateSkeleton(self:GetCaster():GetAbsOrigin(), target, nil, true)
                            end
                        end
                    end
                end
            end
        end

        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", PATTACH_CUSTOMORIGIN, params.unit)
        ParticleManager:SetParticleAlwaysSimulate(particle)
        ParticleManager:SetParticleControl(particle, 0, params.unit:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, Vector(reincarnation_time, 0, 0))
        ParticleManager:SetParticleControl(particle, 11, Vector(200, 0, 0))
        ParticleManager:ReleaseParticleIndex(particle)

        params.unit:EmitSound("Hero_SkeletonKing.Reincarnate")

        if GameRules:IsDaytime() then
            AddFOWViewer(self:GetCaster():GetTeamNumber(), params.unit:GetAbsOrigin(), 1800, reincarnation_time, true)
        else
            AddFOWViewer(self:GetCaster():GetTeamNumber(), params.unit:GetAbsOrigin(), 800, reincarnation_time, true)
        end
    else                
        modifier.reincarnation_death = false     
    end
end

modifier_skeleton_king_reincarnation_custom_slow = class({})

function modifier_skeleton_king_reincarnation_custom_slow:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_slow:IsPurgable() return true end

function modifier_skeleton_king_reincarnation_custom_slow:OnCreated()    
	if not IsServer() then return end
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    self:AddParticle(particle, false, false, -1, false, false)    
end

function modifier_skeleton_king_reincarnation_custom_slow:DeclareFunctions()
    local decFuncs = {
    	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
    return decFuncs
end

function modifier_skeleton_king_reincarnation_custom_slow:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_skeleton_king_reincarnation_custom_slow:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("attackslow")
end





modifier_skeleton_king_reincarnation_custom_silence = class({})
function modifier_skeleton_king_reincarnation_custom_silence:IsPurgable() return true end
function modifier_skeleton_king_reincarnation_custom_silence:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_silence:CheckState()
return
{
    [MODIFIER_STATE_SILENCED] = true
}
end

function modifier_skeleton_king_reincarnation_custom_silence:GetTexture() return "buffs/reincarnate_silence" end
function modifier_skeleton_king_reincarnation_custom_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_skeleton_king_reincarnation_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


modifier_skeleton_king_reincarnation_custom_damage = class({})
function modifier_skeleton_king_reincarnation_custom_damage:IsHidden() 
    return self:GetStackCount() == 1
end
function modifier_skeleton_king_reincarnation_custom_damage:GetTexture() return "buffs/reincarnation_damage" end
function modifier_skeleton_king_reincarnation_custom_damage:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_damage:RemoveOnDeath() return false end
function modifier_skeleton_king_reincarnation_custom_damage:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(0.1)
end

function modifier_skeleton_king_reincarnation_custom_damage:OnIntervalThink()
if not IsServer() then return end
if self:GetAbility():GetCooldownTimeRemaining() > 0 then 
    self:SetStackCount(0)
else 
    self:SetStackCount(1)
end

end

function modifier_skeleton_king_reincarnation_custom_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}

end

function modifier_skeleton_king_reincarnation_custom_damage:GetModifierTotalDamageOutgoing_Percentage()
if self:GetStackCount() == 1 then return end
return self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetParent():GetUpgradeStack("modifier_skeleton_reincarnation_2")
end






modifier_skeleton_king_reincarnation_custom_shield = class({})
function modifier_skeleton_king_reincarnation_custom_shield:IsHidden() 
    return false
end
function modifier_skeleton_king_reincarnation_custom_shield:GetTexture() return "buffs/reincarnation_shield" end
function modifier_skeleton_king_reincarnation_custom_shield:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_shield:RemoveOnDeath() return false end
function modifier_skeleton_king_reincarnation_custom_shield:OnCreated(table)
if not IsServer() then return end

local shield_size = self:GetParent():GetModelRadius() * 0.9

local particle = ParticleManager:CreateParticle("particles/wk_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
local common_vector = Vector(shield_size,0,shield_size)
ParticleManager:SetParticleControl(particle, 1, common_vector)
ParticleManager:SetParticleControl(particle, 2, common_vector)
ParticleManager:SetParticleControl(particle, 4, common_vector)
ParticleManager:SetParticleControl(particle, 5, Vector(shield_size,0,0))

ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(particle, false, false, -1, false, false)


self.shield = self:GetParent():GetMaxHealth()*(self:GetAbility().shield_init + self:GetAbility().shield_inc*self:GetParent():GetUpgradeStack("modifier_skeleton_reincarnation_1"))
self:SetStackCount(self.shield)
end


function modifier_skeleton_king_reincarnation_custom_shield:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
}

end


function modifier_skeleton_king_reincarnation_custom_shield:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end

if params.damage_type == DAMAGE_TYPE_MAGICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_magic_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end

if params.damage_type == DAMAGE_TYPE_PHYSICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_attack_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end


    if params.damage>self.shield then
        self:Destroy()
        return self.shield
    else
        self.shield = self.shield-params.damage
        self:SetStackCount(self.shield)
        return params.damage
    end

end


modifier_skeleton_king_reincarnation_custom_active = class({})
function modifier_skeleton_king_reincarnation_custom_active:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_active:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_active:GetTexture() return "buffs/reincarnation_active" end

function modifier_skeleton_king_reincarnation_custom_active:GetEffectName() return "particles/generic_gameplay/rune_haste_owner.vpcf" end
function modifier_skeleton_king_reincarnation_custom_active:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_skeleton_king_reincarnation_custom_active:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
    self:GetParent():EmitSound("WK.res_active")
    local particle = ParticleManager:CreateParticle("particles/items4_fx/ascetic_cap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    self:AddParticle(particle, false, false, -1, false, false) 
end



function modifier_skeleton_king_reincarnation_custom_active:GetModifierStatusResistanceStacking() 
    return self:GetAbility().active_resist
end
function modifier_skeleton_king_reincarnation_custom_active:GetModifierTotalDamageOutgoing_Percentage()
    return self:GetAbility().active_damage
end


modifier_skeleton_king_reincarnation_custom_legendary = class({})
function modifier_skeleton_king_reincarnation_custom_legendary:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_legendary:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_legendary:GetStatusEffectName()
    return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end
function modifier_skeleton_king_reincarnation_custom_legendary:StatusEffectPriority()
 return 99999 end

function modifier_skeleton_king_reincarnation_custom_legendary:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MODEL_SCALE,
    MODIFIER_PROPERTY_DISABLE_HEALING,
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
    }
 end

function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierLifestealRegenAmplify_Percentage() return -9999 end
function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierHealAmplify_PercentageTarget() return -9999 end
function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierHPRegenAmplify_Percentage() return -9999 end
function modifier_skeleton_king_reincarnation_custom_legendary:GetDisableHealing() return 1 end

function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierModelScale()
return 30
end

function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierTotalDamageOutgoing_Percentage()
return -100
end


function modifier_skeleton_king_reincarnation_custom_legendary:OnCreated(table)
if not IsServer() then return end
self.target = EntIndexToHScript(table.target)
end

function modifier_skeleton_king_reincarnation_custom_legendary:OnDestroy()
if not IsServer() then return end

if self:GetRemainingTime() <= 0.1 then 
    self:GetAbility():EndCooldown()
end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_reincarnation_custom_legendary_cd", {duration = 1})

if not self:GetParent():HasModifier("modifier_final_duel_start") then 
    self:GetParent():Kill(self:GetAbility(), self.target)
end

end

modifier_skeleton_king_reincarnation_custom_legendary_start = class({})
function modifier_skeleton_king_reincarnation_custom_legendary_start:IsHidden() return true end
function modifier_skeleton_king_reincarnation_custom_legendary_start:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_legendary_start:CheckState()
return
{
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true
}
end

modifier_skeleton_king_reincarnation_custom_legendary_cd = class({})
function modifier_skeleton_king_reincarnation_custom_legendary_cd:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_legendary_cd:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_legendary_cd:RemoveOnDeath() return false end