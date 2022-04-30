 LinkLuaModifier("modifier_custom_necromastery_souls", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_necromastery_kills", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_custom_necromastery_tempo_track", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_custom_necromastery_tempo", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_custom_necromastery_legendary", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_custom_necromastery_heal_cd", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_custom_necromastery_attack_count", "abilities/shadow_fiend/custom_nevermore_necromastery", LUA_MODIFIER_MOTION_NONE) 

custom_nevermore_necromastery = class({})	

custom_nevermore_necromastery.shard_duration = 2
custom_nevermore_necromastery.shard_crit = 20
custom_nevermore_necromastery.shard_auto_crit = 190
custom_nevermore_necromastery.shard_cd = 3
custom_nevermore_necromastery.shard_soul = 1
custom_nevermore_necromastery.shard_fear = 0.3
custom_nevermore_necromastery.shard_fear_legendary = 0.5

custom_nevermore_necromastery.max_init = 0
custom_nevermore_necromastery.max_inc = 2


custom_nevermore_necromastery.damage_init = 0
custom_nevermore_necromastery.damage_inc = 1

custom_nevermore_necromastery.kills_max = 1

custom_nevermore_necromastery.tempo_duration_init = 2
custom_nevermore_necromastery.tempo_duration_inc = 3

custom_nevermore_necromastery.legendary_duration = 5
custom_nevermore_necromastery.legendary_cd = 40
custom_nevermore_necromastery.legendary_speed = 4
custom_nevermore_necromastery.legendary_crit = 130
custom_nevermore_necromastery.legendary_souls = 8

custom_nevermore_necromastery.heal_health = 30
custom_nevermore_necromastery.heal_heal = 0.01
custom_nevermore_necromastery.heal_cd = 30

custom_nevermore_necromastery.attack_init = 8
custom_nevermore_necromastery.attack_inc = 1 
custom_nevermore_necromastery.attack_damage = 5 
custom_nevermore_necromastery.attack_radius = 200



function custom_nevermore_necromastery:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_nevermore_souls_legendary") then 
	return self.legendary_cd
else 
	if self:GetCaster():HasShard() then 
		return self.shard_cd
	end
end

  return self.BaseClass.GetCooldown(self, iLevel)
end

function custom_nevermore_necromastery:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasShard() and not self:GetCaster():HasModifier("modifier_nevermore_souls_legendary") then 
 	return self:GetCaster():Script_GetAttackRange()
 end 

 return
end

function custom_nevermore_necromastery:GetIntrinsicModifierName()
	return "modifier_custom_necromastery_souls"
end

function custom_nevermore_necromastery:GetBehavior()
   if self:GetCaster():HasModifier("modifier_nevermore_souls_legendary") then
   		 return DOTA_ABILITY_BEHAVIOR_NO_TARGET
   else
 		 if self:GetCaster():HasShard() then
   				 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_ATTACK
   		 end
   end

 return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end


function custom_nevermore_necromastery:OnAbilityPhaseStart()

local caster = self:GetCaster()
local mod = caster:FindModifierByName("modifier_custom_necromastery_souls")

if not mod or mod:GetStackCount() < self.legendary_souls then 
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerID()), "CreateIngameErrorMessage", {message = "#necromastery_souls"})
 	return false
end
return true
end



function custom_nevermore_necromastery:OnSpellStart()

local caster = self:GetCaster()


caster:EmitSound("Sf.Souls_Legendary")
local duration = self.legendary_duration 

if caster:HasShard() then 
	duration = duration + self.shard_duration
end

caster:AddNewModifier(caster, self, "modifier_custom_necromastery_legendary", {duration = duration})

end


function custom_nevermore_necromastery:GetProjectileName()
local mod = self:GetCaster():FindModifierByName("modifier_custom_necromastery_souls")
if mod:GetStackCount() > 0 then 
    return "particles/units/heroes/hero_nevermore/sf_necromastery_attack.vpcf"
end

end


function custom_nevermore_necromastery:OnOrbFire(params)
if not self:GetCaster().start_crit or self:GetCaster().start_crit == false  then return end 
	
	self:GetCaster():MoveToTargetToAttack(params.target)

	local mod = self:GetCaster():FindModifierByName("modifier_custom_necromastery_souls")

	self:GetCaster().start_crit = false
  	local tempo = 0 

 	 for _,track in pairs(self:GetCaster():FindAllModifiers()) do
	 	if track:GetName() == "modifier_custom_necromastery_tempo_track"  then 
				tempo = tempo + 1
				track:Destroy()
				break 
  	 	end
 	 end

 	if tempo == 0 then 
 		mod:DecrementStackCount()
 	 end

 	self:GetCaster().crit = false
 	self:UseResources(false, false, true)

