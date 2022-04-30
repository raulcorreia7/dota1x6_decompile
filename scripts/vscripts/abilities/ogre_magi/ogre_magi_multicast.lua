LinkLuaModifier( "modifier_ogre_magi_multicast_custom", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_use", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_spell", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_spell_count", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_legendary_spell", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_legendary_cast", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_bkb_count", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_bkb", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_proc_count", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_proc", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_proc_bkb", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_proc_silence", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_proc_damage", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE ) 
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_attack", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_slow", "abilities/ogre_magi/ogre_magi_multicast", LUA_MODIFIER_MOTION_NONE )


ogre_magi_multicast_custom = class({})

ogre_magi_multicast_custom.chance3 = {2,4,6}
ogre_magi_multicast_custom.chance4 = {2,4,6}

ogre_magi_multicast_custom.fireball_radius = 1000
ogre_magi_multicast_custom.fireball_damage = 130
ogre_magi_multicast_custom.fireball_chance = {30, 50}
ogre_magi_multicast_custom.fireball_duration = 0.5

ogre_magi_multicast_custom.spell_damage = 1
ogre_magi_multicast_custom.spell_duration = {10,15,20}

ogre_magi_multicast_custom.legendary_duration = 10
ogre_magi_multicast_custom.legendary_channel = 4
ogre_magi_multicast_custom.legendary_radius = 1000
ogre_magi_multicast_custom.legendary_cd = 30

ogre_magi_multicast_custom.proc_max = 4
ogre_magi_multicast_custom.proc_bkb = 4
ogre_magi_multicast_custom.proc_silence = 3
ogre_magi_multicast_custom.proc_damage = 15
ogre_magi_multicast_custom.proc_damage_duration = 5

ogre_magi_multicast_custom.items_cd = 1

ogre_magi_multicast_custom.attack_duration = 8
ogre_magi_multicast_custom.attack_max = 10
ogre_magi_multicast_custom.attack_damage = {30,45,60}
ogre_magi_multicast_custom.attack_radius = 250



function ogre_magi_multicast_custom:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_ogremagi_multi_7") then 
  return self.legendary_cd
end

return

end


function ogre_magi_multicast_custom:GetIntrinsicModifierName()
	return "modifier_ogre_magi_multicast_custom"
end

function ogre_magi_multicast_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_ogremagi_multi_7") then
    return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED
  end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end



function ogre_magi_multicast_custom:CdItems()
if not IsServer() then return end

local items = {}

