LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skelet_reincarnation", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_slow", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_legendary", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_wraith_king_skeleton_ghost_slow_mod", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_wraith_king_skeleton_ghost_slow", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_path", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_attack", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_attack_buf", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )



skeleton_king_vampiric_aura_custom = class({})

skeleton_king_vampiric_aura_custom.delay_reincarnation = 3

skeleton_king_vampiric_aura_custom.heal_init = 0.05
skeleton_king_vampiric_aura_custom.heal_inc = 0.05

skeleton_king_vampiric_aura_custom.blast_init = 50
skeleton_king_vampiric_aura_custom.blast_inc = 50
skeleton_king_vampiric_aura_custom.blast_slow_init = -20
skeleton_king_vampiric_aura_custom.blast_slow_inc = -20
skeleton_king_vampiric_aura_custom.blast_duration = 2 
skeleton_king_vampiric_aura_custom.blast_radius = 300

skeleton_king_vampiric_aura_custom.legendary_health = 8
skeleton_king_vampiric_aura_custom.legendary_damage = 0.6

skeleton_king_vampiric_aura_custom.bonus_speed_init = 15
skeleton_king_vampiric_aura_custom.bonus_speed_inc = 15
skeleton_king_vampiric_aura_custom.bonus_armor_init = 0
skeleton_king_vampiric_aura_custom.bonus_armor_inc = 2

skeleton_king_vampiric_aura_custom.death_heal = 0.06

skeleton_king_vampiric_aura_custom.ghost_count = 4

skeleton_king_vampiric_aura_custom.rage_speed_init = 0
skeleton_king_vampiric_aura_custom.rage_speed_inc = 40
skeleton_king_vampiric_aura_custom.rage_move_init = 0
skeleton_king_vampiric_aura_custom.rage_move_inc = 20
skeleton_king_vampiric_aura_custom.rage_attack_buf = 6
skeleton_king_vampiric_aura_custom.rage_attack_max = 6
skeleton_king_vampiric_aura_custom.rage_attack_duration = 10


wraith_king_skeleton_ghost_slow = class({})

wraith_king_skeleton_ghost_slow.ghost_slow = -25
wraith_king_skeleton_ghost_slow.ghost_duration = 2
wraith_king_skeleton_ghost_slow.ghost_mana = 0.02


function wraith_king_skeleton_ghost_slow:GetIntrinsicModifierName()
return "modifier_wraith_king_skeleton_ghost_slow"
end



function skeleton_king_vampiric_aura_custom:GetIntrinsicModifierName()
	return "modifier_skeleton_king_vampiric_aura_custom"
end

function skeleton_king_vampiric_aura_custom:OnAbilityPhaseStart()
    local mod = self:GetCaster():FindModifierByName("modifier_skeleton_king_vampiric_aura_custom")
    if mod then
        if mod:GetStackCount() <= 0 then
            local player = PlayerResource:GetPlayer( self:GetCaster():GetPlayerID() )
            CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#dota_hud_error_no_charges"})
            return false
        end
    end
    return true
end

function skeleton_king_vampiric_aura_custom:OnSpellStart()
	if not IsServer() then return end
	local modifier = self:GetCaster():FindModifierByName("modifier_skeleton_king_vampiric_aura_custom")
	if modifier == nil then return end
	local charges = modifier:GetStackCount()
	local delay = self:GetSpecialValueFor("spawn_interval")


	self:GetCaster():EmitSound("Hero_SkeletonKing.MortalStrike.Cast")


	if self:GetCaster():HasModifier("modifier_skeleton_vampiric_legendary")  then 
		delay = 0

		local mod = self:GetCaster():FindModifierByName("modifier_skeleton_king_vampiric_aura_legendary")
		if not mod then 
			mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_vampiric_aura_legendary", {})
		end

		if mod then 
			mod:SetStackCount(mod:GetStackCount() + charges)
		end

	end

	local count = 0
	local name = 1

	for i=0,charges - 1 do

		if self:GetCaster():HasModifier("modifier_skeleton_vampiric_5") then 
			count = count + 1
			if count == self.ghost_count then 
				count = 0

				name = 2
			end
		end

		if name == 1 then 
			Timers:CreateTimer(delay * i, function ()
				self:CreateSkeleton(self:GetCaster():GetOrigin()+RandomVector(300), nil, nil, true, "npc_dota_wraith_king_skeleton_warrior_custom")
			end)
		else 
			Timers:CreateTimer(delay * i, function ()
				self:CreateSkeleton(self:GetCaster():GetOrigin()+RandomVector(300), nil, nil, true, "npc_dota_wraith_king_skeleton_ghost_custom")
			end)

		end
		name = 1
	end
	if not self:GetCaster():HasModifier("modifier_final_duel") then 
		modifier:SetStackCount( 0 )
	else 
		self:SetActivated(false)
	end
