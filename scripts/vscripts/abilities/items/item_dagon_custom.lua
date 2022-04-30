LinkLuaModifier("modifier_item_dagon_custom", "abilities/items/item_dagon_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_dagon_custom_break", "abilities/items/item_dagon_custom", LUA_MODIFIER_MOTION_NONE)

item_dagon_custom = class({})
item_dagon_2_custom = class({})
item_dagon_3_custom = class({})
item_dagon_4_custom = class({})
item_dagon_5_custom = class({})

function item_dagon_custom:GetIntrinsicModifierName() return "modifier_item_dagon_custom" end
function item_dagon_2_custom:GetIntrinsicModifierName() return "modifier_item_dagon_custom" end
function item_dagon_3_custom:GetIntrinsicModifierName() return "modifier_item_dagon_custom" end
function item_dagon_4_custom:GetIntrinsicModifierName() return "modifier_item_dagon_custom" end
function item_dagon_5_custom:GetIntrinsicModifierName() return "modifier_item_dagon_custom" end

function item_dagon_custom:GetAOERadius()
    return self:GetSpecialValueFor("aoe_radius")
end

function item_dagon_2_custom:GetAOERadius()
    return self:GetSpecialValueFor("aoe_radius")
end

function item_dagon_3_custom:GetAOERadius()
    return self:GetSpecialValueFor("aoe_radius")
end

function item_dagon_4_custom:GetAOERadius()
    return self:GetSpecialValueFor("aoe_radius")
end

function item_dagon_5_custom:GetAOERadius()
    return self:GetSpecialValueFor("aoe_radius")
end

