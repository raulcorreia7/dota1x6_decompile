LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_custom_debuff", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_custom_speed", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_custom_illusion", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_healing", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )

skeleton_king_hellfire_blast_custom = class({})

skeleton_king_hellfire_blast_custom.str_init  = 0.4
skeleton_king_hellfire_blast_custom.str_inc = 0.2

skeleton_king_hellfire_blast_custom.stun_init = 0
skeleton_king_hellfire_blast_custom.stun_inc = 0.3

skeleton_king_hellfire_blast_custom.speed_move_init = 5
skeleton_king_hellfire_blast_custom.speed_move_inc = 5
skeleton_king_hellfire_blast_custom.speed_attack_init = 20
skeleton_king_hellfire_blast_custom.speed_attack_inc = 10
skeleton_king_hellfire_blast_custom.speed_duration = 4

skeleton_king_hellfire_blast_custom.slow_move = -25
skeleton_king_hellfire_blast_custom.slow_duration = 3

skeleton_king_hellfire_blast_custom.legendary_duration = 6
skeleton_king_hellfire_blast_custom.legendary_damage = 0.6

skeleton_king_hellfire_blast_custom.healing_damage = -30
skeleton_king_hellfire_blast_custom.healing_heal = -50 
skeleton_king_hellfire_blast_custom.healing_duration = 4

skeleton_king_hellfire_blast_custom.attack_init = 0.1
skeleton_king_hellfire_blast_custom.attack_inc = 0.1
skeleton_king_hellfire_blast_custom.attack_radius = 300



function skeleton_king_hellfire_blast_custom:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function skeleton_king_hellfire_blast_custom:GetManaCost(level)
    return self.BaseClass.GetManaCost(self, level)
end

function skeleton_king_hellfire_blast_custom:GetCastRange(location, target)
    return self.BaseClass.GetCastRange(self, location, target)
end

function skeleton_king_hellfire_blast_custom:OnAbilityPhaseStart()
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_warmup.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)
    return true
end

function skeleton_king_hellfire_blast_custom:OnSpellStart(new_target)
    if not IsServer() then return end


    local target = self:GetCursorTarget()
    if new_target ~= nil then 
        target = new_target
    end

    local info = {
        EffectName = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf",
        Ability = self,
        iMoveSpeed = self:GetSpecialValueFor("blast_speed"),
        Source = self:GetCaster(),
        Target = target,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
    }
    ProjectileManager:CreateTrackingProjectile( info )
    self:GetCaster():EmitSound("Hero_SkeletonKing.Hellfire_Blast")

    if self:GetCaster():HasModifier("modifier_skeleton_blast_2") then 
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_hellfire_blast_custom_speed", {duration = self.speed_duration})
    end


    if self:GetCaster():HasModifier("modifier_skeleton_blast_legendary") and target:IsRealHero() then 

            local vector = (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Normalized()

            local illusion = CreateUnitByName(target:GetUnitName(), self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*200, false, target, target, target:GetTeamNumber())
            
            local particle = ParticleManager:CreateParticle("particles/wk_stun_legen.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 1, illusion:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(particle)
            

            FindClearSpaceForUnit(illusion, illusion:GetAbsOrigin(), false) 
            illusion:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = self.legendary_duration})

            illusion:AddNewModifier(self:GetCaster(), self, "modifier_chaos_knight_phantasm_illusion", {})

            illusion:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_hellfire_blast_custom_illusion", {duration = self.legendary_duration, target = target:entindex()})
        
            illusion:AddNewModifier(self:GetCaster(), self, "modifier_illusion", {outgoing_damage = 0, incoming_damage = 0, duration = self.legendary_duration})
            illusion.owner = self:GetCaster()   


            if target:IsHero() then 

                for i = 1,target:GetLevel() - 1 do 
                  illusion:HeroLevelUp(false)
                end



                for itemSlot=0,5 do

                    local itemName = target:GetItemInSlot(itemSlot)
                    if itemName then 
                        local newItem = CreateItem(itemName:GetName(), illusion, illusion)

                        illusion:AddItem(newItem)
                    end
                end


                for _,modifier in pairs(target:FindAllModifiers()) do 

                    if modifier.StackOnIllusion ~= nil and modifier.StackOnIllusion == true then
                        local mod = illusion:AddNewModifier(illusion, nil, modifier:GetName(), {})
                        mod:SetStackCount(modifier:GetStackCount())
                        illusion:CalculateStatBonus(true)
                    end
                end
            end


            illusion:MakeIllusion()
      
    end


end

