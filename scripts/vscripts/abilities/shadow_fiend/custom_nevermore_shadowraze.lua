LinkLuaModifier("modifier_custom_shadowraze_debuff", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_combo", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_slow", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_silence", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_speedmax", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_burn", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_burn_tracker", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)

custom_nevermore_shadowraze_close =  class({})

custom_nevermore_shadowraze_close.cd_init = 0.5
custom_nevermore_shadowraze_close.cd_inc = 0.5

custom_nevermore_shadowraze_close.damage_init = 0
custom_nevermore_shadowraze_close.damage_inc = 30

custom_nevermore_shadowraze_close.legendary_timer = 3

custom_nevermore_shadowraze_close.duration = 0.8

custom_nevermore_shadowraze_close.stack_duration = 60	
custom_nevermore_shadowraze_close.stack_damage = 20	

custom_nevermore_shadowraze_close.speed_init = 5
custom_nevermore_shadowraze_close.speed_inc = 5
custom_nevermore_shadowraze_close.speed_duration = 5
custom_nevermore_shadowraze_close.speed_heal_init = 0.03
custom_nevermore_shadowraze_close.speed_heal_inc = 0.03

custom_nevermore_shadowraze_close.burn_init = 0.10
custom_nevermore_shadowraze_close.burn_inc = 0.10
custom_nevermore_shadowraze_close.burn_duration = 5







custom_nevermore_shadowraze_far = class({})


custom_nevermore_shadowraze_far.cd_init = 0.5
custom_nevermore_shadowraze_far.cd_inc = 0.5

custom_nevermore_shadowraze_far.damage_init = 0
custom_nevermore_shadowraze_far.damage_inc = 30

custom_nevermore_shadowraze_far.legendary_timer = 3

custom_nevermore_shadowraze_far.duration = 2
custom_nevermore_shadowraze_far.slow = -50	

custom_nevermore_shadowraze_far.stack_duration = 60	
custom_nevermore_shadowraze_far.stack_damage = 20	

custom_nevermore_shadowraze_far.speed_init = 5
custom_nevermore_shadowraze_far.speed_inc = 5
custom_nevermore_shadowraze_far.speed_duration = 5
custom_nevermore_shadowraze_far.speed_heal_init = 0.03
custom_nevermore_shadowraze_far.speed_heal_inc = 0.03



custom_nevermore_shadowraze_far.burn_init = 0
custom_nevermore_shadowraze_far.burn_inc = 0.15
custom_nevermore_shadowraze_far.burn_duration = 5



custom_nevermore_shadowraze_medium = class({})

custom_nevermore_shadowraze_medium.cd_init = 0.5
custom_nevermore_shadowraze_medium.cd_inc = 0.5

custom_nevermore_shadowraze_medium.damage_init = 0
custom_nevermore_shadowraze_medium.damage_inc = 30

custom_nevermore_shadowraze_medium.legendary_timer = 3

custom_nevermore_shadowraze_medium.duration = 1.5

custom_nevermore_shadowraze_medium.stack_duration = 60	
custom_nevermore_shadowraze_medium.stack_damage = 20	

custom_nevermore_shadowraze_medium.speed_init = 5
custom_nevermore_shadowraze_medium.speed_inc = 5
custom_nevermore_shadowraze_medium.speed_duration = 5
custom_nevermore_shadowraze_medium.speed_heal_init = 0.03
custom_nevermore_shadowraze_medium.speed_heal_inc = 0.03


custom_nevermore_shadowraze_medium.burn_init = 0
custom_nevermore_shadowraze_medium.burn_inc = 0.15
custom_nevermore_shadowraze_medium.burn_duration = 5





function custom_nevermore_shadowraze_close:GetCooldown(iLevel)
local upgrade_cooldown = 0 

if self:GetCaster():HasModifier("modifier_nevermore_raze_cd") then 
  upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_raze_cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
end



function custom_nevermore_shadowraze_close:GetAbilityTextureName()
   return "nevermore_shadowraze1"
end

function custom_nevermore_shadowraze_close:IsHiddenWhenStolen()
	return false
end

function custom_nevermore_shadowraze_close:GetManaCost(level)
	local caster = self:GetCaster()
	local manacost = self.BaseClass.GetManaCost(self, level)
	return manacost
