LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_transform", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_transform_aura_applier", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_transform_aura", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_fear_thinker", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_ring_lua_terrorblade", "abilities/generic/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_tracker", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_lowhp_cd", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_lowhp", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_buff", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_metamorphosis_slow", "abilities/terrorblade/custom_terrorblade_metamorphosis", LUA_MODIFIER_MOTION_NONE)



custom_terrorblade_metamorphosis = class({})

custom_terrorblade_metamorphosis.regen_init = 0
custom_terrorblade_metamorphosis.regen_inc = 1

custom_terrorblade_metamorphosis.stats_init = 0
custom_terrorblade_metamorphosis.stats_inc = 5

custom_terrorblade_metamorphosis.legendary_cd = 4
custom_terrorblade_metamorphosis.legendary_mana = 0.03

custom_terrorblade_metamorphosis.stack_interval = 1
custom_terrorblade_metamorphosis.stack_max = 10
custom_terrorblade_metamorphosis.stack_damage_init = 0
custom_terrorblade_metamorphosis.stack_damage_inc = 30
custom_terrorblade_metamorphosis.stack_move_init = 5
custom_terrorblade_metamorphosis.stack_move_inc = 10

custom_terrorblade_metamorphosis.range_range = 150
custom_terrorblade_metamorphosis.range_slow = -25
custom_terrorblade_metamorphosis.range_duration = 3

custom_terrorblade_metamorphosis.lowhp_cd = 60
custom_terrorblade_metamorphosis.lowhp_heal = 0.20
custom_terrorblade_metamorphosis.lowhp_duration = 2
custom_terrorblade_metamorphosis.lowhp_reduce = -50

custom_terrorblade_metamorphosis.aoe_init = 0
custom_terrorblade_metamorphosis.aoe_inc = 0.2
custom_terrorblade_metamorphosis.aoe_aoe = 250


function custom_terrorblade_metamorphosis:GetIntrinsicModifierName()
return "modifier_custom_terrorblade_metamorphosis_tracker"
end
function custom_terrorblade_metamorphosis:GetManaCost(level)
if self:GetCaster():HasModifier("modifier_custom_terrorblade_metamorphosis") and self:GetCaster():HasModifier("modifier_terror_meta_legendary") then 
	return 0
end
return self.BaseClass.GetManaCost(self,level)
end

function custom_terrorblade_metamorphosis:GetBehavior()
  if self:GetCaster():HasModifier("modifier_terror_meta_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE end
 return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE 
end


function custom_terrorblade_metamorphosis:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_terror_meta_legendary") then return self.legendary_cd end  
return self.BaseClass.GetCooldown(self, iLevel) 
end

function custom_terrorblade_metamorphosis:ResetToggleOnRespawn()
if self:GetCaster():HasModifier("modifier_terror_meta_legendary") then return true end  
end


function custom_terrorblade_metamorphosis:OnToggle() 
local caster = self:GetCaster()

local mod = self:GetCaster():FindModifierByName("modifier_custom_terrorblade_metamorphosis")
if mod then 
	mod:Destroy()
end

if self:GetToggleState() then
	self:UseMeta(nil,1)
end



self:StartCooldown(self.legendary_cd) 
end





function custom_terrorblade_metamorphosis:OnSpellStart( duration )
if not IsServer() then return end


	self:UseMeta(self:GetSpecialValueFor("duration"), 0)

	
end


function custom_terrorblade_metamorphosis:UseMeta(duration, hploss)



self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_metamorphosis_transform", {duration = self:GetSpecialValueFor("transformation_time"), meta_duration = duration, hploss = hploss})

for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("metamorph_aura_tooltip"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)) do
	
	if unit ~= self:GetCaster() and unit:IsIllusion() and unit:GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID() and unit:GetName() == self:GetCaster():GetName() then

		unit:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_metamorphosis_transform", {duration = self:GetSpecialValueFor("transformation_time"), meta_duration = 9999})
			
	end
end


end



modifier_custom_terrorblade_metamorphosis_transform = class({})


