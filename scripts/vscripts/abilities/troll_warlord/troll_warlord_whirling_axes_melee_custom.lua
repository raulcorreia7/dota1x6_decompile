LinkLuaModifier("modifier_troll_warlord_whirling_axes_melee_custom", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_melee_custom_thinker", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_attack", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_stack", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_tracker", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_heal", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_proc_cd", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_whirling_axes_proc_incoming", "abilities/troll_warlord/troll_warlord_whirling_axes_melee_custom", LUA_MODIFIER_MOTION_NONE)


troll_warlord_whirling_axes_melee_custom = class({})

troll_warlord_whirling_axes_melee_custom.damage_init = 20
troll_warlord_whirling_axes_melee_custom.damage_inc = 20

troll_warlord_whirling_axes_melee_custom.miss_init = 5
troll_warlord_whirling_axes_melee_custom.miss_inc = 5

troll_warlord_whirling_axes_melee_custom.attack_duration = 10
troll_warlord_whirling_axes_melee_custom.attack_max = 3
troll_warlord_whirling_axes_melee_custom.attack_damage_init = 20
troll_warlord_whirling_axes_melee_custom.attack_damage_inc = 20


troll_warlord_whirling_axes_melee_custom.heal = 0.1

troll_warlord_whirling_axes_melee_custom.proc_cd = 20
troll_warlord_whirling_axes_melee_custom.proc_silence = 2.5
troll_warlord_whirling_axes_melee_custom.proc_damage = 15
troll_warlord_whirling_axes_melee_custom.proc_damage_duration = 6

troll_warlord_whirling_axes_melee_custom.legendary_max = 5
troll_warlord_whirling_axes_melee_custom.legendary_duration = 10
troll_warlord_whirling_axes_melee_custom.legendary_damage = 0.15

troll_warlord_whirling_axes_melee_custom.scepter_manacost = 25

troll_warlord_whirling_axes_melee_custom.refresh_chance_init = 5
troll_warlord_whirling_axes_melee_custom.refresh_chance_inc = 15


function troll_warlord_whirling_axes_melee_custom:GetIntrinsicModifierName()
return "modifier_troll_warlord_whirling_axes_tracker"
end

function troll_warlord_whirling_axes_melee_custom:OnUpgrade()
	if self:GetCaster():HasModifier("modifier_troll_warlord_berserkers_rage_custom") then
		self:SetActivated(true)
	else
		if not self:GetCaster():HasModifier("modifier_troll_axes_legendary") then 
			self:SetActivated(false)
		end
	end
end

function troll_warlord_whirling_axes_melee_custom:GetCooldown(level)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_cooldown")
	end
    return self.BaseClass.GetCooldown( self, level )
end

function troll_warlord_whirling_axes_melee_custom:GetManaCost(level)
	if self:GetCaster():HasScepter() then
		return troll_warlord_whirling_axes_melee_custom.scepter_manacost
	end
    return self.BaseClass.GetManaCost(self, level)
end

function troll_warlord_whirling_axes_melee_custom:OnSpellStart()
	local caster = self:GetCaster()
	local caster_location = caster:GetAbsOrigin()

	caster:EmitSound("Hero_TrollWarlord.WhirlingAxes.Melee")
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)

	if caster:HasScepter() then
		caster:Purge(false, true, false, false, false)
	end

	if self:GetCaster():HasModifier("modifier_troll_axes_3") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_whirling_axes_attack", {duration = self.attack_duration})
	end



	local whirl_duration = self:GetSpecialValueFor("whirl_duration")

	local max = 1
	local more_damage = 0

	local particle = "particles/units/heroes/hero_troll_warlord/troll_warlord_whirling_axe_melee.vpcf"

	if false and self:GetCaster():HasModifier("modifier_troll_axes_6") and not self:GetCaster():HasModifier("modifier_troll_warlord_whirling_axes_proc_cd") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_whirling_axes_proc_cd", {duration = self.proc_cd})
		particle = "particles/econ/items/troll_warlord/troll_ti10_shoulder/troll_ti10_whirling_axe_melee.vpcf"
		more_damage = 1
	end


	Timers:CreateTimer(0.2, function()

	if self:GetCaster():HasModifier("modifier_troll_axes_4") then 

		local random = self.refresh_chance_init + self.refresh_chance_inc*self:GetCaster():GetUpgradeStack("modifier_troll_axes_4")
 
		if RollPseudoRandomPercentage(random, 534, self:GetCaster()) then


			self:GetCaster():EmitSound("Troll.Axed_cd")
			local particle = ParticleManager:CreateParticle("particles/sf_refresh_a.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
   			ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
   			ParticleManager:ReleaseParticleIndex(particle)

			local name = "troll_warlord_whirling_axes_melee_custom"
			local cd = self:GetCaster():FindAbilityByName(name):GetCooldownTimeRemaining()
			if cd > 0 then 
				self:GetCaster():FindAbilityByName(name):EndCooldown()
			end

			local name = "troll_warlord_whirling_axes_ranged_custom"
			local cd = self:GetCaster():FindAbilityByName(name):GetCooldownTimeRemaining()
			if cd > 0 then 

				self:GetCaster():FindAbilityByName(name):EndCooldown()
			end

		end

	end

	end)


	for i = 1,max do



		if self:GetCaster():HasModifier("modifier_troll_axes_5") then 
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_whirling_axes_heal", {duration = whirl_duration})
		end


		local angle_east = QAngle(0,90,0)
		local angle_west = QAngle(0,-90,0)
		if i == 2 then 
			angle_east = QAngle(0,0,0)
			angle_west = QAngle(0,180,0)
		end

		local start_radius = 100

		local forward_vector = caster:GetForwardVector()
		local front_position = caster_location + forward_vector * start_radius
		local position_east = RotatePosition(caster_location, angle_east, front_position) 
		local position_west = RotatePosition(caster_location, angle_west, front_position)

		position_east = GetGroundPosition( position_east, self:GetCaster() )
		position_west = GetGroundPosition( position_west, self:GetCaster() )
		position_east.z = position_east.z + 75
		position_west.z = position_west.z + 75


		local index = DoUniqueString("index")
		self[index] = {}

		self.whirling_axes_east = CreateUnitByName("npc_dota_troll_warlord_axe", position_east, false, caster, caster, caster:GetTeam() )
		self.whirling_axes_east:SetAbsOrigin(position_east)
		self.whirling_axes_east:AddNewModifier(caster, self, "modifier_troll_warlord_whirling_axes_melee_custom_thinker", {more_damage = more_damage, i = i, index = index, count = 1})

		self.whirling_axes_east.particle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.whirling_axes_east)
		ParticleManager:SetParticleControl(self.whirling_axes_east.particle, 0, self.whirling_axes_east:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.whirling_axes_east.particle, 1, self.whirling_axes_east:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.whirling_axes_east.particle, 4, Vector(whirl_duration,0,0))
		self.whirling_axes_east.axe_radius = start_radius
		self.whirling_axes_east.start_time = GameRules:GetGameTime()
		self.whirling_axes_east.side = 0

		self.whirling_axes_west = CreateUnitByName("npc_dota_troll_warlord_axe", position_west, false, caster, caster, caster:GetTeam() )
		self.whirling_axes_west:SetAbsOrigin(position_west)
		self.whirling_axes_west:AddNewModifier(caster, self, "modifier_troll_warlord_whirling_axes_melee_custom_thinker", {more_damage = more_damage, i = i, index = index, count = 2})
		self.whirling_axes_west.particle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.whirling_axes_west)
		ParticleManager:SetParticleControl(self.whirling_axes_west.particle, 0, self.whirling_axes_west:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.whirling_axes_west.particle, 1, self.whirling_axes_west:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.whirling_axes_west.particle, 4, Vector(whirl_duration,0,0))
		self.whirling_axes_west.axe_radius = start_radius
		self.whirling_axes_west.start_time = GameRules:GetGameTime()
		self.whirling_axes_west.side = 1

	end