end


function custom_nevermore_shadowraze_close:OnUpgrade()
	local caster = self:GetCaster()
	UpgradeShadowRazes(caster, self)
end



function custom_nevermore_shadowraze_close:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response = {"nevermore_nev_ability_shadow_07", "nevermore_nev_ability_shadow_18", "nevermore_nev_ability_shadow_21"}
	local sound_raze = "Hero_Nevermore.Shadowraze"
	caster:EmitSound(sound_raze)

	-- Ability specials
	local raze_radius = ability:GetSpecialValueFor("shadowraze_radius")
	local raze_distance = ability:GetSpecialValueFor("shadowraze_range")



	local raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * raze_distance

	CastShadowRazeOnPoint(caster, ability, raze_point, raze_radius)

end


------------------------------------
--     SHADOW RAZE (MEDIUM)       --
------------------------------------



function custom_nevermore_shadowraze_medium:GetCooldown(iLevel)
local upgrade_cooldown = 0 

if self:GetCaster():HasModifier("modifier_nevermore_raze_cd") then 
  upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_raze_cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
end

function custom_nevermore_shadowraze_medium:GetAbilityTextureName()
   return "nevermore_shadowraze2"
end

function custom_nevermore_shadowraze_medium:IsHiddenWhenStolen()
	return false
end

function custom_nevermore_shadowraze_medium:GetManaCost(level)
	local caster = self:GetCaster()
	local manacost = self.BaseClass.GetManaCost(self, level)
	return manacost
end


function custom_nevermore_shadowraze_medium:OnUpgrade()
	local caster = self:GetCaster()
	UpgradeShadowRazes(caster, self)
end



function custom_nevermore_shadowraze_medium:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response = {"nevermore_nev_ability_shadow_08", "nevermore_nev_ability_shadow_20", "nevermore_nev_ability_shadow_22"}
	local sound_raze = "Hero_Nevermore.Shadowraze"
	caster:EmitSound(sound_raze)

	-- Ability specials
	local raze_radius = ability:GetSpecialValueFor("shadowraze_radius")
	local raze_distance = ability:GetSpecialValueFor("shadowraze_range")


	local raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * raze_distance

	CastShadowRazeOnPoint(caster, ability, raze_point, raze_radius)


end

------------------------------------
--       SHADOW RAZE (FAR)        --
------------------------------------




function custom_nevermore_shadowraze_far:GetCooldown(iLevel)
local upgrade_cooldown = 0 

if self:GetCaster():HasModifier("modifier_nevermore_raze_cd") then 
  upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_raze_cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
end

function custom_nevermore_shadowraze_far:GetAbilityTextureName()
   return "nevermore_shadowraze3"
end

function custom_nevermore_shadowraze_far:IsHiddenWhenStolen()
	return false
end

function custom_nevermore_shadowraze_far:GetManaCost(level)
	local caster = self:GetCaster()
	local manacost = self.BaseClass.GetManaCost(self, level)

	return manacost
end



function custom_nevermore_shadowraze_far:OnUpgrade()
	local caster = self:GetCaster()
	UpgradeShadowRazes(caster, self)
end

function custom_nevermore_shadowraze_far:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response = {"nevermore_nev_ability_shadow_11", "nevermore_nev_ability_shadow_19", "nevermore_nev_ability_shadow_23"}
	local sound_raze = "Hero_Nevermore.Shadowraze"
	caster:EmitSound(sound_raze)
	local raze_radius = ability:GetSpecialValueFor("shadowraze_radius")
	local raze_distance = ability:GetSpecialValueFor("shadowraze_range")

	local raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * raze_distance

	CastShadowRazeOnPoint(caster, ability, raze_point, raze_radius)


end


-------------------------
-- Shadowraze Handlers --
-------------------------