end

function skeleton_king_vampiric_aura_custom:CreateSkeleton(origin, target, duration_custom, reincarnation, name_unit)
if not IsServer() then return end
if self:GetCaster() == nil or players[self:GetCaster():GetTeamNumber()] == nil then return end

	local name = ""
	if name_unit == nil then 
		name = "npc_dota_wraith_king_skeleton_warrior_custom"
	else 
		name = name_unit
	end

	local duration = self:GetSpecialValueFor("skeleton_duration")
	if duration_custom then
		duration = duration_custom
	end

	local skelet = CreateUnitByName( name, origin, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/neutral_fx/skeleton_spawn.vpcf", PATTACH_ABSORIGIN, skelet ) )
	skelet:SetOwner( self:GetCaster() )
	
	if self:GetCaster():HasModifier("modifier_skeleton_vampiric_legendary") then 
		skelet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	end
	
	skelet:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = duration})

	local target_enemy = nil
	if target then 
		target_enemy = target:entindex()
	end

	local modifier = skelet:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_vampiric_aura_custom_skeleton_ai", {target = target_enemy, duration = duration})
	if reincarnation then
		skelet:AddNewModifier(self:GetCaster(), self, "modifier_skelet_reincarnation", {})
	end
	skelet.owner = self:GetCaster()
	skelet.skelet = true

	skelet:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_vampiric_aura_custom_path", {duration = 2})

	skelet:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_vampiric_aura_custom", {})
	skelet:EmitSound("n_creep_Skeleton.Spawn")
	skelet:EmitSound("n_creep_TrollWarlord.RaiseDead")
	if not target then return end
	if not modifier then return end
	modifier.target = target
end

modifier_skeleton_king_vampiric_aura_custom = class({})

function modifier_skeleton_king_vampiric_aura_custom:IsHidden() return self:GetStackCount() == 0 end
function modifier_skeleton_king_vampiric_aura_custom:IsPurgable() return false end

function modifier_skeleton_king_vampiric_aura_custom:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_skeleton_king_vampiric_aura_custom:OnCreated(params)
	self:SetStackCount(0)
	self.creeps_killed = 0
	self.creeps_killed_to_charge = 2
end

function modifier_skeleton_king_vampiric_aura_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent() == params.unit then return end
if params.unit:IsBuilding() then return end


local bonus = 0
self.heal = self:GetAbility():GetSpecialValueFor("vampiric_aura") / 100


if self:GetCaster():HasModifier("modifier_skeleton_vampiric_1") then 
	bonus = self:GetAbility().heal_init + self:GetAbility().heal_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_vampiric_1")

	if params.inflictor ~= nil and not self:GetParent():IsIllusion() 
	and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then 

		local heal = bonus*params.damage
		self:GetParent():Heal(heal, self:GetAbility())
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )

	end	

	if self:GetParent().skelet and self:GetParent().skelet == true then 
		local heal = bonus*params.damage
		self:GetParent().owner:Heal(heal, self:GetAbility())
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent().owner )
		ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent().owner:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end


end

self.heal = self.heal + bonus