end




function custom_nevermore_necromastery:ProcsMagicStick()
	return false
end



---------------------------------------------------------------------------------------------------------------------------------------



modifier_custom_necromastery_souls = class({})



function modifier_custom_necromastery_souls:OnAttack( params )
	-- if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end

	-- register attack if being cast and fully castable
	if self:ShouldLaunch( params.target ) then
		-- use mana and cd

		-- record the attack
		self.records[params.record] = true

		-- run OrbFire script if available
		if self.ability.OnOrbFire then

		 self.ability:OnOrbFire( params ) 

		


		end
	end

	self.cast = false
end


function modifier_custom_necromastery_souls:OnAttackCancelled(params)
if self:GetParent() ~= params.attacker then return end
if self:GetParent().start_crit == false then return end
	self:GetParent().start_crit = false
 	self:GetCaster().crit = false
end



function modifier_custom_necromastery_souls:OnAttackRecordDestroy( params )
	-- destroy attack record
	self.records[params.record] = nil
end

function modifier_custom_necromastery_souls:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if params.ability then
		-- if this ability, cast
		if params.ability==self:GetAbility() then
			self.cast = true
			if params.order_type == DOTA_UNIT_ORDER_CAST_TARGET and self:GetStackCount() > 0 and not self:GetParent():HasModifier("modifier_nevermore_souls_legendary ") then 

			 self:GetParent().crit = true
			
			end
			return
		end


		-- if casting other ability that cancel channel while casting this ability, turn off
		local pass = false
		local behavior = tonumber( tostring( params.ability:GetBehavior() ))
		if self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL ) or 
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT ) or
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL )
		then
			local pass = true -- do nothing
		end

		if self.cast and (not pass) then
			self.cast = false
		end
	else
		-- if ordering something which cancel channel, turn off
		if self.cast then
			if self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_POSITION ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_TARGET )	or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_MOVE ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_TARGET ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_STOP ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_HOLD_POSITION )
			then
				self.cast = false
			end
		end
	end
end

function modifier_custom_necromastery_souls:GetModifierProjectileName()
if not self:GetParent():IsRealHero() then return end
if not self.ability.GetProjectileName then return end
if self:GetParent():HasModifier("modifier_custom_necromastery_legendary") then return "particles/units/heroes/hero_nevermore/sf_necromastery_attack.vpcf" end


	if self:ShouldLaunch( self:GetCaster():GetAggroTarget() ) then
		return self.ability:GetProjectileName()
	end
end

--------------------------------------------------------------------------------
-- Helper
function modifier_custom_necromastery_souls:ShouldLaunch( target )
	-- check autocast
	if self.ability:GetAutoCastState() then
		-- filter whether target is valid
		if self.ability.CastFilterResultTarget~=CDOTA_Ability_Lua.CastFilterResultTarget then
			-- check if ability has custom target cast filter
			if self.ability:CastFilterResultTarget( target )==UF_SUCCESS then
				self.cast = true
			end
		else
			local nResult = UnitFilter(
				target,
				self.ability:GetAbilityTargetTeam(),
				self.ability:GetAbilityTargetType(),
				self.ability:GetAbilityTargetFlags(),
				self:GetCaster():GetTeamNumber()
			)
			if nResult == UF_SUCCESS then
				self.cast = true
			end
		end
	end

	if self.cast and self.ability:IsFullyCastable() and (not self:GetParent():IsSilenced()) then
		return true
	end

	return false
end


function modifier_custom_necromastery_souls:FlagExist(a,b)--Bitwise Exist
	local p,c,d=1,0,b
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c==d
end







function modifier_custom_necromastery_souls:OnCreated()

	self.cast = false
	self.records = {}

	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_soul_creep = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"



	self.damage_per_soul = self.ability:GetSpecialValueFor("necromastery_damage_per_soul")
	self.base_max_souls = self.ability:GetSpecialValueFor("necromastery_max_souls")
	self.scepter_max_souls = self.ability:GetSpecialValueFor("necromastery_max_souls_scepter")
	self.max_souls = self.base_max_souls
	self.souls_lost_on_death_pct = self.ability:GetSpecialValueFor("necromastery_soul_release")

	if IsServer() then
		self:StartIntervalThink(0.1)
	end