function CastShadowRazeOnPoint(caster, ability, point, radius)

	local particle_raze = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"

	if caster:GetModelName() == "models/heroes/shadow_fiend/shadow_fiend_arcana.vmdl" then 
		particle_raze = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf"
	end

	local modifier = ""
	local duration = ability.duration 
	local sound = ""
	if ability:GetAbilityName() == "custom_nevermore_shadowraze_close" then 
	   modifier = "modifier_nevermore_requiem_fear"
	   sound = "Sf.Raze_Stun"
	end

	if ability:GetAbilityName() == "custom_nevermore_shadowraze_medium" then 
	   modifier = "modifier_custom_shadowraze_silence"
	   sound = "Sf.Raze_Silence"
	end

	if ability:GetAbilityName() == "custom_nevermore_shadowraze_far" then 
	   modifier = "modifier_custom_shadowraze_slow"
	   sound = "Sf.Raze_Slow"
	end



	local particle_raze_fx = ParticleManager:CreateParticle(particle_raze, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_raze_fx, 0, point)
	ParticleManager:SetParticleControl(particle_raze_fx, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_raze_fx)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									  point,
									  nil,
									  radius,
									  DOTA_UNIT_TARGET_TEAM_ENEMY,
									  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
									  DOTA_UNIT_TARGET_FLAG_NONE,
									  FIND_ANY_ORDER,
									  false)


	if #enemies > 0 then

		if (caster:HasModifier("modifier_nevermore_raze_legendary") or caster:HasModifier("modifier_nevermore_raze_speed")) 
			and not ((#enemies== 1) and ((enemies[1]:IsBuilding() or enemies[1]:GetUnitName() == "npc_roshan_custom") )) then 	
			caster:AddNewModifier(caster, ability, "modifier_custom_shadowraze_combo", {duration = ability.legendary_timer})
		end

		
	end

	for _,enemy in pairs(enemies) do
		if not enemy:IsMagicImmune()  then
			if caster:HasModifier("modifier_nevermore_raze_combocd") and not enemy:IsBuilding() then
				enemy:AddNewModifier(caster, ability, modifier, {duration = duration * (1 - enemy:GetStatusResistance())})
				enemy:EmitSound(sound)
			end	
		ApplyShadowRazeDamage(caster, ability, enemy)
		end
		
	end


end

function ApplyShadowRazeDamage(caster, ability, enemy)


	-- Ability specials
	local damage = ability:GetSpecialValueFor("shadowraze_damage")
	local stack_bonus_damage = ability:GetSpecialValueFor("stack_bonus_damage")
	local duration = ability:GetSpecialValueFor("duration") + ability.stack_duration*caster:GetUpgradeStack("modifier_nevermore_raze_duration")
	local modifier_debuff = "modifier_custom_shadowraze_debuff"
	local debuff_boost = 0
	local bonus = 0
	bonus = ability.damage_init + ability.damage_inc*caster:GetUpgradeStack("modifier_nevermore_raze_damage")

	if enemy:HasModifier(modifier_debuff) then
		debuff_boost	= enemy:FindModifierByName(modifier_debuff):GetStackCount() * (stack_bonus_damage + ability.stack_damage*caster:GetUpgradeStack("modifier_nevermore_raze_duration") )

	end

	damage 			= damage + debuff_boost + bonus 
	
	if enemy:IsBuilding() then 
		damage = damage*ability:GetSpecialValueFor("building_damage")/100
	end 

	local damageTable = {victim = enemy,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						attacker = caster,
						ability = ability
						}

	local actualy_damage = ApplyDamage(damageTable)    
	
	if caster:HasModifier("modifier_nevermore_raze_burn") and not enemy:IsBuilding() then 
		local burn = (damage*(ability.burn_init + ability.burn_inc*caster:GetUpgradeStack("modifier_nevermore_raze_burn")))/ability.burn_duration
	
		enemy:AddNewModifier(caster, ability, "modifier_custom_shadowraze_burn", {duration = ability.burn_duration, damage = burn})
		enemy:AddNewModifier(caster, ability, "modifier_custom_shadowraze_burn_tracker", {duration = ability.burn_duration})
	end



	-- Apply a debuff stack that causes shadowrazes to do more damage
	if not enemy:HasModifier(modifier_debuff) and not enemy:IsBuilding() then
		enemy:AddNewModifier(caster, ability, modifier_debuff, {duration = duration * (1 - enemy:GetStatusResistance())})
	end
	
	local modifier_debuff_counter = enemy:FindModifierByName(modifier_debuff)
	if modifier_debuff_counter then
		modifier_debuff_counter:IncrementStackCount()
		modifier_debuff_counter:ForceRefresh()
	end
end

function UpgradeShadowRazes(caster, ability)
	local raze_close = "custom_nevermore_shadowraze_close"
	local raze_medium = "custom_nevermore_shadowraze_medium"
	local raze_far = "custom_nevermore_shadowraze_far"

	-- Get handles
	local raze_close_handler
	local raze_medium_handler
	local raze_far_handler

	if caster:HasAbility(raze_close) then
		raze_close_handler = caster:FindAbilityByName(raze_close)
	end

	if caster:HasAbility(raze_medium) then
		raze_medium_handler = caster:FindAbilityByName(raze_medium)
	end

	if caster:HasAbility(raze_far) then
		raze_far_handler = caster:FindAbilityByName(raze_far)
	end

	-- Get the level to compare
	local leveled_ability_level = ability:GetLevel()

	if raze_close_handler and raze_close_handler:GetLevel() < leveled_ability_level then
		raze_close_handler:SetLevel(leveled_ability_level)
	end

	if raze_medium_handler and raze_medium_handler:GetLevel() < leveled_ability_level then
		raze_medium_handler:SetLevel(leveled_ability_level)
	end

	if raze_far_handler and raze_far_handler:GetLevel() < leveled_ability_level then
		raze_far_handler:SetLevel(leveled_ability_level)
	end
end



-- Modifier to track increasing raze damage
modifier_custom_shadowraze_debuff = class ({})

function modifier_custom_shadowraze_debuff:IsDebuff() return true end
function modifier_custom_shadowraze_debuff:IsPurgable()
	if self:GetCaster():HasModifier("modifier_nevermore_raze_duration") then 
return false else
return true end	
end

function modifier_custom_shadowraze_debuff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_custom_shadowraze_debuff:OnTooltip()
return self:GetStackCount() * ( self:GetAbility():GetSpecialValueFor("stack_bonus_damage")  + self:GetAbility().stack_damage*self:GetCaster():GetUpgradeStack("modifier_nevermore_raze_duration") )


end
function modifier_custom_shadowraze_debuff:OnCreated(table)
	self.RemoveForDuel = true
end





modifier_custom_shadowraze_combo = class({})
function modifier_custom_shadowraze_combo:IsHidden() return false end
function modifier_custom_shadowraze_combo:IsPurgable() return false end

function modifier_custom_shadowraze_combo:OnCreated(table)
if not IsServer() then return end
	self:SetStackCount(1)
end

function modifier_custom_shadowraze_combo:OnRefresh(table)
if not IsServer() then return end


if self:GetStackCount() < 3 then 
	self:IncrementStackCount()
	
	if self:GetStackCount() == 2 and self:GetParent():HasModifier("modifier_nevermore_raze_legendary") then 
		self.particle_head = ParticleManager:CreateParticle("particles/sf_double_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
   		 ParticleManager:SetParticleControl( self.particle_head, 0,  self:GetParent():GetOrigin())
   		 ParticleManager:ReleaseParticleIndex(self.particle_head)
	end

	if self:GetStackCount() >= 3 then 


		if self:GetParent():HasModifier("modifier_nevermore_raze_speed") then 
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_shadowraze_speedmax", {duration = self:GetAbility().speed_duration})
		end


		if self:GetParent():HasModifier("modifier_nevermore_raze_legendary") then 

			local ability = self:GetParent():FindAbilityByName("custom_nevermore_shadowraze_close")
			if ability then 
				ability:EndCooldown()
			end

			ability = self:GetParent():FindAbilityByName("custom_nevermore_shadowraze_medium")
			if ability then 
				ability:EndCooldown()
			end

			ability = self:GetParent():FindAbilityByName("custom_nevermore_shadowraze_far")
			if ability then 
				ability:EndCooldown()
			end

			local particle = ParticleManager:CreateParticle("particles/sf_refresh_a.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
   			ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
   			ParticleManager:ReleaseParticleIndex(particle)

    		if self.particle_head then 
   	 			ParticleManager:DestroyParticle(self.particle_head, true)
   			end

    		self.particle_head = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze_triple.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
   			ParticleManager:SetParticleControl( self.particle_head, 0,  self:GetParent():GetOrigin())
   			ParticleManager:ReleaseParticleIndex(self.particle_head)
    

    		self:GetParent():EmitSound("Hero_Rattletrap.Overclock.Cast")	
    	end

		self:Destroy()

	end
end



end

modifier_custom_shadowraze_silence = class({})
modifier_custom_shadowraze_slow = class({})


function modifier_custom_shadowraze_silence:IsHidden() return false end
function modifier_custom_shadowraze_silence:IsPurgable() return true end
function modifier_custom_shadowraze_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_custom_shadowraze_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_custom_shadowraze_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_custom_shadowraze_slow:IsHidden() return false end
function modifier_custom_shadowraze_slow:IsPurgable() return true end
function modifier_custom_shadowraze_slow:DeclareFunctions() return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_custom_shadowraze_slow:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility().slow end





modifier_custom_shadowraze_speedmax = class({})

function modifier_custom_shadowraze_speedmax:IsPurgable() return true end
function modifier_custom_shadowraze_speedmax:IsHidden() return false end
function modifier_custom_shadowraze_speedmax:GetTexture() return "buffs/raze_speed" end

function modifier_custom_shadowraze_speedmax:OnCreated(table)
if not IsServer() then return end

	local heal = self:GetCaster():GetMaxHealth()*(self:GetAbility().speed_heal_init + self:GetAbility().speed_heal_inc*self:GetParent():GetUpgradeStack("modifier_nevermore_raze_speed"))
	self:GetCaster():Heal(heal, self:GetCaster())

    self:GetCaster():EmitSound("Sf.Speed_Heal")     

 	SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

    local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:ReleaseParticleIndex( particle )
	ParticleManager:DestroyParticle(particle, false)


	self.particle_aoe_fx = ParticleManager:CreateParticle("particles/sf_raze_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(self.particle_aoe_fx, 0,  self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_aoe_fx, 1,  self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_aoe_fx, 2,  self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_aoe_fx, 3,  self:GetCaster():GetAbsOrigin())
	ParticleManager:DestroyParticle(self.particle_aoe_fx, false)
	ParticleManager:ReleaseParticleIndex(self.particle_aoe_fx) 
end

function modifier_custom_shadowraze_speedmax:OnRefresh(table)
self:OnCreated()
end




 function modifier_custom_shadowraze_speedmax:GetEffectName() return "particles/sf_haste.vpcf" end

function modifier_custom_shadowraze_speedmax:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end



function modifier_custom_shadowraze_speedmax:GetModifierMoveSpeedBonus_Percentage() return 
self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetParent():GetUpgradeStack("modifier_nevermore_raze_speed")
end





modifier_custom_shadowraze_burn = class({})
function modifier_custom_shadowraze_burn:IsHidden() return true end
function modifier_custom_shadowraze_burn:IsPurgable() return true end
function modifier_custom_shadowraze_burn:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_shadowraze_burn:GetTexture() return "buffs/raze_burn" end
function modifier_custom_shadowraze_burn:OnCreated(table)
if not IsServer() then return end
	self.damage = table.damage
	self:StartIntervalThink(1)
end
function modifier_custom_shadowraze_burn:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_custom_shadowraze_burn_tracker")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end
end

function modifier_custom_shadowraze_burn:OnIntervalThink()
if not IsServer() then return end


	ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), ability = nil, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})

    SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.damage, nil)

end


modifier_custom_shadowraze_burn_tracker = class({})
function modifier_custom_shadowraze_burn_tracker:IsHidden() return false end
function modifier_custom_shadowraze_burn_tracker:GetEffectName() return "particles/sf_burn.vpcf" end

function modifier_custom_shadowraze_burn_tracker:IsPurgable() return false end
function modifier_custom_shadowraze_burn_tracker:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(1)
end

function modifier_custom_shadowraze_burn_tracker:OnIntervalThink()
if not IsServer() then return end
self:GetParent():EmitSound("Sf.Raze_Burn")
end

function modifier_custom_shadowraze_burn_tracker:OnRefresh()
if not IsServer() then return end
self:IncrementStackCount()
end
function modifier_custom_shadowraze_burn_tracker:GetTexture() return "buffs/raze_burn" end