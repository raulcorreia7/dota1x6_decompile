LinkLuaModifier("modifier_item_roshan_meteor_burn", "abilities/items/item_roshan_meteor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_roshan_meteor_stats", "abilities/items/item_roshan_meteor", LUA_MODIFIER_MOTION_NONE)


item_roshan_meteor                 = class({})
modifier_item_roshan_meteor_burn   = class({})


function item_roshan_meteor:GetIntrinsicModifierName()
return "modifier_item_roshan_meteor_stats"
end

function item_roshan_meteor:GetAOERadius()
    return 300
end

function item_roshan_meteor:GetAbilityTextureName()
return "item_roshan_meteor"
end

function item_roshan_meteor:GetChannelTime() return 2.5 end
 

function item_roshan_meteor:OnSpellStart()
    self.caster     = self:GetCaster()
    

    self.burn_duration              =   self:GetSpecialValueFor("burn_duration")
    self.burn_interval              =   self:GetSpecialValueFor("burn_interval")
    self.land_time                  =   self:GetSpecialValueFor("land_time")
    self.impact_radius              =   self:GetSpecialValueFor("impact_radius")

    if not IsServer() then return end

    local position  = self:GetCursorPosition()
    
    -- Play the channel sound
    self.caster:EmitSound("DOTA_Item.MeteorHammer.Channel")

    AddFOWViewer(self.caster:GetTeam(), position, self.impact_radius, 3.8, false)

    -- Impact location particles
    self.particle   = ParticleManager:CreateParticle("particles/roshan_meteor_.vpcf", PATTACH_WORLDORIGIN, self.caster)
    ParticleManager:SetParticleControl(self.particle, 0, position)
    ParticleManager:SetParticleControl(self.particle, 1, Vector(self.impact_radius, 1, 1))
    
    self.particle2  = ParticleManager:CreateParticle("particles/roshan_meteor_cast_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)

    self.caster:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
end

function item_roshan_meteor:OnChannelFinish(bInterrupted)
    if not IsServer() then return end

    self.position = self:GetCursorPosition()

    self.caster:FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)

    if bInterrupted then
        self.caster:StopSound("DOTA_Item.MeteorHammer.Channel")
    
        ParticleManager:DestroyParticle(self.particle, true)
        ParticleManager:DestroyParticle(self.particle2, true)
    else
        self.caster:EmitSound("DOTA_Item.MeteorHammer.Cast")
    
        self.particle3  = ParticleManager:CreateParticle("particles/roshan_meteor_spell_.vpcf", PATTACH_WORLDORIGIN, self.caster)
        ParticleManager:SetParticleControl(self.particle3, 0, self.position + Vector(0, 0, 1000)) -- 1000 feels kinda arbitrary but it also feels correct
        ParticleManager:SetParticleControl(self.particle3, 1, self.position)
        ParticleManager:SetParticleControl(self.particle3, 2, Vector(self.land_time, 0, 0))
        ParticleManager:ReleaseParticleIndex(self.particle3)
        
        Timers:CreateTimer(self.land_time, function()
            if not self:IsNull() then
                GridNav:DestroyTreesAroundPoint(self.position, self.impact_radius, true)
            
                EmitSoundOnLocationWithCaster(self.position, "DOTA_Item.MeteorHammer.Impact", self.caster)
            
                local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.position, nil, self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                
                for _, enemy in pairs(enemies) do
                    enemy:EmitSound("DOTA_Item.MeteorHammer.Damage")
                
                    enemy:AddNewModifier(self.caster, self, "modifier_item_roshan_meteor_burn", {duration = self.burn_duration})
                    enemy:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun")*(1 - enemy:GetStatusResistance())})
                                    
                    ApplyDamage(damageTable)
                end
            end
        end)
    end
    
    ParticleManager:ReleaseParticleIndex(self.particle)
    ParticleManager:ReleaseParticleIndex(self.particle2)
end





function modifier_item_roshan_meteor_burn:GetEffectName()
    return "particles/roshan_meteor_burn_.vpcf"
end

function modifier_item_roshan_meteor_burn:IgnoreTenacity()
    return true
end


function modifier_item_roshan_meteor_burn:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

    self.ability    = self:GetAbility()
    self.caster     = self:GetCaster()
    self.parent     = self:GetParent()
    
    if self.ability == nil then return end
    
    self.init_damage = 0
    self.inc_damage = 0

    local damage = 0

    if self:GetParent():IsBuilding() then 
        self.init_damage = (self:GetAbility():GetSpecialValueFor("damage")/(self:GetAbility():GetSpecialValueFor("burn_duration") + 1))/100
        damage = self.init_damage*(self:GetParent():GetMaxHealth())

        self.inc_damage = self.init_damage
    else
        self.init_damage = self:GetAbility():GetSpecialValueFor("damage_units_init")
        damage = self.init_damage

        self.inc_damage = self:GetAbility():GetSpecialValueFor("damage_units_inc")
    end


    self.burn_interval              =   self:GetAbility():GetSpecialValueFor("burn_interval")
    
    if not IsServer() then return end


if self:GetParent():IsBuilding() then 


    damage_table = {
    victim          = self.parent,
    damage          = damage,
    damage_type     = DAMAGE_TYPE_PURE,
    damage_flags    = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
    attacker        = self.caster,
    ability         = self.ability
    }

else 

    damage_table = {
    victim          = self.parent,
    damage          = damage,
    damage_type     = DAMAGE_TYPE_MAGICAL,
    damage_flags    = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
    attacker        = self.caster,
    ability         = self.ability
    }
                
end
    ApplyDamage(damage_table)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self.parent, damage, nil)
    

    self:StartIntervalThink(self.burn_interval)
end

function modifier_item_roshan_meteor_burn:OnIntervalThink()
if not IsServer() then return end

local damage_table = {}
local damage = 0

if self:GetParent():IsBuilding() then 

    damage = self.inc_damage*self:GetParent():GetMaxHealth()

    damage_table = {
    victim          = self.parent,
    damage          = damage,
    damage_type     = DAMAGE_TYPE_PURE,
    damage_flags    = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
    attacker        = self.caster,
    ability         = self.ability
    }

else 
    damage = self.inc_damage

    damage_table = {
    victim          = self.parent,
    damage          = damage,
    damage_type     = DAMAGE_TYPE_MAGICAL,
    damage_flags    = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
    attacker        = self.caster,
    ability         = self.ability
    }
                
end

ApplyDamage(damage_table)
SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self.parent, damage, nil)
    

end



modifier_item_roshan_meteor_stats = class({})
function modifier_item_roshan_meteor_stats:IsHidden() return true end
function modifier_item_roshan_meteor_stats:IsPurgable() return false end
function modifier_item_roshan_meteor_stats:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}

end

function modifier_item_roshan_meteor_stats:GetModifierBonusStats_Agility () return self:GetAbility():GetSpecialValueFor("stats") end
function modifier_item_roshan_meteor_stats:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("stats") end
function modifier_item_roshan_meteor_stats:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("stats") end
function modifier_item_roshan_meteor_stats:GetModifierConstantHealthRegen() return self:GetAbility():GetSpecialValueFor("health_regen") end
function modifier_item_roshan_meteor_stats:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("mana_regen") end

function modifier_item_roshan_meteor_stats:GetModifierTotalDamageOutgoing_Percentage( params ) 
    if params.attacker == self:GetParent() then 
    if params.target then 
if params.target:IsBuilding() then 
    return self:GetAbility():GetSpecialValueFor("building_damage")
    end 
end
end
end