end




function modifier_custom_necromastery_souls:GetHeroEffectName()
	return "particles/units/heroes/hero_nevermore/nevermore_souls_hero_effect.vpcf"
end

function modifier_custom_necromastery_souls:OnIntervalThink()
	self:RefreshSoulsMax()
end

function modifier_custom_necromastery_souls:RefreshSoulsMax()

	self.max_souls = self.ability:GetSpecialValueFor("necromastery_max_souls")

	local bonus = 0 
	if self.caster:HasScepter() then
		bonus = self.scepter_max_souls
	end

	if self.caster:HasModifier("modifier_nevermore_souls_max") then 
		bonus = bonus + (self:GetAbility().max_init + self:GetAbility().max_inc*self.caster:GetUpgradeStack("modifier_nevermore_souls_max"))
	end 

	if self.caster:HasModifier("modifier_nevermore_souls_kills") then 
		bonus = bonus + self:GetAbility().kills_max*self.caster:GetUpgradeStack("modifier_custom_necromastery_kills")
	end 

	self.max_souls = self.max_souls + bonus

end


function modifier_custom_necromastery_souls:OnRefresh()
	self:OnCreated()
end



function modifier_custom_necromastery_souls:DestroyOnExpire()
	return false
end


function modifier_custom_necromastery_souls:GetCritDamage() return self:GetAbility().shard_auto_crit end


function modifier_custom_necromastery_souls:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP,



		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_EVENT_ON_ATTACK_CANCELLED,

		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,

		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end





function modifier_custom_necromastery_souls:GetModifierPreAttack_CriticalStrike( params )

if self:GetParent():HasModifier("modifier_nevermore_souls_legendary") then return end

if self:GetCaster():HasShard() and self:GetStackCount() > 0 then 
	self:GetParent().start_crit = true 

 	if ((self:GetAbility():IsFullyCastable() and self:GetAbility():GetAutoCastState() == true) 
	or (self:GetParent().crit and self:GetParent().crit == true )) then 

 			self.record = params.record
  			return self:GetAbility().shard_auto_crit

    end

end

end




function modifier_custom_necromastery_souls:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.target:IsBuilding() then return end

if self.record ~= nil and params.record == self.record and not params.target:IsMagicImmune() then 
	params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_nevermore_requiem_fear", {duration = (1 - params.target:GetStatusResistance())*self:GetAbility().shard_fear})
end




if self:GetParent():HasModifier("modifier_nevermore_souls_tempo") and self:GetParent():IsAlive() and self:GetStackCount() >= self.max_souls then

	local duration = self:GetAbility().tempo_duration_init + self:GetAbility().tempo_duration_inc*self:GetParent():GetUpgradeStack("modifier_nevermore_souls_tempo")

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_necromastery_tempo", {duration = duration})
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_necromastery_tempo_track", {duration = duration})


	local soul_projectile = {Target = self:GetParent(),Source = params.target, Ability = self:GetAbility(),EffectName = self.particle_soul_creep,bDodgeable = false,bProvidesVision = false,iMoveSpeed = self.soul_projectile_speed,iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION}
	ProjectileManager:CreateTrackingProjectile(soul_projectile)

end





if params.target:IsMagicImmune() then return end

if not self:GetParent():HasModifier("modifier_nevermore_souls_attack") then return end
if self:GetParent():PassivesDisabled() then return end