function modifier_custom_terrorblade_metamorphosis_transform:IsHidden()	return true end
function modifier_custom_terrorblade_metamorphosis_transform:IsPurgable() return false end

function modifier_custom_terrorblade_metamorphosis_transform:OnCreated(table)
	self.duration	= table.meta_duration
	if not IsServer() then return end
	self.hploss = table.hploss


	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3)
	self:GetParent():EmitSound("Hero_Terrorblade.Metamorphosis")

	local transform_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(transform_particle)
	
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis_transform_aura_applier", {})
	
	if self:GetParent():HasAbility("custom_terrorblade_terror_wave") then
		self:GetParent():FindAbilityByName("custom_terrorblade_terror_wave"):SetActivated(false)
	end
end

function modifier_custom_terrorblade_metamorphosis_transform:OnDestroy()
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_final_duel_start") then return end


	if self:GetParent():HasAbility("custom_terrorblade_terror_wave") then
		self:GetParent():FindAbilityByName("custom_terrorblade_terror_wave"):SetActivated(true)
	end

	if not self:GetParent():IsAlive() then 
		self:GetParent():RemoveModifierByName("modifier_custom_terrorblade_metamorphosis_transform_aura_applier")
	end

	local meta = self:GetParent():FindModifierByName("modifier_custom_terrorblade_metamorphosis")
	if not meta then 
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis", {duration = self.duration, hploss = self.hploss})
	else 
		meta:SetDuration(meta:GetRemainingTime() + self.duration, true)
	end
end

function modifier_custom_terrorblade_metamorphosis_transform:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true}
end



modifier_custom_terrorblade_metamorphosis = class({})

function modifier_custom_terrorblade_metamorphosis:IsPurgable() return false end

function modifier_custom_terrorblade_metamorphosis:OnCreated(table)
	if not self:GetAbility() then self:Destroy() return end



	self.hploss = table.hploss

	self.RemoveForDuel = true

	self.particle_ally_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
    self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 

	self.bonus_range 	= self:GetAbility():GetSpecialValueFor("bonus_range")

	if self:GetParent():HasModifier("modifier_terror_meta_range") then 
		self.bonus_range = self.bonus_range + self:GetAbility().range_range
	end


	self.bonus_damage	= self:GetAbility():GetSpecialValueFor("bonus_damage")
	
	if not IsServer() then return end
	
	--self:GetParent():NotifyWearablesOfModelChange(true)

	self.previous_attack_cability = self:GetParent():GetAttackCapability()
	
	self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	
	self.str_percentage = 0
	self.agi_percentage = 0

	if self:GetCaster():HasModifier("modifier_terror_meta_stats") then 
		
		self.str_percentage = self:GetAbility().stats_init + self:GetAbility().stats_inc*self:GetCaster():GetUpgradeStack("modifier_terror_meta_stats")
		self.agi_percentage = self:GetAbility().stats_init + self:GetAbility().stats_inc*self:GetCaster():GetUpgradeStack("modifier_terror_meta_stats")

	end

	if self:GetCaster():HasModifier("modifier_terror_meta_stats") or (self:GetParent():HasModifier("modifier_terror_meta_legendary") and self.hploss == 1) then 
		self:OnIntervalThink()
		self:StartIntervalThink(0.5)
	end


	if self:GetCaster():HasModifier("modifier_terror_meta_start") and not self:GetParent():HasModifier("modifier_custom_terrorblade_metamorphosis_buff") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis_buff", {})

	end


end

function modifier_custom_terrorblade_metamorphosis:OnIntervalThink()
if not IsServer() then return end

if 	self:GetCaster():HasModifier("modifier_terror_meta_stats") then 

	self.strength   = 0
	self.strength   = self:GetParent():GetStrength() * self.str_percentage * 0.01

	self.agility  = 0
	self.agility   = self:GetParent():GetAgility() * self.agi_percentage * 0.01

	self:GetParent():CalculateStatBonus(true)

end