end

modifier_troll_warlord_whirling_axes_melee_custom_thinker = class({})

function modifier_troll_warlord_whirling_axes_melee_custom_thinker:OnCreated(params)
	if not IsServer() then return end
	self.index = params.index
	self.more_damage = params.more_damage
	self:StartIntervalThink(FrameTime())
	self.i = params.i
end

function modifier_troll_warlord_whirling_axes_melee_custom_thinker:OnIntervalThink()
	if not IsServer() then return end
	local elapsed_time = GameRules:GetGameTime() - self:GetParent().start_time
	if not self:GetCaster():IsAlive() then self:GetParent():RemoveSelf() return end
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	local hit_radius = self:GetAbility():GetSpecialValueFor("hit_radius")
	local max_range = self:GetAbility():GetSpecialValueFor("max_range")
	local axe_movement_speed = self:GetAbility():GetSpecialValueFor("axe_movement_speed")
	local blind_duration = self:GetAbility():GetSpecialValueFor("blind_duration")
	local whirl_duration = self:GetAbility():GetSpecialValueFor("whirl_duration")
	local caster_location = self:GetCaster():GetAbsOrigin()
	local currentRadius	= self:GetParent().axe_radius 


	if self:GetCaster():HasModifier("modifier_troll_axes_1") then 
		damage = damage + self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetCaster():GetUpgradeStack("modifier_troll_axes_1")
	end



	local deltaRadius = axe_movement_speed / whirl_duration/2 * FrameTime()
	if elapsed_time >= whirl_duration * 0.65 then
		currentRadius = currentRadius - deltaRadius
	else
		currentRadius = currentRadius + deltaRadius
	end
	currentRadius = math.min( currentRadius, (max_range - hit_radius))
	self:GetParent().axe_radius = currentRadius

	local rotation_angle

	if self.i == 1 then 

		if self:GetParent().side == 1 then
		rotation_angle = elapsed_time * 360
		else
			rotation_angle = elapsed_time * 360 + 180
		end

	else 

		if self:GetParent().side == 1 then
		rotation_angle = elapsed_time * 360 + 90
		else
			rotation_angle = elapsed_time * 360 - 90
		end

	end

	local relPos = Vector( 0, currentRadius, 0 )
	relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotation_angle, 0 ), relPos )
	local absPos = GetGroundPosition( relPos + caster_location, self:GetParent() )
	absPos.z = absPos.z + 75
	self:GetParent():SetAbsOrigin( absPos )

	ParticleManager:SetParticleControl(self:GetParent().particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self:GetParent().particle, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self:GetParent().particle, 3, self:GetParent():GetAbsOrigin())
	if elapsed_time >= whirl_duration then
		self:GetParent():RemoveSelf()
	end

	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, hit_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
	for _, unit in pairs(units) do
		local was_hit = false
		if self:GetAbility() and self.index and self:GetAbility()[self.index] then
			for _, stored_target in ipairs(self:GetAbility()[self.index]) do
				if unit == stored_target then
					was_hit = true
				end
			end
		end
		if was_hit == false then
			table.insert(self:GetAbility()[self.index],unit)
			unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_troll_warlord_whirling_axes_melee_custom", {duration = blind_duration})

			local current_damage = damage
			if self:GetCaster():HasModifier("modifier_troll_warlord_whirling_axes_stack") then 
				current_damage = current_damage*(  (self:GetAbility().legendary_damage)*self:GetCaster():GetUpgradeStack("modifier_troll_warlord_whirling_axes_stack") + 1)
			end

			if not unit:HasModifier("modifier_troll_warlord_whirling_axes_proc_cd") and self:GetCaster():HasModifier("modifier_troll_axes_6") then
				unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_troll_warlord_whirling_axes_proc_cd", {duration = self:GetAbility().proc_cd}) 
				unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_troll_warlord_whirling_axes_proc_incoming", {duration = self:GetAbility().proc_damage_duration})
			end

			ApplyDamage({victim = unit, attacker = self:GetCaster(), damage = current_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
			unit:EmitSound("Hero_TrollWarlord.WhirlingAxes.Target")

	
		end
	end
end

function modifier_troll_warlord_whirling_axes_melee_custom_thinker:CheckState()
    local state = {
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR]              = true,
    [MODIFIER_STATE_INVULNERABLE]        = true  }
    return state
end

function modifier_troll_warlord_whirling_axes_melee_custom_thinker:OnDestroy()
	if not IsServer() then return end
	--self:GetAbility()[self.index] = nil
	UTIL_Remove(self:GetParent())
end

modifier_troll_warlord_whirling_axes_melee_custom = class({})

function modifier_troll_warlord_whirling_axes_melee_custom:IsPurgable() return true end
function modifier_troll_warlord_whirling_axes_melee_custom:IsPurgeException() return false end

function modifier_troll_warlord_whirling_axes_melee_custom:OnCreated(params)
	self.miss_chance = self:GetAbility():GetSpecialValueFor("blind_pct")

	if not self:GetParent():IsHero() then 
		self.miss_chance = self:GetAbility():GetSpecialValueFor("blind_creeps")
	end

	if self:GetCaster():HasModifier("modifier_troll_axes_2") then 
		self.miss_chance = self.miss_chance + self:GetAbility().miss_init + self:GetAbility().miss_inc*self:GetCaster():GetUpgradeStack("modifier_troll_axes_2")
	end

end

function modifier_troll_warlord_whirling_axes_melee_custom:OnRefresh(params)
	self:OnCreated(params)
end

function modifier_troll_warlord_whirling_axes_melee_custom:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_MISS_PERCENTAGE
		}
		
	return decFuns