function skeleton_king_hellfire_blast_custom:OnProjectileHit( target, vLocation )
    if not IsServer() then return end
    if target ~= nil and ( not target:IsMagicImmune() ) and ( not target:TriggerSpellAbsorb( self ) ) then


       
        if self:GetCaster():HasModifier("modifier_skeleton_blast_6") then 
            target:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_hellfire_blast_healing", {duration = self.healing_duration})
        end


        local stun_duration = self:GetSpecialValueFor( "blast_stun_duration" )

        if self:GetCaster():HasModifier("modifier_skeleton_blast_1") then 
            stun_duration = stun_duration + self.stun_init + self.stun_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_blast_1")
        end

        local stun_damage = self:GetAbilityDamage()


        if self:GetCaster():HasModifier("modifier_skeleton_blast_3") then 
            stun_damage = stun_damage + self:GetCaster():GetStrength()*(self.str_init + self.str_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_blast_3"))
        end

        

        local slow_duration = self:GetSpecialValueFor( "blast_dot_duration" )
        local damage = {
            victim = target,
            attacker = self:GetCaster(),
            damage = stun_damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        }
        ApplyDamage( damage )







        target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_duration * (1 - target:GetStatusResistance())})
        target:AddNewModifier( self:GetCaster(), self, "modifier_skeleton_king_hellfire_blast_custom_debuff", { duration = (slow_duration + stun_duration) * (1 - target:GetStatusResistance())} )
        target:EmitSound("Hero_SkeletonKing.Hellfire_BlastImpact")
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(particle)

        if not self:GetCaster():HasModifier("modifier_skeleton_vampiric_legendary") then 

            local all_skeletons = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
            for _, skelet in pairs(all_skeletons) do
                if skelet:GetUnitName() == "npc_dota_wraith_king_skeleton_warrior_custom" then
                    local modifier = skelet:FindModifierByName("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai")
                    if modifier then
                        skelet:SetForceAttackTarget(nil)
                        modifier.target = target
                        skelet:SetForceAttackTarget(target)
                        skelet:SetAggroTarget(target)
                    end
                end
            end
        end
    end
    return true
end

modifier_skeleton_king_hellfire_blast_custom_debuff = class({})

function modifier_skeleton_king_hellfire_blast_custom_debuff:IsPurgable() return true end
function modifier_skeleton_king_hellfire_blast_custom_debuff:IsPurgeException() return true end

function modifier_skeleton_king_hellfire_blast_custom_debuff:OnCreated( kv )
    self.per_damage = self:GetAbility():GetSpecialValueFor( "blast_dot_damage" )
    self.move_slow = self:GetAbility():GetSpecialValueFor( "blast_slow" )


    if self:GetCaster():HasModifier("modifier_skeleton_blast_5") then 
        self.move_slow = self.move_slow + self:GetAbility().slow_move
    end

    if not IsServer() then return end

    local stun_duration = self:GetAbility():GetSpecialValueFor( "blast_stun_duration" )

    if self:GetCaster():HasModifier("modifier_skeleton_blast_1") then 
        stun_duration = stun_duration + self:GetAbility().stun_init + self:GetAbility().stun_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_blast_1")
    end
    self:StartIntervalThink( stun_duration )
end

function modifier_skeleton_king_hellfire_blast_custom_debuff:OnRefresh( kv )
    self.per_damage = self:GetAbility():GetSpecialValueFor( "blast_dot_damage" )
    self.move_slow = self:GetAbility():GetSpecialValueFor( "blast_slow" )
    
    if self:GetCaster():HasModifier("modifier_skeleton_blast_5") then 
        self.move_slow = self.move_slow + self:GetAbility().slow_move
    end

    if not IsServer() then return end
end

function modifier_skeleton_king_hellfire_blast_custom_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end


function modifier_skeleton_king_hellfire_blast_custom_debuff:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetCaster() ~= params.attacker then return end
if not self:GetCaster():HasModifier("modifier_skeleton_blast_4") then return end
if params.inflictor ~= nil then return end