for i = 0, 5 do
    local current_item = self:GetCaster():GetItemInSlot(i)
  

    if current_item and current_item:GetName() ~= "item_aeon_disk" and current_item:GetCooldownTimeRemaining() > 0 then  
        items[#items + 1] = i
    end
end

if #items > 0 then 
	local random = items[RandomInt(1, #items)]
	local current_item = self:GetCaster():GetItemInSlot(random)

	if current_item then 
	    local cd = current_item:GetCooldownTimeRemaining()
	    current_item:EndCooldown()
	    if cd > self.items_cd then 
	        current_item:StartCooldown(cd - self.items_cd)
	    end
	end
end


end



function ogre_magi_multicast_custom:CdSkills()
if not IsServer() then return end

local skills = {}

for i = 0,self:GetCaster():GetAbilityCount()-1 do

    local current_skill = self:GetCaster():GetAbilityByIndex(i)
    
    if not current_skill or current_skill:GetName() == "ability_capture" then break end

  

    if current_skill:GetCooldownTimeRemaining() > 0 then  
        skills[#skills + 1] = i
    end
end

if #skills > 0 then 
	local random = skills[RandomInt(1, #skills)]
	local current_skill = self:GetCaster():GetAbilityByIndex(random)

	if current_skill then 
	    local cd = current_skill:GetCooldownTimeRemaining()
	    current_skill:EndCooldown()
	    if cd > self.items_cd then 
	        current_skill:StartCooldown(cd - self.items_cd)
	    end
	end
end


end



function ogre_magi_multicast_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():StartGesture(ACT_DOTA_TELEPORT)
self:GetCaster():EmitSound("Ogre.Multi_spell_start")

local table_skill = {}

for _,mod in pairs(self:GetCaster():FindAllModifiersByName("modifier_ogre_magi_multicast_custom_legendary_spell")) do 
	if mod.name ~= nil then 
		table_skill[#table_skill + 1] = mod.name
	end
	mod:Destroy()
end

if #table_skill == 0 then 
	return 
end

local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ogre_magi_multicast_custom_legendary_cast", table_skill)


end

function ogre_magi_multicast_custom:GetChannelTime()
	return self.legendary_channel
end




function ogre_magi_multicast_custom:OnChannelFinish(bInterrupted)
if not IsServer() then return end
	self:GetCaster():RemoveModifierByName("modifier_ogre_magi_multicast_custom_legendary_cast")
	self:GetCaster():FadeGesture(ACT_DOTA_TELEPORT)
end










function ogre_magi_multicast_custom:OnProjectileHit(target, vLocation)
	if target then
		local damage = self.fireball_damage

		SendOverheadEventMessage(target, 4, target, damage, nil)

		target:EmitSound("Hero_OgreMagi.FireShield.Damage")
		target:AddNewModifier(self:GetCaster(), self, "modifier_ogre_magi_multicast_custom_slow", {duration = self.fireball_duration*(1 - target:GetStatusResistance())})
		ApplyDamage( { victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self } )
	end
end

function ogre_magi_multicast_custom:Fireball()
if not IsServer() then return end
local chance = self.fireball_chance[self:GetCaster():GetUpgradeStack("modifier_ogremagi_multi_4")]

if not RollPseudoRandomPercentage(chance, 516, self:GetCaster()) then  return end


	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.fireball_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false )
		
	if #units > 0 then 	

		local info = {
			Target = units[RandomInt(1, #units)],
			Source = self:GetCaster(),
			Ability = self,	
			EffectName = "particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield_projectile.vpcf",
			iMoveSpeed = 900,
			bReplaceExisting = false,
			bProvidesVision = true,
			iVisionRadius = 50,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),			
		}
		ProjectileManager:CreateTrackingProjectile(info)

	end
end





modifier_ogre_magi_multicast_custom = class({})

modifier_ogre_magi_multicast_custom.one_target = {
	["ogre_magi_fireblast_custom"] = true,
	["ogre_magi_unrefined_fireblast_custom"] = true,
}


modifier_ogre_magi_multicast_custom.item_exceptions =
{
	["item_patrol_grenade"] = true,
	["item_patrol_midas"] = true,
	["item_patrol_razor"] = true,
	["item_repair_patrol"] = true,
	["item_soul_keeper_custom"] = true,
	["item_spirit_vessel_custom"] = true,
	["item_urn_of_shadows_custom"] = true,
	["item_upgrade_repair"] = true,
	["item_holy_locket"] = true,
	[""] = true,
}





function modifier_ogre_magi_multicast_custom:IsPurgable()
	return false
end

function modifier_ogre_magi_multicast_custom:IsHidden()
	return true
end



function modifier_ogre_magi_multicast_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_ogre_magi_multicast_custom:OnAbilityFullyCast( params )
	if params.unit~=self:GetCaster() then return end
	if params.ability==self:GetAbility() then return end
	if self:GetCaster():PassivesDisabled() then return end
	if params.ability:IsItem() and self.item_exceptions[params.ability:GetName()] == true then return end

	local target = params.target
	local point = nil

	if (params.ability:GetName() == "ogre_magi_fireblast_custom" or params.ability:GetName() == "ogre_magi_unrefined_fireblast_custom")
	 and self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then 
		point = self:GetCaster():GetCursorPosition()
	else 

		if params.ability:GetAbilityName() ~= "ogre_magi_smash_custom" and params.ability:GetAbilityName() ~= "ogre_magi_bloodlust_custom" then
			if not target then return end
			if bit.band( params.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_POINT ) ~= 0 then return end
			if bit.band( params.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET ) ~= 0 then return end
		end

		if params.ability:GetAbilityName() == "ogre_magi_smash_custom" or params.ability:GetAbilityName() == "ogre_magi_bloodlust_custom"  then
			target = self:GetCaster()
		end
	end


	local chance_2 = self:GetAbility():GetSpecialValueFor( "multicast_2_times" )
	local chance_3 = self:GetAbility():GetSpecialValueFor( "multicast_3_times" )
	local chance_4 = self:GetAbility():GetSpecialValueFor( "multicast_4_times" )

	if self:GetParent():HasModifier("modifier_ogremagi_multi_1") then 
		if chance_3 > 0 then 
			chance_3 = chance_3 + self:GetAbility().chance3[self:GetParent():GetUpgradeStack("modifier_ogremagi_multi_1")]
		end

		if chance_4 > 0 then 
			chance_4 = chance_4 + self:GetAbility().chance4[self:GetParent():GetUpgradeStack("modifier_ogremagi_multi_1")]
		end
	end


	local multicast_multi = 1

	if RollPseudoRandomPercentage(chance_4, 52, self:GetParent()) then 
		multicast_multi = 4 
	else 
		if RollPseudoRandomPercentage(chance_3, 51, self:GetParent()) then 
			multicast_multi = 3 
		else 
			if RollPseudoRandomPercentage(chance_2, 50, self:GetParent()) then
				multicast_multi = 2 
			end
		end
	end


	local delay = params.ability:GetSpecialValueFor( "multicast_delay" ) or 0

	local single = self.one_target[params.ability:GetAbilityName()] or false

	if self:GetCaster():HasModifier("modifier_ogremagi_multi_4") then 
		self:GetAbility():Fireball()
	end
	
	if self:GetCaster():HasModifier("modifier_ogremagi_multi_3") and not params.ability:IsItem() then 
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ogre_magi_multicast_custom_attack", {duration = self:GetAbility().attack_duration})
	end


	if ( (target == nil or target:GetTeam() ~= self:GetParent():GetTeam())
	or params.ability:GetName() == "ogre_magi_bloodlust_custom" or params.ability:GetName() == "ogre_magi_smash_custom")  then 
		
		if self:GetCaster():HasModifier("modifier_ogremagi_multi_7") then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ogre_magi_multicast_custom_legendary_spell", {duration = self:GetAbility().legendary_duration, name = params.ability:GetName()})
		end


	end


	if self:GetParent():HasModifier("modifier_ogremagi_multi_6") then 
		if params.ability:IsItem() then 
			self:GetAbility():CdSkills()
		else 
			self:GetAbility():CdItems()
		end

	end

	if point == nil then 
		self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_ogre_magi_multicast_custom_use", { ability = params.ability:entindex(), target = target:entindex(), multicast = multicast_multi, delay = delay, single = single, } )
	else 
		self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_ogre_magi_multicast_custom_use", { ability = params.ability:entindex(), x = point.x, y = point.y, z = point.z, multicast = multicast_multi, delay = delay, single = single, } )
	end
end


modifier_ogre_magi_multicast_custom_use = class({})

function modifier_ogre_magi_multicast_custom_use:IsHidden()
	return true
end

function modifier_ogre_magi_multicast_custom_use:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_ogre_magi_multicast_custom_use:IsPurgable()
	return false
end

function modifier_ogre_magi_multicast_custom_use:RemoveOnDeath()
	return false
end

function modifier_ogre_magi_multicast_custom_use:OnCreated( kv )
	if not IsServer() then return end
	self.caster = self:GetParent()
	self.ability = EntIndexToHScript( kv.ability )

	self.point = nil 
	self.target = nil 

	if kv.target then 
		self.target = EntIndexToHScript( kv.target )
	else 
		self.point = Vector(kv.x, kv.y, kv.z)
	end


	self.multicast = kv.multicast
	self.delay = kv.delay
	self.single = kv.single==1
	self.buffer_range = 600
	self:SetStackCount( self.multicast )

	self.casts = 0

	if self.multicast==1 then
		self:Destroy()
		return
	end

	self.targets = {}
	self.no_target = 0

	if self.target ~= nil then 


		if self.ability:GetAbilityName() ~= "ogre_magi_ignite_custom" then
			self.targets[self.target] = true
		end


		if self:GetCaster() == self.target then 
			self.no_target = 1
		end

		self.radius = self.ability:GetCastRange( self.target:GetOrigin(), self.target ) + self.buffer_range


		self.target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY

		if self.target:GetTeamNumber()~=self.caster:GetTeamNumber() then
			self.target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
		end
	end

	self.target_type = self.ability:GetAbilityTargetType()

	if self.target_type==DOTA_UNIT_TARGET_CUSTOM then
		self.target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	end

	self.target_flags = DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE

	if bit.band( self.ability:GetAbilityTargetFlags(), DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ) ~= 0 then
		self.target_flags = self.target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	
	self:PlayEffects( self.multicast )
	self:StartIntervalThink( self.delay )
end

function modifier_ogre_magi_multicast_custom_use:OnIntervalThink()
	local current_target = nil

	if self.no_target == 1 then 
		if not self.ability:IsItem() then 
			self.ability:OnSpellStart(true)
		end
	else 

		if self.single then
			current_target = self.target
		else
			local units = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetOrigin(), nil, self.radius, self.target_team, self.target_type, self.target_flags, FIND_ANY_ORDER, false )
			for _,unit in pairs(units) do
				if not self.targets[unit] then
					local filter = false
					if self.ability.CastFilterResultTarget then
						filter = self.ability:CastFilterResultTarget( unit ) == UF_SUCCESS
					else
						filter = true
					end

					if filter then

						if #units > 1 and self.ability:GetAbilityName() ~= "ogre_magi_ignite_custom" then
							self.targets[unit] = true
						end
						current_target = unit
						break
					end
				end
			end
			if not current_target then
				self:StartIntervalThink( -1 )
				self:Destroy()
				return
			end
		end


		if self.ability:IsItem() then
			self.caster:SetCursorCastTarget( current_target )
			self.ability:OnSpellStart()
		else
			if self.point ~= nil then 
				self.ability:OnSpellStart(nil, nil, self.point)
			else 
				self.ability:OnSpellStart(current_target)
			end
		end
	end

	if self:GetCaster():HasModifier("modifier_ogremagi_multi_4") then 
		self:GetAbility():Fireball()
	end	

	if self:GetCaster():HasModifier("modifier_ogremagi_multi_3") and not self.ability:IsItem() then 
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ogre_magi_multicast_custom_attack", {duration = self:GetAbility().attack_duration})
	end

	if  (self.target_team ~= DOTA_UNIT_TARGET_TEAM_FRIENDLY
	or self.ability:GetName() == "ogre_magi_bloodlust_custom" or self.ability:GetName() == "ogre_magi_smash_custom")  then 

		if self:GetCaster():HasModifier("modifier_ogremagi_multi_7") then 
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ogre_magi_multicast_custom_legendary_spell", {duration = self:GetAbility().legendary_duration, name = self.ability:GetName()})
		end

	end

	
	if  self:GetCaster():HasModifier("modifier_ogremagi_multi_5") and not self:GetCaster():HasModifier("modifier_ogre_magi_multicast_custom_proc") then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ogre_magi_multicast_custom_proc_count", {})
	end

	if self:GetParent():HasModifier("modifier_ogremagi_multi_6") then 
		if self.ability:IsItem() then 
			self:GetAbility():CdSkills()
		else 
			self:GetAbility():CdItems()
		end
	end



	self.casts = self.casts + 1
	if self.casts>=(self.multicast-1) then
		self:StartIntervalThink( -1 )
		self:Destroy()
	end
end

function modifier_ogre_magi_multicast_custom_use:PlayEffects( value )
	
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, self.caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( value, counter_speed, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local sound = math.min( value-1, 3 )

	local sound_cast = "Hero_OgreMagi.Fireblast.x" .. sound

	if sound>0 then
		self.caster:EmitSound(sound_cast)
	end
end



modifier_ogre_magi_multicast_custom_spell = class({})
function modifier_ogre_magi_multicast_custom_spell:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_spell:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_spell:GetTexture() return "buffs/multi_spell" end

function modifier_ogre_magi_multicast_custom_spell:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_ogre_magi_multicast_custom_spell:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end


function modifier_ogre_magi_multicast_custom_spell:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end


function modifier_ogre_magi_multicast_custom_spell:GetModifierSpellAmplify_Percentage()
return self:GetStackCount()*self:GetAbility().spell_damage
end


modifier_ogre_magi_multicast_custom_spell_count = class({})
function modifier_ogre_magi_multicast_custom_spell_count:IsHidden() return true end
function modifier_ogre_magi_multicast_custom_spell_count:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_spell_count:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_ogre_magi_multicast_custom_spell_count:OnCreated(table)
self.RemoveForDuel = true
end

function modifier_ogre_magi_multicast_custom_spell_count:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_ogre_magi_multicast_custom_spell")

if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end


end


modifier_ogre_magi_multicast_custom_legendary_spell = class({})
function modifier_ogre_magi_multicast_custom_legendary_spell:IsHidden() return true end
function modifier_ogre_magi_multicast_custom_legendary_spell:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_legendary_spell:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_ogre_magi_multicast_custom_legendary_spell:OnCreated(table)
self.RemoveForDuel = true 
self.name = table.name
end


modifier_ogre_magi_multicast_custom_legendary_cast = class({})
function modifier_ogre_magi_multicast_custom_legendary_cast:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_legendary_cast:IsPurgable() return false end

function modifier_ogre_magi_multicast_custom_legendary_cast:OnCreated(table)
if not IsServer() then return end



self.effect_cast = ParticleManager:CreateParticle( "particles/ogre_ult.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl( self.effect_cast, 4, self:GetParent():GetAbsOrigin())
self:AddParticle(self.effect_cast, false, false, -1, false, true)

self.skills = {}

for _,name in pairs(table) do 
	if name ~= table.creationtime then 
		self.skills[#self.skills + 1] = name
	end
end

if #self.skills == 0 then 
	self:Destroy()
	return
end

local interval = self:GetAbility().legendary_channel/#self.skills - 0.05
self:StartIntervalThink(interval)
end


function modifier_ogre_magi_multicast_custom_legendary_cast:OnIntervalThink()
if not IsServer() then return end
if #self.skills == 0 then return end


local i = RandomInt(1,#self.skills)

local name = self.skills[i]
local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility().legendary_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false )
local fireball = false

table.remove(self.skills,i)

for abilitySlot = 0,15 do

	local ability = self:GetParent():GetAbilityByIndex(abilitySlot)

	if ability ~= nil and ability:GetName() == name then

		if name == "ogre_magi_smash_custom" or name == "ogre_magi_bloodlust_custom" then 
			ability:OnSpellStart(true)
			fireball = true	

			if self:GetParent():HasModifier("modifier_ogremagi_multi_6") then 
				self:GetAbility():CdItems()
			end	

			if self:GetCaster():HasModifier("modifier_ogremagi_multi_3") then 
				self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ogre_magi_multicast_custom_attack", {duration = self:GetAbility().attack_duration})
			end	
		else 
			if #units > 0 then 
				local target = units[RandomInt(1, #units)]
				if name == "ogre_magi_fireblast_custom" or name == "ogre_magi_unrefined_fireblast_custom" then 
					if self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then 
						ability:OnSpellStart(nil, true, target:GetAbsOrigin())
					else 
						ability:OnSpellStart(target, true)
					end
				else 
					ability:OnSpellStart(target)
				end

				fireball = true

				if self:GetParent():HasModifier("modifier_ogremagi_multi_6") then 
					self:GetAbility():CdItems()
				end

				if self:GetCaster():HasModifier("modifier_ogremagi_multi_3") then 
					self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ogre_magi_multicast_custom_attack", {duration = self:GetAbility().attack_duration})
				end	
			end
		end

	end

end

for itemSlot=0,5 do

	local item = self:GetParent():GetItemInSlot(itemSlot)
	if item and item:GetName() == name and #units > 0 then 

		if bit.band( item:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_BOTH) ~= 0 or bit.band( item:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_ENEMY ) ~= 0 then
			self:GetParent():SetCursorCastTarget( units[RandomInt(1, #units)] )
			item:OnSpellStart()
			fireball = true

			if self:GetParent():HasModifier("modifier_ogremagi_multi_6") then 
				self:GetAbility():CdSkills()
			end
		end
	end

end


if fireball then 

	self:GetParent():EmitSound("Ogre.Multi_spell")

	if self:GetParent():HasModifier("modifier_ogremagi_multi_4") then 
		self:GetAbility():Fireball()
	end

end	

end


modifier_ogre_magi_multicast_custom_bkb_count = class({})
function modifier_ogre_magi_multicast_custom_bkb_count:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_bkb_count:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_bkb_count:GetTexture() return "buffs/multi_bkb" end

function modifier_ogre_magi_multicast_custom_bkb_count:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_ogre_magi_multicast_custom_bkb_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().bkb_max then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ogre_magi_multicast_custom_bkb", {duration = self:GetAbility().bkb_duration})
	local heal = self:GetParent():GetMaxHealth()*self:GetAbility().bkb_heal

	self:GetParent():Heal(heal, self:GetAbility())

	SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

	local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( particle )
	self:Destroy()
end

end


function modifier_ogre_magi_multicast_custom_bkb_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_ogre_magi_multicast_custom_bkb_count:OnTooltip()
	return self:GetAbility().bkb_max
end


modifier_ogre_magi_multicast_custom_bkb = class({})
function modifier_ogre_magi_multicast_custom_bkb:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_bkb:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_bkb:GetTexture() return "buffs/multi_bkb" end
function modifier_ogre_magi_multicast_custom_bkb:CheckState()
return
{
	[MODIFIER_STATE_MAGIC_IMMUNE] = true
}
end


function modifier_ogre_magi_multicast_custom_bkb:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_ogre_magi_multicast_custom_bkb:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end






modifier_ogre_magi_multicast_custom_proc_count = class({})
function modifier_ogre_magi_multicast_custom_proc_count:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_proc_count:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_proc_count:GetTexture() return "buffs/multi_bkb" end

function modifier_ogre_magi_multicast_custom_proc_count:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_ogre_magi_multicast_custom_proc_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().proc_max then 

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ogre_magi_multicast_custom_proc", {})
	self:GetParent():EmitSound("Ogre.Multi_proc")
	self:Destroy()
end

end


function modifier_ogre_magi_multicast_custom_proc_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_ogre_magi_multicast_custom_proc_count:OnTooltip()
	return self:GetAbility().proc_max
end

function modifier_ogre_magi_multicast_custom_proc_count:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if self:GetStackCount() == 1 then 

	local particle_cast = "particles/ogre_count.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 
  if self.effect_cast then 
  	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
  end
end

end







modifier_ogre_magi_multicast_custom_proc = class({})
function modifier_ogre_magi_multicast_custom_proc:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_proc:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_proc:GetTexture() return "buffs/multi_bkb" end

function modifier_ogre_magi_multicast_custom_proc:GetEffectName() return
"particles/ogre_head.vpcf" end


function modifier_ogre_magi_multicast_custom_proc:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end





modifier_ogre_magi_multicast_custom_proc_bkb = class({})
function modifier_ogre_magi_multicast_custom_proc_bkb:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_proc_bkb:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_proc_bkb:GetTexture() return "buffs/multi_bkb" end
function modifier_ogre_magi_multicast_custom_proc_bkb:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Huskar.Leap_Bkb")
end

function modifier_ogre_magi_multicast_custom_proc_bkb:CheckState()
return
{
	[MODIFIER_STATE_MAGIC_IMMUNE] = true
}
end


function modifier_ogre_magi_multicast_custom_proc_bkb:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_ogre_magi_multicast_custom_proc_bkb:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end



modifier_ogre_magi_multicast_custom_proc_silence = class({})
function modifier_ogre_magi_multicast_custom_proc_silence:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_proc_silence:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_proc_silence:GetTexture() return "buffs/multi_bkb" end
function modifier_ogre_magi_multicast_custom_proc_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_ogre_magi_multicast_custom_proc_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_ogre_magi_multicast_custom_proc_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


modifier_ogre_magi_multicast_custom_proc_damage = class({})
function modifier_ogre_magi_multicast_custom_proc_damage:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_proc_damage:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_proc_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end
function modifier_ogre_magi_multicast_custom_proc_damage:GetModifierIncomingDamage_Percentage()
return self:GetAbility().proc_damage
end

function modifier_ogre_magi_multicast_custom_proc_damage:OnCreated(table)
if not IsServer() then return end
self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end





modifier_ogre_magi_multicast_custom_attack = class({})
function modifier_ogre_magi_multicast_custom_attack:IsHidden() return false end
function modifier_ogre_magi_multicast_custom_attack:IsPurgable() return false end
function modifier_ogre_magi_multicast_custom_attack:GetTexture() return "buffs/multi_attack" end

function modifier_ogre_magi_multicast_custom_attack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_ogre_magi_multicast_custom_attack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().attack_max then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().attack_max then 

  	self:GetParent():EmitSound("Lina.Array_triple")
    self.particle = ParticleManager:CreateParticle( "particles/ogre_magichit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetAbsOrigin() )
    ParticleManager:SetParticleControl( self.particle, 1, self:GetParent():GetAbsOrigin() )
    ParticleManager:SetParticleControl( self.particle, 2, self:GetParent():GetAbsOrigin() ) 
    self:AddParticle(self.particle, false, false, -1, false, false) 


end

end


function modifier_ogre_magi_multicast_custom_attack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_ogre_magi_multicast_custom_attack:OnTooltip()
return self:GetAbility().attack_damage[self:GetCaster():GetUpgradeStack("modifier_ogremagi_multi_3")]*self:GetStackCount()
end


function modifier_ogre_magi_multicast_custom_attack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self:GetAbility().attack_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
	
local damage = self:GetAbility().attack_damage[self:GetCaster():GetUpgradeStack("modifier_ogremagi_multi_3")]*self:GetStackCount()

local particle = ParticleManager:CreateParticle("particles/ogre_hit.vpcf", PATTACH_WORLDORIGIN, nil)	
	ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin())

for _,unit in pairs(units) do 
	unit:EmitSound("Ogre.Spell_hit")
	ApplyDamage( { victim = unit, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()} )
	SendOverheadEventMessage(unit, 4, unit, damage, nil)
end


self:Destroy()


end


modifier_ogre_magi_multicast_custom_slow = class({})
function modifier_ogre_magi_multicast_custom_slow:IsHidden() return true end
function modifier_ogre_magi_multicast_custom_slow:IsPurgable() return true end
function modifier_ogre_magi_multicast_custom_slow:GetTexture() return "buffs/multi_slow" end
function modifier_ogre_magi_multicast_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_ogre_magi_multicast_custom_slow:GetModifierMoveSpeedBonus_Percentage()
	return -100
end