local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_necromastery_attack_count", {})
if mod then 
	local attack = self:GetAbility().attack_init - self:GetAbility().attack_inc*self:GetParent():GetUpgradeStack("modifier_nevermore_souls_attack")
	if mod:GetStackCount() >= attack then 
		mod:Destroy()
		local damage = self:GetAbility().attack_damage*self:GetStackCount()
		params.target:EmitSound("Sf.Souls_Attack")

		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self:GetAbility().attack_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

		for _,enemy in ipairs(enemies) do
			if not enemy:IsMagicImmune() then 
				ApplyDamage({ victim = enemy, attacker = self:GetParent(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
    			SendOverheadEventMessage(enemy, 4, enemy, damage, nil)
   			end
   		end


   		local particle = ParticleManager:CreateParticle( "particles/sf_souls_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target )
    
   		ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin())
    	ParticleManager:ReleaseParticleIndex( particle )
    	
	end
end
end





function modifier_custom_necromastery_souls:GetModifierPreAttack_BonusDamage()
	local stacks = self:GetStackCount()
	return (self.damage_per_soul + self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetParent():GetUpgradeStack("modifier_nevermore_souls_damage"))* stacks 
end

function modifier_custom_necromastery_souls:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end
if not self:GetParent():HasModifier("modifier_nevermore_souls_heal") then return end
if params.unit ~= self:GetParent() then return end
if self:GetParent():GetHealthPercent() > self:GetAbility().heal_health then return end
if self:GetParent():HasModifier("modifier_custom_necromastery_heal_cd") then return end
if self:GetParent():HasModifier("modifier_death") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_necromastery_heal_cd", {duration = self:GetAbility().heal_cd})

local heal = self:GetParent():GetMaxHealth()*(self:GetAbility().heal_heal)*self:GetStackCount()

self:GetParent():Heal(heal, self:GetParent())
self:GetParent():EmitSound("Sf.Souls_Heal")        
SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)
local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

local particle_aoe_fx = ParticleManager:CreateParticle("particles/sf_souls_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle_aoe_fx, 0,  self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(150, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_aoe_fx)  



end

function modifier_custom_necromastery_souls:OnTooltip()
local max_souls = self.ability:GetSpecialValueFor("necromastery_max_souls")

local bonus = 0 

if self:GetParent():HasScepter() then
	bonus = self.scepter_max_souls
end

if self:GetParent():HasModifier("modifier_nevermore_souls_max") then 
	bonus = bonus + (self:GetAbility().max_init + self:GetAbility().max_inc*self:GetParent():GetUpgradeStack("modifier_nevermore_souls_max"))
end 

if self:GetParent():HasModifier("modifier_nevermore_souls_kills") then 
	bonus = bonus +  self:GetAbility().kills_max*self.caster:GetUpgradeStack("modifier_custom_necromastery_kills")
end 

max_souls = max_souls + bonus


return max_souls 
end


function modifier_custom_necromastery_souls:OnDeath(keys)
if not IsServer() then return end
		local target = keys.unit
		local attacker = keys.attacker

		if self.ability:IsStolen() then
			return nil
		end


		if self.caster == attacker and self.caster ~= target then

			if target:IsIllusion() then
				return nil
			end

			if target:IsTempestDouble() then
				return nil
			end

			if target:IsBuilding() then
				return nil
			end

			if target:IsRealHero() and self.caster:HasModifier("modifier_nevermore_souls_kills") and not target:IsReincarnating() then 
				self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_custom_necromastery_kills", {})
			end
	
			local ability = self:GetAbility()

			local soul_count = 1
			if self:GetParent():HasShard() then 
				soul_count = 2
			end


			local mod_tempo = self.caster:FindModifierByName("modifier_custom_necromastery_tempo")
			local tempo_souls = 0
			if mod_tempo then 
				tempo_souls = mod_tempo:GetStackCount()
			end


			self:RefreshSoulsMax()



			local incr_souls =  (self.max_souls) - (self:GetStackCount() - tempo_souls)


			if incr_souls > 0 then 
				self:SetStackCount(self:GetStackCount() + math.min(incr_souls, soul_count))
			end

			

			local soul_projectile = {Target = self.caster,Source = target, Ability = self.ability,EffectName = self.particle_soul_creep,bDodgeable = false,bProvidesVision = false,iMoveSpeed = self.soul_projectile_speed,iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION}
			ProjectileManager:CreateTrackingProjectile(soul_projectile)



		end
		
		if self:GetParent() == target and not target:IsIllusion() and  not self:GetParent():IsReincarnating() then
			local mod = self.caster:FindModifierByName("modifier_custom_necromastery_tempo")
			if mod then 
				mod:Destroy()
				for _,track in pairs(self.caster:FindAllModifiers()) do
					if track:GetName() == "modifier_custom_necromastery_tempo_track" then 
						track:Destroy()
					end
				end
			end
			local stacks = self:GetStackCount()
			local stacks_lost = math.floor(stacks * (self.souls_lost_on_death_pct))

			if not self:GetParent():HasModifier("modifier_final_duel") then 
				self:SetStackCount(stacks - stacks_lost)
			end
			
			self.requiem_ability = "custom_nevermore_requiem"
			if self.caster:HasAbility(self.requiem_ability) then
				local requiem_ability_handler = self.caster:FindAbilityByName(self.requiem_ability)
				if requiem_ability_handler then
					if requiem_ability_handler:GetLevel() >= 1 then
						requiem_ability_handler:OnSpellStart(true)
					end
				end
			end


		end


end



function modifier_custom_necromastery_souls:RemoveOnDeath() return false end
function modifier_custom_necromastery_souls:IsHidden() return false end
function modifier_custom_necromastery_souls:IsPurgable() return false end
function modifier_custom_necromastery_souls:IsDebuff() return false end
function modifier_custom_necromastery_souls:AllowIllusionDuplicate() return true end



modifier_custom_necromastery_kills = class({})

function modifier_custom_necromastery_kills:IsHidden() return false end
function modifier_custom_necromastery_kills:IsPurgable() return false end
function modifier_custom_necromastery_kills:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end
function modifier_custom_necromastery_kills:OnRefresh(table)
if not  IsServer() then return end
self:IncrementStackCount()
end
function modifier_custom_necromastery_kills:RemoveOnDeath() return false end
function modifier_custom_necromastery_kills:GetTexture() return "buffs/souls_kills" end

function modifier_custom_necromastery_kills:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}

end
function modifier_custom_necromastery_kills:OnTooltip()
return self:GetStackCount()
end
function modifier_custom_necromastery_kills:OnTooltip2()
return
self:GetAbility().kills_max*self:GetStackCount()
end

modifier_custom_necromastery_tempo = class({})

function modifier_custom_necromastery_tempo:IsHidden() return false end
function modifier_custom_necromastery_tempo:IsPurgable() return false end
function modifier_custom_necromastery_tempo:GetTexture() return "buffs/souls_tempo" end
function modifier_custom_necromastery_tempo:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_custom_necromastery_tempo:OnTooltip()
return self:GetStackCount()
end
function modifier_custom_necromastery_tempo:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end
function modifier_custom_necromastery_tempo:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end



modifier_custom_necromastery_tempo_track = class({})

function modifier_custom_necromastery_tempo_track:IsHidden() return true end
function modifier_custom_necromastery_tempo_track:IsPurgable() return false end
function modifier_custom_necromastery_tempo_track:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end


function modifier_custom_necromastery_tempo_track:OnCreated(table)
if not IsServer() then return end
	local souls = self:GetParent():FindModifierByName("modifier_custom_necromastery_souls")
	if souls then 
		souls:IncrementStackCount()
	end
end
function modifier_custom_necromastery_tempo_track:OnDestroy()
  if not IsServer() then return end
  
  local tempo = self:GetParent():FindModifierByNameAndCaster("modifier_custom_necromastery_tempo", self:GetCaster())
  
  if tempo then
    tempo:DecrementStackCount()
    if tempo:GetStackCount() == 0 then 
    	tempo:Destroy()
    end
  end

  local souls = self:GetParent():FindModifierByName("modifier_custom_necromastery_souls")
	if souls then 
		souls:DecrementStackCount()
   end
end


modifier_custom_necromastery_legendary = class({})
function modifier_custom_necromastery_legendary:GetTexture() return "buffs/souls_active" end
function modifier_custom_necromastery_legendary:IsHidden() return false end
function modifier_custom_necromastery_legendary:IsPurgable() return false end
function modifier_custom_necromastery_legendary:OnCreated(table)
if not IsServer() then return end

self.fear_attack = true 

self.wings_particle = ParticleManager:CreateParticle("particles/sf_wings.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
local mod = self:GetParent():FindModifierByName("modifier_custom_necromastery_souls")

self.hands = ParticleManager:CreateParticle("particles/sf_hands_.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
ParticleManager:SetParticleControlEnt(self.hands,0,self:GetParent(),PATTACH_ABSORIGIN_FOLLOW,"follow_origin",self:GetParent():GetOrigin(),false)
self:AddParticle(self.hands,true,false,0,false,false)
 	
local n = 0
if mod then 
	n = mod:GetStackCount()
end
self.effect = ParticleManager:CreateParticle("particles/sf_souls_souls.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl(self.effect, 1, Vector(n, 0, 0))

 
Timers:CreateTimer(4,function()
	ParticleManager:DestroyParticle(self.wings_particle, false)
	ParticleManager:ReleaseParticleIndex(self.wings_particle)   
end)

end

function modifier_custom_necromastery_legendary:OnDestroy()
if not IsServer() then return end

ParticleManager:DestroyParticle(self.effect, false)
ParticleManager:ReleaseParticleIndex(self.effect)

ParticleManager:DestroyParticle(self.hands, false)
ParticleManager:ReleaseParticleIndex(self.hands)

local mod = self:GetParent():FindModifierByName("modifier_custom_necromastery_souls")


local tempo = 0 

for _,track in pairs(self:GetParent():FindAllModifiers()) do
	if track:GetName() == "modifier_custom_necromastery_tempo_track" and tempo < self:GetAbility().legendary_souls then 
		tempo = tempo + 1
		track:Destroy()
	end
end

local normal = self:GetAbility().legendary_souls - tempo

if not mod or normal == 0 then return end 

if mod:GetStackCount() <= normal then 
	mod:SetStackCount(0)
else 
	mod:SetStackCount(mod:GetStackCount() - normal)
end


end



function modifier_custom_necromastery_legendary:GetCritDamage() 
local upgrade = 0
if self:GetCaster():HasShard() then 
	upgrade = self:GetAbility().shard_crit
end

  return self:GetAbility().legendary_crit + upgrade
end
function modifier_custom_necromastery_legendary:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	MODIFIER_PROPERTY_PROJECTILE_NAME,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_custom_necromastery_legendary:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasShard() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if self.fear_attack == false then return end

self.fear_attack = false
if not params.target:IsMagicImmune() then
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_nevermore_requiem_fear", {duration = (1 - params.target:GetStatusResistance())*self:GetAbility().shard_fear_legendary})
end


end

function modifier_custom_necromastery_legendary:GetModifierAttackSpeedBonus_Constant()
 return self:GetParent():GetUpgradeStack("modifier_custom_necromastery_souls")*self:GetAbility().legendary_speed
end

function modifier_custom_necromastery_legendary:GetModifierProjectileName()
return "particles/units/heroes/hero_nevermore/sf_necromastery_attack.vpcf"
end

function modifier_custom_necromastery_legendary:OnTooltip()
local upgrade = 0
if self:GetCaster():HasShard() then 
	upgrade = self:GetAbility().shard_crit
end

  return self:GetAbility().legendary_crit + upgrade
end

function modifier_custom_necromastery_legendary:GetModifierPreAttack_CriticalStrike( params )
local upgrade = 0
if self:GetCaster():HasShard() then 
	upgrade = self:GetAbility().shard_crit
end

  return self:GetAbility().legendary_crit + upgrade
end




modifier_custom_necromastery_heal_cd = class({})
function modifier_custom_necromastery_heal_cd:IsHidden() return false end
function modifier_custom_necromastery_heal_cd:IsPurgable() return false end
function modifier_custom_necromastery_heal_cd:IsDebuff() return true end
function modifier_custom_necromastery_heal_cd:RemoveOnDeath() return false end
function modifier_custom_necromastery_heal_cd:GetTexture() return "buffs/souls_heal_cd" end
function modifier_custom_necromastery_heal_cd:OnCreated(table)
	self.RemoveForDuel = true
end

modifier_custom_necromastery_attack_count = class({})
function modifier_custom_necromastery_attack_count:IsHidden() return false end
function modifier_custom_necromastery_attack_count:IsPurgable() return false end
function modifier_custom_necromastery_attack_count:RemoveOnDeath() return false end
function modifier_custom_necromastery_attack_count:GetTexture() return "buffs/souls_attack" end


function modifier_custom_necromastery_attack_count:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(1)
end
function modifier_custom_necromastery_attack_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_custom_necromastery_attack_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end
function modifier_custom_necromastery_attack_count:OnTooltip()
local attack = self:GetAbility().attack_init - self:GetAbility().attack_inc*self:GetParent():GetUpgradeStack("modifier_nevermore_souls_attack")

return attack

end

function modifier_custom_necromastery_attack_count:OnTooltip2()

return
self:GetParent():GetUpgradeStack("modifier_custom_necromastery_souls")*self:GetAbility().attack_damage
end