end

function modifier_troll_warlord_whirling_axes_melee_custom:GetModifierMiss_Percentage()
	return self.miss_chance
end


modifier_troll_warlord_whirling_axes_attack = class({})
function modifier_troll_warlord_whirling_axes_attack:IsHidden() return false end
function modifier_troll_warlord_whirling_axes_attack:IsPurgable() return true end
function modifier_troll_warlord_whirling_axes_attack:GetTexture() return "buffs/quill_cdr" end
function modifier_troll_warlord_whirling_axes_attack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(self:GetAbility().attack_max)

end


function modifier_troll_warlord_whirling_axes_attack:OnRefresh(table)
self:OnCreated(table)
end

function modifier_troll_warlord_whirling_axes_attack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_troll_warlord_whirling_axes_attack:OnTooltip()
return self:GetAbility().attack_damage_init + self:GetAbility().attack_damage_inc*self:GetCaster():GetUpgradeStack("modifier_troll_axes_3")
end

function modifier_troll_warlord_whirling_axes_attack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetCaster() ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end

local damage = self:GetAbility().attack_damage_init + self:GetAbility().attack_damage_inc*self:GetCaster():GetUpgradeStack("modifier_troll_axes_3")

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),  params.target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )

local particle = ParticleManager:CreateParticle("particles/troll_hit.vpcf", PATTACH_WORLDORIGIN, nil)	
ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin())