function item_dagon_custom:OnSpellStart()
    if not IsServer() then return end
    local point = self:GetCursorTarget():GetAbsOrigin()


    self:GetCursorTarget():EmitSound("DOTA_Item.Dagon"..self:GetLevel()..".Target")

    if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end


    local radius = self:GetSpecialValueFor("aoe_radius")
    local damage = self:GetSpecialValueFor("damage")
    self:GetCaster():EmitSound("DOTA_Item.Dagon.Activate")
    local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
    for _, enemy in pairs(enemies) do

            local dagon_pfx = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf", PATTACH_RENDERORIGIN_FOLLOW, self:GetCaster())
            ParticleManager:SetParticleControlEnt(dagon_pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(dagon_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false)
            ParticleManager:SetParticleControl(dagon_pfx, 2, Vector(damage, 0, 0))
            ParticleManager:SetParticleControl(dagon_pfx, 3, Vector(0.3, 0, 0))
            ParticleManager:ReleaseParticleIndex(dagon_pfx)
            ApplyDamage({ attacker = self:GetCaster(), victim = enemy, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
            
            if enemy:IsIllusion() then
                enemy:Kill(self, self:GetCaster())
            end

    end
end

function item_dagon_2_custom:OnSpellStart()
    if not IsServer() then return end
    local point = self:GetCursorTarget():GetAbsOrigin()

    self:GetCursorTarget():EmitSound("DOTA_Item.Dagon"..self:GetLevel()..".Target")

    if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end
    local radius = self:GetSpecialValueFor("aoe_radius")
    local damage = self:GetSpecialValueFor("damage")
    self:GetCaster():EmitSound("DOTA_Item.Dagon.Activate")
    local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
    for _, enemy in pairs(enemies) do
            local dagon_pfx = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf", PATTACH_RENDERORIGIN_FOLLOW, self:GetCaster())
            ParticleManager:SetParticleControlEnt(dagon_pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(dagon_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false)
            ParticleManager:SetParticleControl(dagon_pfx, 2, Vector(damage, 0, 0))
            ParticleManager:SetParticleControl(dagon_pfx, 3, Vector(0.3, 0, 0))
            ParticleManager:ReleaseParticleIndex(dagon_pfx)
            ApplyDamage({ attacker = self:GetCaster(), victim = enemy, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
            if enemy:IsIllusion() then
                enemy:Kill(self, self:GetCaster())
            end

    end
end

function item_dagon_3_custom:OnSpellStart()
    if not IsServer() then return end
    local point = self:GetCursorTarget():GetAbsOrigin()

    self:GetCursorTarget():EmitSound("DOTA_Item.Dagon"..self:GetLevel()..".Target")

    if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end
    local radius = self:GetSpecialValueFor("aoe_radius")
    local damage = self:GetSpecialValueFor("damage")
    self:GetCaster():EmitSound("DOTA_Item.Dagon.Activate")
    local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
    for _, enemy in pairs(enemies) do
      
            local dagon_pfx = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf", PATTACH_RENDERORIGIN_FOLLOW, self:GetCaster())
            ParticleManager:SetParticleControlEnt(dagon_pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(dagon_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false)
            ParticleManager:SetParticleControl(dagon_pfx, 2, Vector(damage, 0, 0))
            ParticleManager:SetParticleControl(dagon_pfx, 3, Vector(0.3, 0, 0))
            ParticleManager:ReleaseParticleIndex(dagon_pfx)
            ApplyDamage({ attacker = self:GetCaster(), victim = enemy, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })

            if enemy:IsIllusion() then
                enemy:Kill(self, self:GetCaster())
            end
    end
end

function item_dagon_4_custom:OnSpellStart()
    if not IsServer() then return end
    local point = self:GetCursorTarget():GetAbsOrigin()

    self:GetCursorTarget():EmitSound("DOTA_Item.Dagon"..self:GetLevel()..".Target")

    if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end

    local radius = self:GetSpecialValueFor("aoe_radius")
    local damage = self:GetSpecialValueFor("damage")
    self:GetCaster():EmitSound("DOTA_Item.Dagon.Activate")
    local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
    for _, enemy in pairs(enemies) do

            local dagon_pfx = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf", PATTACH_RENDERORIGIN_FOLLOW, self:GetCaster())
            ParticleManager:SetParticleControlEnt(dagon_pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(dagon_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false)
            ParticleManager:SetParticleControl(dagon_pfx, 2, Vector(damage, 0, 0))
            ParticleManager:SetParticleControl(dagon_pfx, 3, Vector(0.3, 0, 0))
            ParticleManager:ReleaseParticleIndex(dagon_pfx)
            ApplyDamage({ attacker = self:GetCaster(), victim = enemy, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })

            if enemy:IsIllusion() then
                enemy:Kill(self, self:GetCaster())
            end
    end
end

function item_dagon_5_custom:OnSpellStart()
    if not IsServer() then return end
    local point = self:GetCursorTarget():GetAbsOrigin()

    self:GetCursorTarget():EmitSound("DOTA_Item.Dagon"..self:GetLevel()..".Target")

    if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end
    local radius = self:GetSpecialValueFor("aoe_radius")
    local damage = self:GetSpecialValueFor("damage")
    self:GetCaster():EmitSound("DOTA_Item.Dagon.Activate")
    local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
    for _, enemy in pairs(enemies) do
            local dagon_pfx = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf", PATTACH_RENDERORIGIN_FOLLOW, self:GetCaster())
            ParticleManager:SetParticleControlEnt(dagon_pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(dagon_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false)
            ParticleManager:SetParticleControl(dagon_pfx, 2, Vector(damage, 0, 0))
            ParticleManager:SetParticleControl(dagon_pfx, 3, Vector(0.3, 0, 0))
            ParticleManager:ReleaseParticleIndex(dagon_pfx)
                
            enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_dagon_custom_break", {duration = (1 - enemy:GetStatusResistance())*self:GetSpecialValueFor("duration")})
            ApplyDamage({ attacker = self:GetCaster(), victim = enemy, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })

            if enemy:IsIllusion() then
                enemy:Kill(self, self:GetCaster())

            end
    end
end

modifier_item_dagon_custom = class({})

function modifier_item_dagon_custom:IsHidden() return true end
function modifier_item_dagon_custom:IsPurgable() return false end
function modifier_item_dagon_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE  end

function modifier_item_dagon_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_item_dagon_custom:GetModifierBonusStats_Strength() 
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_str") end 
end

function modifier_item_dagon_custom:GetModifierBonusStats_Agility()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_agi") end 
end

function modifier_item_dagon_custom:GetModifierBonusStats_Intellect()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_int") end 
end


modifier_item_dagon_custom_break = class({})
function modifier_item_dagon_custom_break:IsHidden() return false end
function modifier_item_dagon_custom_break:IsPurgable() return false end
function modifier_item_dagon_custom_break:CheckState() return {[MODIFIER_STATE_PASSIVES_DISABLED] = true} end
function modifier_item_dagon_custom_break:GetEffectName() return "particles/items3_fx/silver_edge.vpcf" end
function modifier_item_dagon_custom_break:OnCreated(table)
if not IsServer() then return end
  self.particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_break.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)
end
