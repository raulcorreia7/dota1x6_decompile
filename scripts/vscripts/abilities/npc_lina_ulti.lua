LinkLuaModifier("modifier_lina_ulti_aura", "abilities/npc_lina_ulti.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_ulti", "abilities/npc_lina_ulti.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_ulti_cd", "abilities/npc_lina_ulti.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_thinker", "abilities/npc_lina_fiery.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_aura", "abilities/npc_lina_fiery", LUA_MODIFIER_MOTION_NONE)

npc_lina_ulti = class({})



function npc_lina_ulti:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_ulti_cd", {duration = self:GetCooldownTimeRemaining()})
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_ulti", {target = self:GetCursorTarget():entindex()})
end

function npc_lina_ulti:GetChannelTime() return self:GetSpecialValueFor("duration") end
 

function npc_lina_ulti:OnChannelFinish(bInterrupted)

self:GetCaster():RemoveModifierByName("modifier_lina_ulti")

end 

modifier_lina_ulti = class ({})

function modifier_lina_ulti:IsHidden() return true end
function modifier_lina_ulti:IsPurgable() return false end


function modifier_lina_ulti:OnCreated(table)

    self.sign = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_has_quest.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())

if not IsServer() then return end
    self.delay = self:GetAbility():GetSpecialValueFor("delay")

    self.target = EntIndexToHScript(table.target)

    self:StartIntervalThink(self.delay)
    self:OnIntervalThink()
end

function modifier_lina_ulti:OnDestroy()

    ParticleManager:DestroyParticle(self.sign, true)

end


function modifier_lina_ulti:OnIntervalThink()
    if not IsServer() then return end

    self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_CAST_ABILITY_4, 1)
    local position = self.target:GetAbsOrigin() + self.target:GetForwardVector()*100

    if (self:GetCaster():GetAbsOrigin() - position):Length2D() <= self:GetAbility():GetSpecialValueFor("range") then 
        CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_lina_ulti_aura", {duration = self.delay}, position, self:GetCaster():GetTeamNumber(), false)
    end
end

modifier_lina_ulti_aura = class ({})



function modifier_lina_ulti_aura:IsHidden() return false end

function modifier_lina_ulti_aura:IsPurgable() return false end

function modifier_lina_ulti_aura:OnCreated(table)
if not IsServer() then return end
  self.radius = self:GetAbility():GetSpecialValueFor("radius")

  local particle_cast = "particles/lina_warning.vpcf"

  self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent())
  ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius) )
  ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )


end

function modifier_lina_ulti_aura:OnDestroy(table)
if not IsServer() then return end
  
  ParticleManager:DestroyParticle( self.effect_cast, true )
  ParticleManager:ReleaseParticleIndex( self.effect_cast )

    self:GetCaster():EmitSound("Ability.LagunaBladeImpact")

    local blade_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControlEnt(blade_pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
    ParticleManager:SetParticleControl( blade_pfx,1, self:GetParent():GetOrigin() )
    ParticleManager:ReleaseParticleIndex(blade_pfx)

  local  enemy_for_ability = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES , FIND_CLOSEST, false)
   for _,i in ipairs(enemy_for_ability) do
      local damageTable = {victim = i,  damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_PURE, attacker = self:GetCaster(), ability = self:GetAbility()}
      local actualy_damage = ApplyDamage(damageTable)
    end


local ability = self:GetAbility():GetCaster():FindAbilityByName("npc_lina_fiery")  


if ability then 
    local duration = ability:GetSpecialValueFor("duration") 
    CreateModifierThinker(self:GetAbility():GetCaster(), ability, "modifier_lina_fiery_thinker", {duration = duration}, self:GetParent():GetAbsOrigin(), self:GetParent():GetTeamNumber(), false)
end 



end





modifier_lina_ulti_cd = class({})

function modifier_lina_ulti_cd:IsHidden() return false end
function modifier_lina_ulti_cd:IsPurgable() return false end