if params.inflictor == nil then 

	local heal = params.damage*self.heal


	self:GetParent():Heal(heal, self:GetAbility())
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

end 

function modifier_skeleton_king_vampiric_aura_custom:OnDeath(params)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end
if self:GetParent():GetTeamNumber() == params.unit:GetTeamNumber() then return end

local give_charge = false
local radius = self:GetAbility():GetSpecialValueFor("kill_radius")

if self:GetParent() == params.attacker then 
	give_charge = true 
end

if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() 
	and params.attacker.owner == self:GetParent() and (self:GetParent():GetAbsOrigin() - params.attacker:GetAbsOrigin()):Length2D() <= radius then 
	give_charge = true
end




if give_charge == false then return end


	local max = self:GetAbility():GetSpecialValueFor("max_skeleton_charges")



	if self:GetStackCount() >= max then return end

	self.creeps_killed = self.creeps_killed + 1
	if self.creeps_killed >= self.creeps_killed_to_charge then
		self.creeps_killed = 0
		self:IncrementStackCount()
	end
end 

modifier_skeleton_king_vampiric_aura_custom_skeleton_ai = class({})

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:RemoveOnDeath() return false end
function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:IsHidden() return true end
function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:IsPurgable() return false end

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:OnCreated(table)
if not IsServer() then return end


if self:GetCaster():HasModifier("modifier_skeleton_vampiric_legendary") then 

	local mod = self:GetCaster():FindModifierByName("modifier_skeleton_king_vampiric_aura_legendary")
	if mod then 
		local health = self:GetParent():GetMaxHealth() + mod:GetStackCount()*self:GetAbility().legendary_health
		local damage = self:GetParent():GetBaseDamageMax() + mod:GetStackCount()*self:GetAbility().legendary_damage
		self:GetParent():SetBaseMaxHealth(health)
  		self:GetParent():SetHealth(health)
  		self:GetParent():SetBaseDamageMin(damage)
 		self:GetParent():SetBaseDamageMax(damage)
	end

	if table.target ~= nil then 
		self:GetParent():SetForceAttackTarget(EntIndexToHScript(table.target))
	end

return 
end
	self:OnIntervalThink()
	self:StartIntervalThink(1)
end

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_START,
	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not self:GetCaster():HasModifier("modifier_skeleton_vampiric_4") then return end
if self:GetParent():HasModifier("modifier_skeleton_king_vampiric_aura_custom_attack_buf") then return end


self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_skeleton_king_vampiric_aura_custom_attack", {duration = self:GetAbility().rage_attack_duration})

end


function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:GetModifierAttackSpeedBonus_Constant()
local bonus = 0
if self:GetCaster():HasModifier("modifier_skeleton_vampiric_3") then 
	bonus = self:GetAbility().bonus_speed_init + self:GetAbility().bonus_speed_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_vampiric_3")
end

return bonus
end
function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:GetModifierTotalDamageOutgoing_Percentage( params ) 
if not IsServer() then return end
if params.attacker == self:GetParent() and params.inflictor == nil then 
	if params.target then 
		if params.target:IsBuilding() then 
			return -75
		end 
	end
end

end


function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:GetModifierPhysicalArmorBonus()
local bonus = 0
if self:GetCaster():HasModifier("modifier_skeleton_vampiric_3") then 
	bonus = self:GetAbility().bonus_armor_init + self:GetAbility().bonus_armor_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_vampiric_3")
end

return bonus
end


function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end