for _,unit in pairs(units) do 

	ApplyDamage({victim = unit, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
	SendOverheadEventMessage(unit, 4, unit, damage, nil)
end


self:DecrementStackCount()

if self:GetStackCount() == 0 then 
	self:Destroy()
end

end



modifier_troll_warlord_whirling_axes_tracker = class({})
function modifier_troll_warlord_whirling_axes_tracker:IsHidden() return true end
function modifier_troll_warlord_whirling_axes_tracker:IsPurgable() return false end
function modifier_troll_warlord_whirling_axes_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
}
end

function modifier_troll_warlord_whirling_axes_tracker:OnAbilityFullyCast(params)
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:GetName() ~= "troll_warlord_whirling_axes_melee_custom" and params.ability:GetName() ~= "troll_warlord_whirling_axes_ranged_custom" then return end




if not self:GetParent():HasModifier("modifier_troll_axes_legendary") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_whirling_axes_stack", {ability = params.ability:GetName(), duration = self:GetAbility().legendary_duration})


end

modifier_troll_warlord_whirling_axes_stack = class({})
function modifier_troll_warlord_whirling_axes_stack:IsHidden() return false end
function modifier_troll_warlord_whirling_axes_stack:IsPurgable() return false end
function modifier_troll_warlord_whirling_axes_stack:GetTexture()

	if self.ability == "troll_warlord_whirling_axes_ranged_custom" then 
		return "troll_warlord_whirling_axes_melee"
	else 
		return "troll_warlord_whirling_axes_ranged"
	end
end



function modifier_troll_warlord_whirling_axes_stack:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
self.RemoveForDuel = true
self.ability = table.ability
self:SetHasCustomTransmitterData(true)

if self.effect_cast then 

	ParticleManager:DestroyParticle(self.effect_cast, true)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
end

local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf"
if self.ability == "troll_warlord_whirling_axes_ranged_custom" then 
	particle_cast = "particles/units/heroes/hero_marci/orb_damage_stack.vpcf"
end

	
self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
self:AddParticle(self.effect_cast,false, false, -1, false, false)




end

function modifier_troll_warlord_whirling_axes_stack:OnRefresh(table)
if not IsServer() then return end
if self.ability ~= table.ability then 
		if self:GetStackCount() < self:GetAbility().legendary_max then 
			self:IncrementStackCount()
		end
	self.ability = table.ability

	if self.effect_cast then 

		ParticleManager:DestroyParticle(self.effect_cast, true)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
	end

	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf"
	if self.ability == "troll_warlord_whirling_axes_ranged_custom" then 
		particle_cast = "particles/units/heroes/hero_marci/orb_damage_stack.vpcf"
	end

	
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
	self:AddParticle(self.effect_cast,false, false, -1, false, false)


else 
	self:Destroy()
end



end





function modifier_troll_warlord_whirling_axes_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_troll_warlord_whirling_axes_stack:OnTooltip()
return 100*(self:GetAbility().legendary_damage)*self:GetCaster():GetUpgradeStack("modifier_troll_warlord_whirling_axes_stack")
end


function modifier_troll_warlord_whirling_axes_stack:AddCustomTransmitterData() return 
{
ability = self.ability,
} 
end

function modifier_troll_warlord_whirling_axes_stack:HandleCustomTransmitterData(data)
self.ability = data.ability
end



modifier_troll_warlord_whirling_axes_heal = class({})
function modifier_troll_warlord_whirling_axes_heal:IsHidden() return false end
function modifier_troll_warlord_whirling_axes_heal:IsPurgable() return false end
function modifier_troll_warlord_whirling_axes_heal:GetTexture() return "buffs/Crit_blood" end
function modifier_troll_warlord_whirling_axes_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_troll_warlord_whirling_axes_heal:OnCreated(table)
self.heal = self:GetAbility().heal*100/self:GetRemainingTime()
end

function modifier_troll_warlord_whirling_axes_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_troll_warlord_whirling_axes_heal:GetModifierHealthRegenPercentage()
return self.heal
end


modifier_troll_warlord_whirling_axes_proc_cd = class({})
function modifier_troll_warlord_whirling_axes_proc_cd:IsHidden() return true end
function modifier_troll_warlord_whirling_axes_proc_cd:IsPurgable() return false end
function modifier_troll_warlord_whirling_axes_proc_cd:GetTexture() return "buffs/axes_proc" end
function modifier_troll_warlord_whirling_axes_proc_cd:RemoveOnDeath() return false end
function modifier_troll_warlord_whirling_axes_proc_cd:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
end
function modifier_troll_warlord_whirling_axes_proc_cd:IsDebuff() return true end

function modifier_troll_warlord_whirling_axes_proc_cd:OnDestroy()
if not IsServer() then return end
--self:GetParent():EmitSound("Lina.Array_triple")
end



modifier_troll_warlord_whirling_axes_proc_incoming = class({})
function modifier_troll_warlord_whirling_axes_proc_incoming:IsHidden() return false end
function modifier_troll_warlord_whirling_axes_proc_incoming:IsPurgable() return false end
function modifier_troll_warlord_whirling_axes_proc_incoming:GetTexture() return "buffs/axes_proc" end
function modifier_troll_warlord_whirling_axes_proc_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end
function modifier_troll_warlord_whirling_axes_proc_incoming:GetModifierIncomingDamage_Percentage()
return self:GetAbility().proc_damage
end

function modifier_troll_warlord_whirling_axes_proc_incoming:OnCreated(table)
if not IsServer() then return end
self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end