if self:GetParent():HasModifier("modifier_terror_meta_legendary")  and self.hploss == 1 then 


	if self:GetParent():GetMana() >= self:GetParent():GetMaxMana()*self:GetAbility().legendary_mana*0.5 then 
		self:GetParent():SpendMana(self:GetParent():GetMaxMana()*self:GetAbility().legendary_mana*0.5, self:GetAbility())
	else 
		if self:GetAbility():GetToggleState() then 
  			self:GetAbility():ToggleAbility()
  		end 
	end

	--self:GetParent():SetHealth(math.max(1,self:GetParent():GetHealth() - self:GetParent():GetMaxHealth()*))
end

end

function modifier_custom_terrorblade_metamorphosis:OnDestroy()
	if not IsServer() then return end
	
	local ability = self:GetParent():FindAbilityByName("custom_terrorblade_metamorphosis")
	
	if ability and self:GetParent():HasModifier("modifier_terror_meta_legendary") then 

  		ability:SetActivated(true)
	end

	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
	
	self:GetParent():SetAttackCapability(self.previous_attack_cability)
	


	self:GetParent():RemoveModifierByName("modifier_custom_terrorblade_metamorphosis_transform_aura_applier")

end

function modifier_custom_terrorblade_metamorphosis:CheckState()
	if not self:GetAbility() then self:Destroy() return end
end

function modifier_custom_terrorblade_metamorphosis:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,

		MODIFIER_PROPERTY_MODEL_SCALE,

		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,

		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,

		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_custom_terrorblade_metamorphosis:GetMinHealth()
if self:GetParent():IsIllusion() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if not self:GetParent():HasModifier("modifier_terror_meta_lowhp") then return end
if self:GetParent():HasModifier("modifier_custom_terrorblade_metamorphosis_lowhp_cd") then return end

return 1

end


function modifier_custom_terrorblade_metamorphosis:OnTakeDamage(params)
if self:GetParent() ~= params.unit then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():IsIllusion() then return end
if not self:GetParent():HasModifier("modifier_terror_meta_lowhp") then return end
if self:GetParent():HasModifier("modifier_custom_terrorblade_metamorphosis_lowhp_cd") then return end
if self:GetParent():HasModifier("modifier_up_res") and not self:GetParent():HasModifier("modifier_up_res_cd") then return end
if self:GetParent():GetHealth() > 1 then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis_lowhp_cd", {duration = self:GetAbility().lowhp_cd})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis_lowhp", {duration = self:GetAbility().lowhp_duration})

local heal = self:GetParent():GetMaxHealth()*self:GetAbility().lowhp_heal

self:GetParent():EmitSound("TB.Meta_lowhp")
self:GetParent():Heal(heal, self:GetAbility())

local particle = ParticleManager:CreateParticle( "particles/tb_meta_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl(particle, 15, Vector(13,160,34))
ParticleManager:SetParticleControl(particle, 16, Vector(1,0,0))
ParticleManager:ReleaseParticleIndex( particle )


SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)

end


function modifier_custom_terrorblade_metamorphosis:GetModifierBonusStats_Strength()
	return self.strength
end

function modifier_custom_terrorblade_metamorphosis:GetModifierBonusStats_Agility()
	return self.agility
end


function modifier_custom_terrorblade_metamorphosis:GetModifierHealthRegenPercentage()
local regen = 0
if self:GetParent():HasModifier("modifier_terror_meta_regen") then 
	regen = self:GetAbility().regen_init + self:GetAbility().regen_inc*self:GetParent():GetUpgradeStack("modifier_terror_meta_regen")
end
return regen
end


function modifier_custom_terrorblade_metamorphosis:GetModelScale() return 10 end

function modifier_custom_terrorblade_metamorphosis:GetModifierModelChange()
	return "models/heroes/terrorblade/demon.vmdl"
end

function modifier_custom_terrorblade_metamorphosis:GetAttackSound()
	return "Hero_Terrorblade_Morphed.Attack"
end

function modifier_custom_terrorblade_metamorphosis:GetModifierProjectileName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"
end

function modifier_custom_terrorblade_metamorphosis:OnAttackStart(keys)
	if keys.attacker == self:GetParent() then
		self:GetParent():EmitSound("Hero_Terrorblade_Morphed.preAttack")
	end