if self:GetCaster():HasModifier("modifier_skeleton_vampiric_6") then 
	local all_skeletons = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
    for _,skelet in pairs(all_skeletons) do 
    	if 	(skelet.skelet and skelet.skelet == true) or (self:GetParent().owner and skelet == self:GetParent().owner) then 
    		local heal = self:GetAbility().death_heal*skelet:GetMaxHealth()

    		skelet:Heal(heal, self:GetAbility())
    		skelet:EmitSound("WK.skelet_heal")
			local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", PATTACH_ABSORIGIN_FOLLOW, skelet )
			ParticleManager:SetParticleControl( effect_cast, 1, skelet:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( effect_cast )
			SendOverheadEventMessage(skelet, 10, skelet, heal, nil)
    	end
    end       

end




if not self:GetCaster():HasModifier("modifier_skeleton_vampiric_2") then return end

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetParent():EmitSound("WK.skelet_expolsion")

local damage = (self:GetAbility().blast_init + self:GetAbility().blast_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_vampiric_2"))

local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
for _,enemy in pairs(enemies) do 
	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_skeleton_king_vampiric_aura_slow", {duration = (1 - enemy:GetStatusResistance())*self:GetAbility().blast_duration})
    local damage = {
        victim = enemy,
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
    }
    ApplyDamage( damage )
end

end

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:OnAttackStart(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
self.target = params.target

end

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:OnIntervalThink()
    if not IsServer() then return end

    if self.target and not self.target:IsNull() and self.target:IsAlive() and self:GetParent():CanEntityBeSeenByMyTeam(self.target) and self:GetParent():GetForceAttackTarget() == nil then
        
        self:GetParent():SetForceAttackTarget(self.target)
        return
    end

    if self.target and ( self.target:IsNull() or not self.target:IsAlive() or not self:GetParent():CanEntityBeSeenByMyTeam(self.target)) then
        self:GetParent():SetForceAttackTarget(nil)
        self.target = nil
        self:GetParent():Stop()
        return
    end

    if self.target == nil or self:GetParent():GetForceAttackTarget() == nil then 

    	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 6500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
    	for _,enemy in pairs(enemies) do
       	 if enemy:GetUnitName() ~= "npc_teleport" then
            	self:GetParent():MoveToPositionAggressive(enemy:GetAbsOrigin())
            	break
        	end
   		 end
   	end

    if self:GetParent():GetAggroTarget() then
        self.target = self:GetParent():GetAggroTarget()
    end
end

modifier_skelet_reincarnation = class({})

function modifier_skelet_reincarnation:IsHidden()
    return true
end

function modifier_skelet_reincarnation:RemoveOnDeath()
    return true
end

function modifier_skelet_reincarnation:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
    }

    return funcs
end

function modifier_skelet_reincarnation:OnDeath( params )
    if not IsServer() then return end
    if params.attacker == nil then return end
    if params.unit ~= self:GetParent() then return end
    if params.attacker == self:GetParent() then return end
 	local point = self:GetParent():GetAbsOrigin()
  	local team = self:GetParent():GetTeamNumber()
  	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local duration = 0
	local modifier_kill = self:GetParent():FindModifierByName("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai")
	local delay_reincarnation = ability.delay_reincarnation

	if modifier_kill then
		duration = modifier_kill:GetRemainingTime()
	end
	local name = self:GetParent():GetUnitName()
	Timers:CreateTimer(ability.delay_reincarnation, function()
		if caster ~= nil and not caster:IsNull() and players[caster:GetTeamNumber()] ~= nil then 
			ability:CreateSkeleton(point, nil, duration, false, name)
		end
	end)
end

modifier_skeleton_king_vampiric_aura_slow = class({})
function modifier_skeleton_king_vampiric_aura_slow:IsHidden() return false end
function modifier_skeleton_king_vampiric_aura_slow:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_slow:GetTexture() return "buffs/vampiric_slow" end
function modifier_skeleton_king_vampiric_aura_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_skeleton_king_vampiric_aura_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().blast_slow_init + self:GetAbility().blast_slow_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_vampiric_2")
end


modifier_skeleton_king_vampiric_aura_legendary = class({})
function modifier_skeleton_king_vampiric_aura_legendary:IsHidden() return false end
function modifier_skeleton_king_vampiric_aura_legendary:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_legendary:RemoveOnDeath() return false end

function modifier_skeleton_king_vampiric_aura_legendary:GetTexture() return "buffs/skelet_buff" end
function modifier_skeleton_king_vampiric_aura_legendary:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(0)
end

function modifier_skeleton_king_vampiric_aura_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end

function modifier_skeleton_king_vampiric_aura_legendary:OnTooltip()
return self:GetStackCount()*self:GetAbility().legendary_damage
end
function modifier_skeleton_king_vampiric_aura_legendary:OnTooltip2()
return self:GetStackCount()*self:GetAbility().legendary_health
end




modifier_wraith_king_skeleton_ghost_slow = class({})
function modifier_wraith_king_skeleton_ghost_slow:IsHidden() return true end
function modifier_wraith_king_skeleton_ghost_slow:IsPurgable() return false end
function modifier_wraith_king_skeleton_ghost_slow:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_wraith_king_skeleton_ghost_slow:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsMagicImmune() or params.target:IsBuilding() then return end

params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_wraith_king_skeleton_ghost_slow_mod", {duration = self:GetAbility().ghost_duration})

local effect = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)

params.target:SpendMana(self:GetAbility().ghost_mana*params.target:GetMaxMana(), self:GetAbility())

end


modifier_wraith_king_skeleton_ghost_slow_mod = class({})
function modifier_wraith_king_skeleton_ghost_slow_mod:IsHidden() return false end
function modifier_wraith_king_skeleton_ghost_slow_mod:IsPurgable() return true end
function modifier_wraith_king_skeleton_ghost_slow_mod:GetStatusEffectName() return "particles/status_fx/status_effect_drow_frost_arrow.vpcf" end

function modifier_wraith_king_skeleton_ghost_slow_mod:OnCreated(table)
self.slow = self:GetAbility().ghost_slow
end
function modifier_wraith_king_skeleton_ghost_slow_mod:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end
function modifier_wraith_king_skeleton_ghost_slow_mod:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

modifier_skeleton_king_vampiric_aura_custom_path = class({})
function modifier_skeleton_king_vampiric_aura_custom_path:IsHidden() return true end
function modifier_skeleton_king_vampiric_aura_custom_path:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_custom_path:CheckState()
return
{
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
}
end


modifier_skeleton_king_vampiric_aura_custom_attack = class({})
function modifier_skeleton_king_vampiric_aura_custom_attack:IsHidden() return false end
function modifier_skeleton_king_vampiric_aura_custom_attack:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_custom_attack:GetTexture() return "buffs/vampiric_attack" end
function modifier_skeleton_king_vampiric_aura_custom_attack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_skeleton_king_vampiric_aura_custom_attack:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().rage_attack_max then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_skeleton_king_vampiric_aura_custom_attack_buf", {duration = self:GetAbility().rage_attack_buf})
	self:Destroy()
end

end

modifier_skeleton_king_vampiric_aura_custom_attack_buf = class({})
function modifier_skeleton_king_vampiric_aura_custom_attack_buf:IsHidden() return false end
function modifier_skeleton_king_vampiric_aura_custom_attack_buf:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_custom_attack_buf:GetTexture() return "buffs/vampiric_attack" end

function modifier_skeleton_king_vampiric_aura_custom_attack_buf:OnCreated(table)
if not IsServer() then return end

self:GetParent():EmitSound("Hero_OgreMagi.Bloodlust.Target")
self.effect_impact = ParticleManager:CreateParticle( "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff_hands_glow.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
ParticleManager:SetParticleControlEnt(self.effect_impact, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.effect_impact, false, false, -1, false, false)

end

function modifier_skeleton_king_vampiric_aura_custom_attack_buf:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_skeleton_king_vampiric_aura_custom_attack_buf:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().rage_speed_init + self:GetAbility().rage_speed_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_vampiric_4")
end

function modifier_skeleton_king_vampiric_aura_custom_attack_buf:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().rage_move_init + self:GetAbility().rage_move_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_vampiric_4")
end
function modifier_skeleton_king_vampiric_aura_custom_attack_buf:CheckState()
return
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end