self.effect_target = ParticleManager:CreateParticle( "particles/wk_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_target, 0, self:GetParent():GetAbsOrigin() )
  
local damage = (self:GetAbility().attack_init + self:GetAbility().attack_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_blast_4"))*params.damage

local all_targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().attack_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false )            
for _,target_new in pairs(all_targets) do     
    local damage = {
    victim = target_new,
    attacker = self:GetCaster(),
    damage = damage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self:GetAbility()
    }
    ApplyDamage( damage )
end



end

function modifier_skeleton_king_hellfire_blast_custom_debuff:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetCaster() then return end
if params.target ~= self:GetParent() then return end
if not self:GetCaster():HasModifier("modifier_skeleton_blast_5") then return end

local duration = self:GetAbility().slow_duration
self:SetDuration(duration, true)
end


function modifier_skeleton_king_hellfire_blast_custom_debuff:GetModifierMoveSpeedBonus_Percentage( params )
    return self.move_slow
end

function modifier_skeleton_king_hellfire_blast_custom_debuff:OnIntervalThink()
if not IsServer() then return end

    local damage = self.per_damage

    if self:GetCaster():HasModifier("modifier_skeleton_blast_3") then 
        damage = damage + self:GetCaster():GetStrength()*(self:GetAbility().str_init + self:GetAbility().str_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_blast_3"))
    end

    local damage = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
    }
    ApplyDamage( damage )
    self:StartIntervalThink(1.05)
end

function modifier_skeleton_king_hellfire_blast_custom_debuff:GetEffectName()
    return "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_debuff.vpcf"
end

function modifier_skeleton_king_hellfire_blast_custom_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end



modifier_skeleton_king_hellfire_blast_custom_speed = class({})
function modifier_skeleton_king_hellfire_blast_custom_speed:IsHidden() return false end
function modifier_skeleton_king_hellfire_blast_custom_speed:IsPurgable() return true end
function modifier_skeleton_king_hellfire_blast_custom_speed:GetTexture() return "buffs/blast_speed" end
function modifier_skeleton_king_hellfire_blast_custom_speed:GetEffectName()
 return "particles/wk_haste.vpcf" end

function modifier_skeleton_king_hellfire_blast_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_skeleton_king_hellfire_blast_custom_speed:GetModifierAttackSpeedBonus_Constant()
return
self:GetAbility().speed_attack_init + self:GetAbility().speed_attack_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_blast_2")
end

function modifier_skeleton_king_hellfire_blast_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return
self:GetAbility().speed_move_init + self:GetAbility().speed_move_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_blast_2")
end



modifier_skeleton_king_hellfire_blast_custom_illusion = class({})
function modifier_skeleton_king_hellfire_blast_custom_illusion:IsHidden() return true end
function modifier_skeleton_king_hellfire_blast_custom_illusion:IsPurgable() return false end

function modifier_skeleton_king_hellfire_blast_custom_illusion:GetStatusEffectName()
    return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end
function modifier_skeleton_king_hellfire_blast_custom_illusion:StatusEffectPriority()
 return 99999 end

function modifier_skeleton_king_hellfire_blast_custom_illusion:CheckState()
return
{
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end

function modifier_skeleton_king_hellfire_blast_custom_illusion:OnCreated(table)
if not IsServer() then return end
self.target = EntIndexToHScript(table.target)
end

function modifier_skeleton_king_hellfire_blast_custom_illusion:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    MODIFIER_PROPERTY_MODEL_SCALE,
    MODIFIER_EVENT_ON_TAKEDAMAGE
}
end
function modifier_skeleton_king_hellfire_blast_custom_illusion:GetOverrideAnimation()
return ACT_DOTA_DISABLED
end


function modifier_skeleton_king_hellfire_blast_custom_illusion:GetModifierModelScale() 
return 20 
end

function modifier_skeleton_king_hellfire_blast_custom_illusion:OnTakeDamage(params)
if not IsServer() then return end
if not self.target then return end
if self.target:IsNull() then return end
if not self.target:IsAlive() then return end
if self:GetParent() ~= params.unit then return end
if params.original_damage < 0 then return end

local damage = {
    victim = self.target,
    attacker = params.attacker,
    damage = params.original_damage*self:GetAbility().legendary_damage,
    damage_type = params.damage_type,
    damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
    ability = self:GetAbility()
}
ApplyDamage( damage )


end


modifier_skeleton_king_hellfire_blast_healing = class({})
function modifier_skeleton_king_hellfire_blast_healing:IsHidden() return false end
function modifier_skeleton_king_hellfire_blast_healing:IsPurgable() return false end
function modifier_skeleton_king_hellfire_blast_healing:GetTexture() return "buffs/blast_heal" end
function modifier_skeleton_king_hellfire_blast_healing:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
    }
 end

function modifier_skeleton_king_hellfire_blast_healing:GetModifierLifestealRegenAmplify_Percentage() return self:GetAbility().healing_heal end
function modifier_skeleton_king_hellfire_blast_healing:GetModifierHealAmplify_PercentageTarget() return self:GetAbility().healing_heal end
function modifier_skeleton_king_hellfire_blast_healing:GetModifierHPRegenAmplify_Percentage() return self:GetAbility().healing_heal end
function modifier_skeleton_king_hellfire_blast_healing:GetModifierTotalDamageOutgoing_Percentage() return self:GetAbility().healing_damage end
function modifier_skeleton_king_hellfire_blast_healing:GetEffectName()
    return "particles/items4_fx/spirit_vessel_damage.vpcf"
end

function modifier_skeleton_king_hellfire_blast_healing:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end