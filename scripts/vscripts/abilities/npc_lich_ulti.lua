LinkLuaModifier("modifier_lich_ulti_cd", "abilities/npc_lich_ulti", LUA_MODIFIER_MOTION_NONE)

npc_lich_ulti = class({})

function npc_lich_ulti:OnAbilityPhaseStart()
    self.sign = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_has_quest.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
       return true
end 

function npc_lich_ulti:New_Hit( target , source )
if not IsServer() then return end
    local projectile_name = "particles/units/heroes/hero_lich/lich_chain_frost.vpcf"
    local projectile_speed = self:GetSpecialValueFor("projectile")
    local projectile_vision = 450

        local info = {
       Target = target,
       Source = source,
       Ability = self, 
      EffectName = projectile_name,
      iMoveSpeed = projectile_speed,
      bReplaceExisting = false,                         
      bProvidesVision = true,                           
      iVisionRadius = projectile_vision,        
      iVisionTeamNumber = self:GetCaster():GetTeamNumber()        
        }
 ProjectileManager:CreateTrackingProjectile(info)


end



function npc_lich_ulti:OnSpellStart()
if not IsServer() then return end
    ParticleManager:DestroyParticle(self.sign, true)

    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lich_ulti_cd", {duration = self:GetCooldownTimeRemaining()})

    local point = self:GetCursorTarget()

    self:GetCaster():EmitSound("Hero_Lich.ChainFrost")

    self:New_Hit(point, self:GetCaster())
    
end

function npc_lich_ulti:OnAbilityPhaseInterrupted()
    ParticleManager:DestroyParticle(self.sign, true)
end

function npc_lich_ulti:OnProjectileHit(hTarget, vLocation)
if not IsServer() then return end
if hTarget  then

    local radius = self:GetSpecialValueFor("radius")

    local enemy_for_ability = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), hTarget:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE , FIND_CLOSEST, false)

    local target = {}
    local j = 0

    for _,i in ipairs(enemy_for_ability) do 
        if (i:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() or i:GetUnitName() == "npc_lich_ice_unit") and
        (not i:IsBuilding()) and (i ~= hTarget) then 
            j = j + 1
            target[j] = i
        end
    end

    if j > 0 then 
        local t = target[RandomInt(1, #target)]
        self:New_Hit(t , hTarget)
    end

    self:GetCaster():EmitSound("Hero_Lich.ChainFrostImpact.Hero")

    if hTarget:TriggerSpellAbsorb(self)  then return end

        local damage = self:GetSpecialValueFor("damage")

        ApplyDamage({ victim = hTarget, attacker = self:GetCaster(), ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})



end
return true
end




modifier_lich_ulti_cd = class({})

function modifier_lich_ulti_cd:IsHidden() return false end
function modifier_lich_ulti_cd:IsPurgable() return false end