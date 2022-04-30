LinkLuaModifier("modifier_item_statis_trap", "abilities/items/item_trap_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_statis_trap_root", "abilities/items/item_trap_custom", LUA_MODIFIER_MOTION_NONE)

item_trap_custom = class({})

function item_trap_custom:GetAOERadius()
	return 400
end

function item_trap_custom:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	local particle_cast = "particles/units/heroes/hero_techies/techies_stasis_trap_plant.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target_point)
	ParticleManager:SetParticleControl(particle_cast_fx, 1, target_point)
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	return true
end

function item_trap_custom:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local target_point = self:GetCursorPosition()
	caster:EmitSound("Hero_Techies.StasisTrap.Plant")
	local trap = CreateUnitByName("npc_dota_techies_stasis_trap", target_point, true, caster, caster, caster:GetTeamNumber())
	trap:SetOwner(caster)
	trap:AddNewModifier(self:GetCaster(), self, "modifier_item_statis_trap", {radius = self:GetSpecialValueFor("radius"), root = self:GetSpecialValueFor("root")})
	trap:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})
	self:SpendCharge()
end

modifier_item_statis_trap = class({})

function modifier_item_statis_trap:IsHidden() return true end
function modifier_item_statis_trap:IsPurgable() return false end
function modifier_item_statis_trap:IsDebuff() return false end

function modifier_item_statis_trap:CheckState()
	return {
			[MODIFIER_STATE_INVISIBLE] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_ROOTED] = true}
end

function modifier_item_statis_trap:OnCreated(table)
	if not IsServer() then return end
	self.radius = table.radius
	self.stun_duration = table.root
	self.active = true
	self:StartIntervalThink(FrameTime())
end

function modifier_item_statis_trap:OnIntervalThink()
    if not IsServer() then return end

    if self.active == false then return end

    local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false )
    if #enemies > 0 then
        self.active = false

        Timers:CreateTimer(0.3, function()

            if self and self:GetParent() and not self:GetParent():IsNull() and self:GetParent():IsAlive() then 

                local new_enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false )
                for _, enemy in pairs(new_enemies) do
                    local duration = self.stun_duration

                    local particle_unit = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_stasis_trap_beams.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
                    ParticleManager:SetParticleControl(particle_unit, 0, enemy:GetAbsOrigin())
                    ParticleManager:SetParticleControl(particle_unit, 1, self:GetParent():GetAbsOrigin())
                    enemy:AddNewModifier(self:GetCaster(), nil, "modifier_item_statis_trap_root", {duration = duration})
                end
                self:GetParent():EmitSound("Hero_Techies.StasisTrap.Stun")
                local particle_explode_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf", PATTACH_WORLDORIGIN, nil)
                ParticleManager:SetParticleControl(particle_explode_fx, 0, self:GetParent():GetAbsOrigin())
                ParticleManager:SetParticleControl(particle_explode_fx, 1, Vector(self.radius, 1, 1))
                ParticleManager:SetParticleControl(particle_explode_fx, 3, self:GetParent():GetAbsOrigin())
                ParticleManager:ReleaseParticleIndex(particle_explode_fx)
                UTIL_Remove(self:GetParent())
            end
        end)

        
    end
end

modifier_item_statis_trap_root = class({})

function modifier_item_statis_trap_root:GetTexture()
	return "techies_stasis_trap" 
end

function modifier_item_statis_trap_root:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true}
	return state
end

function modifier_item_statis_trap_root:IsHidden() return false end
function modifier_item_statis_trap_root:IsPurgable() return true end

function modifier_item_statis_trap_root:GetStatusEffectName()
	return "particles/status_fx/status_effect_techies_stasis.vpcf"
end