end

function modifier_custom_terrorblade_metamorphosis:OnAttack(keys)
	if keys.attacker == self:GetParent() then
		self:GetParent():EmitSound("Hero_Terrorblade_Morphed.Attack")
	end
end

function modifier_custom_terrorblade_metamorphosis:OnAttackLanded(params)
if params.attacker ~= self:GetParent() then return end
self:GetParent():EmitSound("Hero_Terrorblade_Morphed.projectileImpact")


if self:GetParent():HasModifier("modifier_terror_meta_range") then 
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis_slow", {duration = self:GetAbility().range_duration})
end


if self:GetParent():HasModifier("modifier_terror_meta_magic") then 

	local damage = self:GetAbility().aoe_init + self:GetAbility().aoe_inc*self:GetParent():GetUpgradeStack("modifier_terror_meta_magic")

	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self:GetAbility().aoe_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #targets < 2 then return end

	if self:GetParent():IsRealHero()  then 
		self.effect_cast = ParticleManager:CreateParticle( "particles/tb_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target )
		ParticleManager:SetParticleControl( self.effect_cast, 0, params.target:GetAbsOrigin())
		ParticleManager:SetParticleControl( self.effect_cast, 1, params.target:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
	end


	for _,target in ipairs(targets) do 
		if target ~= params.target then 
			ApplyDamage({victim = target, attacker = self:GetParent(), ability = self:GetAbility(), damage = params.damage*damage, damage_type = DAMAGE_TYPE_PHYSICAL})
		end
	end	
end

end

function modifier_custom_terrorblade_metamorphosis:GetModifierAttackRangeBonus()
	if self:GetParent():GetName() ~= "npc_dota_hero_rubick" then
		return self.bonus_range
	end
end

function modifier_custom_terrorblade_metamorphosis:GetModifierBaseAttack_BonusDamage()
	return self.bonus_damage
end







modifier_custom_terrorblade_metamorphosis_transform_aura_applier = class({})


function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:OnCreated()
	self.metamorph_aura_tooltip	= self:GetAbility():GetSpecialValueFor("metamorph_aura_tooltip")
end

function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:IsHidden()						return true end

function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:IsAura()						return true end
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:IsAuraActiveOnDeath() 			return false end

-- "The transformation aura's buff lingers for 1 second."
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetAuraDuration()				return 0.5 end
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetAuraRadius()					return self.metamorph_aura_tooltip end
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetAuraSearchTeam()				return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetAuraSearchType()				return DOTA_UNIT_TARGET_HERO end
function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetModifierAura()				
	return "modifier_custom_terrorblade_metamorphosis_transform_aura" end

function modifier_custom_terrorblade_metamorphosis_transform_aura_applier:GetAuraEntityReject(hTarget)
	return hTarget == self:GetParent() or self:GetParent():IsIllusion() or 
	not hTarget:IsIllusion() or hTarget:GetPlayerOwnerID() ~= self:GetCaster():GetPlayerOwnerID() 
	or (hTarget:HasModifier("modifier_custom_terrorblade_reflection_invulnerability") and hTarget:GetName() ~= self:GetParent():GetName())
end






modifier_custom_terrorblade_metamorphosis_transform_aura = class({})

function modifier_custom_terrorblade_metamorphosis_transform_aura:IsHidden() return true end

function modifier_custom_terrorblade_metamorphosis_transform_aura:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	if not IsServer() then return end
	
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_terrorblade_metamorphosis_transform", {duration = self:GetAbility():GetSpecialValueFor("transformation_time")})
end

function modifier_custom_terrorblade_metamorphosis_transform_aura:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():RemoveModifierByName("modifier_custom_terrorblade_metamorphosis_transform")
	self:GetParent():RemoveModifierByName("modifier_custom_terrorblade_metamorphosis")
end








custom_terrorblade_terror_wave = class({})

function custom_terrorblade_terror_wave:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() then
        self:SetHidden(false)        
        if not self:IsTrained() then
            local ab = self:GetCaster():FindAbilityByName("custom_terrorblade_metamorphosis"):GetLevel()
            if ab > 0 then
                self:SetLevel(1)
            end
        end
    else
        self:SetHidden(true)
    end
end

function custom_terrorblade_terror_wave:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end


function custom_terrorblade_terror_wave:IsDisabledByDefault()	return true end
function custom_terrorblade_terror_wave:OnSpellStart(table)
if not IsServer() then return end
	self:GetCaster():EmitSound("Hero_Terrorblade.Metamorphosis.Scepter")


	local ability = self:GetCaster():FindAbilityByName("custom_terrorblade_metamorphosis")
	if ability then 


		if  self:GetCaster():HasModifier("modifier_terror_meta_legendary") then 
			

			if ability:GetToggleState() then 
  				ability:ToggleAbility()
  			end 

  			if self:GetCaster():HasModifier("modifier_custom_terrorblade_metamorphosis") then 
				self:GetCaster():RemoveModifierByName("modifier_custom_terrorblade_metamorphosis")
			end
  			ability:SetActivated(false)
		end


		ability:UseMeta(self:GetSpecialValueFor("scepter_meta_duration"), 0)
	end

  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_metamorphosis_fear_thinker", {duration = self:GetSpecialValueFor("scepter_spawn_delay")})
end









modifier_custom_terrorblade_metamorphosis_fear_thinker = class({})
function modifier_custom_terrorblade_metamorphosis_fear_thinker:IsHidden() return true end
function modifier_custom_terrorblade_metamorphosis_fear_thinker:IsPurgable() return false end
function modifier_custom_terrorblade_metamorphosis_fear_thinker:OnDestroy()
	if not IsServer() then return end
	

	self.fear_duration	= self:GetAbility():GetSpecialValueFor("fear_duration")
	self.radius			= self:GetAbility():GetSpecialValueFor("scepter_radius")
	self.speed			= self:GetAbility():GetSpecialValueFor("scepter_speed")


	self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_terrorblade/terrorblade_scepter.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(  self.speed, self.speed, self.speed ) )

	local pulse = self:GetCaster():AddNewModifier(
		self:GetCaster(), 
		self:GetAbility(), 
		"modifier_generic_ring_lua_terrorblade", 
		{
			end_radius = self.radius,
			speed = self.speed,
			target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		} 
	)

	pulse:SetCallback()

  Timers:CreateTimer(self.radius/self.speed,function()
     
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
        
        end)



end




modifier_custom_terrorblade_metamorphosis_start = class({})
function modifier_custom_terrorblade_metamorphosis_start:IsHidden() return false end
function modifier_custom_terrorblade_metamorphosis_start:IsPurgable() return false end
function modifier_custom_terrorblade_metamorphosis_start:GetTexture() return "buffs/meta_start" end
function modifier_custom_terrorblade_metamorphosis_start:OnCreated(table)
if not IsServer() then return end
self.particle_ally_fx = ParticleManager:CreateParticle("particles/items4_fx/bull_whip_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 

self.effect_cast = ParticleManager:CreateParticle( "particles/tb_meta_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(self.effect_cast)

end

function modifier_custom_terrorblade_metamorphosis_start:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
}
end
function modifier_custom_terrorblade_metamorphosis_start:GetModifierMoveSpeed_Absolute() return self:GetAbility().start_move  end
function modifier_custom_terrorblade_metamorphosis_start:GetModifierBaseAttackTimeConstant() return self:GetAbility().start_bva end


modifier_custom_terrorblade_metamorphosis_tracker = class({})
function modifier_custom_terrorblade_metamorphosis_tracker:IsHidden() return true end
function modifier_custom_terrorblade_metamorphosis_tracker:IsPurgable() return false end
function modifier_custom_terrorblade_metamorphosis_tracker:DeclareFunctions()
return 
{
}
end






modifier_custom_terrorblade_metamorphosis_lowhp_cd = class({})
function modifier_custom_terrorblade_metamorphosis_lowhp_cd:IsHidden() return false end
function modifier_custom_terrorblade_metamorphosis_lowhp_cd:IsPurgable() return false end
function modifier_custom_terrorblade_metamorphosis_lowhp_cd:RemoveOnDeath() return false end
function modifier_custom_terrorblade_metamorphosis_lowhp_cd:IsDebuff() return true end
function modifier_custom_terrorblade_metamorphosis_lowhp_cd:GetTexture() return "buffs/meta_lowhp" end
function modifier_custom_terrorblade_metamorphosis_lowhp_cd:OnCreated(table)
self.RemoveForDuel = true
end



modifier_custom_terrorblade_metamorphosis_lowhp = class({})
function modifier_custom_terrorblade_metamorphosis_lowhp:IsHidden() return false end
function modifier_custom_terrorblade_metamorphosis_lowhp:IsPurgable() return true end
function modifier_custom_terrorblade_metamorphosis_lowhp:GetTexture() return "buffs/meta_lowhp" end
function modifier_custom_terrorblade_metamorphosis_lowhp:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_custom_terrorblade_metamorphosis_lowhp:GetModifierIncomingDamage_Percentage()
return self:GetAbility().lowhp_reduce
end

function modifier_custom_terrorblade_metamorphosis_lowhp:OnCreated(table)
if not IsServer() then return end
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_swap_buff_overhead.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)
end



modifier_custom_terrorblade_metamorphosis_buff = class({})
function modifier_custom_terrorblade_metamorphosis_buff:IsHidden() return false end
function modifier_custom_terrorblade_metamorphosis_buff:IsPurgable() return false end
function modifier_custom_terrorblade_metamorphosis_buff:GetTexture() return "buffs/meta_start" end
function modifier_custom_terrorblade_metamorphosis_buff:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.particle = nil
self:SetStackCount(1)
self:StartIntervalThink(self:GetAbility().stack_interval)

end

function modifier_custom_terrorblade_metamorphosis_buff:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_custom_terrorblade_metamorphosis") then 
	if self:GetStackCount() < self:GetAbility().stack_max then 
		self:IncrementStackCount()
	end
else
	self:DecrementStackCount()
	if self:GetStackCount() < 1 then 
		self:Destroy()
	end
end


if (self:GetStackCount() == self:GetAbility().stack_max) and self.particle == nil then 
	self.particle = ParticleManager:CreateParticle("particles/econ/events/ti9/phase_boots_ti9.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 0,  self:GetParent():GetAbsOrigin())
end


if (self:GetStackCount() ~= self:GetAbility().stack_max) and self.particle ~= nil then 
	ParticleManager:ReleaseParticleIndex(self.particle)
	ParticleManager:DestroyParticle(self.particle, false)
	self.particle = nil
end




end

function modifier_custom_terrorblade_metamorphosis_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_custom_terrorblade_metamorphosis_buff:GetModifierMoveSpeedBonus_Percentage()
return (self:GetAbility().stack_move_init + self:GetAbility().stack_move_inc*self:GetParent():GetUpgradeStack("modifier_terror_meta_start"))*self:GetStackCount()/self:GetAbility().stack_max
end

function modifier_custom_terrorblade_metamorphosis_buff:GetModifierBaseAttack_BonusDamage()
return (self:GetAbility().stack_damage_init + self:GetAbility().stack_damage_inc*self:GetParent():GetUpgradeStack("modifier_terror_meta_start"))*self:GetStackCount()/self:GetAbility().stack_max
end


modifier_custom_terrorblade_metamorphosis_slow = class({})
function modifier_custom_terrorblade_metamorphosis_slow:IsHidden() return false end
function modifier_custom_terrorblade_metamorphosis_slow:IsPurgable() return true end
function modifier_custom_terrorblade_metamorphosis_slow:GetTexture() return "buffs/meta_slow" end
function modifier_custom_terrorblade_metamorphosis_slow:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end

function modifier_custom_terrorblade_metamorphosis_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_custom_terrorblade_metamorphosis_slow:GetModifierMoveSpeedBonus_Percentage() return
self:GetAbility().range_slow
end