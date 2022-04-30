LinkLuaModifier("modifier_custom_terrorblade_reflection_slow", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_unit", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_spells", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_invulnerability", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_stats", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_legendary_saved", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_silence", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_attributes", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_armor", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_speed", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_gold", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)

 


find_behavior={data32={}}
for i=1,32 do
    find_behavior.data32[i]=2^(32-i)
end

function find_behavior:d2b(arg)
    local   tr={}
    for i=1,32 do
        if arg >= self.data32[i] then
        tr[i]=1
        arg=arg-self.data32[i]
        else
        tr[i]=0
        end
    end
    return   tr
end   --bit:d2b

function   find_behavior:b2d(arg)
    local   nr=0
    for i=1,32 do
        if arg[i] ==1 then
        nr=nr+2^(32-i)
        end
    end
    return  nr
end 



function    find_behavior:_and(a,b)
    local   op1=self:d2b(a)
    local   op2=self:d2b(b)
    local   r={}
    
    for i=1,32 do
        if op1[i]==1 and op2[i]==1  then
            r[i]=1
        else
            r[i]=0
        end
    end
    return  self:b2d(r)
    
end


function ContainsValue(sum,nValue)
  
  if type(sum) == "userdata" then
     sum = tonumber(tostring(sum))
  end

  if find_behavior:_and(sum,nValue)==nValue then
        return true
  else
        return false
  end

end




custom_terrorblade_reflection = class({})


custom_terrorblade_reflection.cd_init = 0
custom_terrorblade_reflection.cd_inc = 2

custom_terrorblade_reflection.duration_inc = 2

custom_terrorblade_reflection.stats_init = 0.1
custom_terrorblade_reflection.stats_inc = 0.1

custom_terrorblade_reflection.main_silence = 2
custom_terrorblade_reflection.main_bash_chance = 15
custom_terrorblade_reflection.main_bash = 1
custom_terrorblade_reflection.main_speed = 25

custom_terrorblade_reflection.spells_cd = 3

custom_terrorblade_reflection.armor_init = 0
custom_terrorblade_reflection.armor_inc = -0.5
custom_terrorblade_reflection.slow_init = -2
custom_terrorblade_reflection.slow_inc = -2
custom_terrorblade_reflection.armor_duration = 2
custom_terrorblade_reflection.armor_max = 5




function custom_terrorblade_reflection:GetIntrinsicModifierName()
return "modifier_custom_terrorblade_reflection_gold"
end

function custom_terrorblade_reflection:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_terror_reflection_duration") then 
	upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_terror_reflection_duration")
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
end

function custom_terrorblade_reflection:GetBehavior()
  if self:GetCaster():HasModifier("modifier_terror_reflection_legendary") then
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST end
 return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end



function custom_terrorblade_reflection:GetAOERadius()
	return self:GetSpecialValueFor("range")
end


function custom_terrorblade_reflection:OnSpellStart()
self:Cast(self:GetCaster())
end	


function custom_terrorblade_reflection:Cast(caster)
if not IsServer() then return end


	self.duration = self:GetSpecialValueFor("illusion_duration")

	if caster:HasModifier("modifier_terror_reflection_silence") then 
		self.duration = self.duration + self.duration_inc
	end

	local targets = FindUnitsInRadius(caster:GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS +  DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)


	local creeps = {}
	if caster:HasModifier("modifier_custom_terrorblade_reflection_legendary_saved") and self:GetAutoCastState() == true then 
		creeps = FindUnitsInRadius(caster:GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS +  DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	end

	if #creeps > 0 then 


		local max = 0

		for i,creep in pairs(creeps) do
			max = max + 1
			table.insert(targets, creep) 
			if max == 2 then 
				break
			end
		end
	end


	if caster:HasModifier("modifier_terror_reflection_legendary") then

	    if self:GetAutoCastState() == false and #targets > 0 then 

				local save =  targets[RandomInt(1, #targets)]

				local particle_cast = ''
				if save:GetPrimaryAttribute() == 1 then 
					particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_agi.vpcf"
 				end
 				if save:GetPrimaryAttribute() == 0 then 
					particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_str.vpcf"
 				end
 				if save:GetPrimaryAttribute() == 2 then 
					particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_int.vpcf"
 				end
 	




				local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt( effect_cast, 0, save, PATTACH_POINT_FOLLOW, "attach_hitloc", save:GetAbsOrigin(),  true )
				ParticleManager:SetParticleControlEnt( effect_cast, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true  )
				ParticleManager:ReleaseParticleIndex( effect_cast )


				local mod = caster:FindModifierByName("modifier_custom_terrorblade_reflection_legendary_saved")

				if mod then 
					mod:Destroy()
				end

				mod = caster:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_legendary_saved", {name = save:GetUnitName()})
				mod.level = save:GetLevel()
				mod.abilities = {}

				for abilitySlot = 0,15 do

					local ability = save:GetAbilityByIndex(abilitySlot)

					if ability ~= nil then

						mod.abilities[abilitySlot] = {}

						mod.abilities[abilitySlot].level = ability:GetLevel()
						mod.abilities[abilitySlot].name = ability:GetAbilityName()

					end
				end

				mod.items = {}
				for itemSlot=0,5 do

					local item = save:GetItemInSlot(itemSlot)

					if item ~= nil then

						mod.items[itemSlot] = item:GetName()

					end
			    end

			    mod.talents = {}
			    local j = 0
			    for _,modifier in pairs(save:FindAllModifiers()) do 

			    	if modifier.StackOnIllusion ~= nil and modifier.StackOnIllusion == true then
			    		j = j + 1
			    		mod.talents[j] = {}
			    		mod.talents[j].name = modifier:GetName()
			    		mod.talents[j].level = modifier:GetStackCount()
					end
			    end



		end
	end



	for _, enemy in pairs(targets) do	

		if enemy:GetHullRadius() > 8 then
			spawn_range = 108
		else
			spawn_range	= 72
		end
	
		enemy:EmitSound("Hero_Terrorblade.Reflection")


		enemy:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_slow", {duration = self.duration * (1 - enemy:GetStatusResistance())})

		local int = false
		
		local damage = self:GetSpecialValueFor("illusion_outgoing_damage")


		

		if caster:HasModifier("modifier_custom_terrorblade_reflection_legendary_saved") and self:GetAutoCastState() == true then 

			local mod = caster:FindModifierByName("modifier_custom_terrorblade_reflection_legendary_saved")

			local illusion = CreateUnitByName(mod.name, enemy:GetAbsOrigin() + RandomVector(spawn_range), false, self:GetCaster(), self:GetCaster(), caster:GetTeamNumber())
			
			illusion:AddNewModifier(self:GetCaster(), self, "modifier_illusion", {outgoing_damage = damage, incoming_damage = 0, duration = self.duration * (1 - enemy:GetStatusResistance()) })
			

			illusion:MakeIllusion()
			

			for i = 1,mod.level - 1 do 
				illusion:HeroLevelUp(false)
			end


			for abilitySlot = 0,15 do

				local ability = illusion:GetAbilityByIndex(abilitySlot)

				if ability ~= nil then
					if ability:GetAbilityName() == mod.abilities[abilitySlot].name then 
						ability:SetLevel(mod.abilities[abilitySlot].level)
					end
				end
			end

			for itemSlot=0,5 do

				local itemName = mod.items[itemSlot]

				local newItem = CreateItem(itemName, illusion, illusion)

				illusion:AddItem(newItem)

			end

			if #mod.talents > 0 then 

		   		 for j = 1,#mod.talents do 

		    		local up = illusion:AddNewModifier(caster, nil, mod.talents[j].name, {})
			   		up:SetStackCount(mod.talents[j].level)
				end		

			end

		
			if illusion:GetPrimaryAttribute() == 2 then 
				int = true
			end


			if caster:HasModifier("modifier_terror_reflection_speed") then 

				local stats = caster:GetAgility()*(self.stats_init + self.stats_inc*self:GetCaster():GetUpgradeStack("modifier_terror_reflection_speed"))

			   	illusion:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_stats", {stats = stats})
			end 

			if caster:HasModifier("modifier_terror_reflection_stun") and illusion:GetPrimaryAttribute() == 0 then 
				illusion:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_reflection_attributes", {})
			end

			if caster:HasModifier("modifier_terror_reflection_stun") and illusion:GetPrimaryAttribute() == 1 then 
				illusion:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_reflection_speed", {})
				caster:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_reflection_speed", {})
			end


			if caster:HasModifier("modifier_terror_reflection_double") and enemy:IsHero() then 
				illusion:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_spells", {duration = self.spells_cd, enemy = enemy:entindex()})
			end

			illusion:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_unit", {duration = self.duration * (1 - enemy:GetStatusResistance()), enemy_entindex = enemy:entindex()})

			illusion:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_invulnerability", {duration = self.duration * (1 - enemy:GetStatusResistance())})
			illusion.owner = caster
			illusion.givegold = 1
		else 

			local illusions = CreateIllusions(caster, enemy, {
				outgoing_damage = damage,
				bounty_base		= 0,
				bounty_growth	= nil,
				duration		= self.duration * (1 - enemy:GetStatusResistance())
			}
			, 1, spawn_range, false, true)
		
			if enemy:GetPrimaryAttribute() == 2 then 
				int = true
			end
	
			for _, illusion in pairs(illusions) do


				if caster:HasModifier("modifier_terror_reflection_speed") then 

					local stats = caster:GetAgility()*(self.stats_init + self.stats_inc*self:GetCaster():GetUpgradeStack("modifier_terror_reflection_speed"))

			   		 illusion:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_stats", {stats = stats})
				end 

				if caster:HasModifier("modifier_terror_reflection_stun") and enemy:GetPrimaryAttribute() == 0 then 
					illusion:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_reflection_attributes", {})
				end

				if caster:HasModifier("modifier_terror_reflection_stun") and illusion:GetPrimaryAttribute() == 1 then 
					illusion:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_reflection_speed", {})
					caster:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_reflection_speed", {})
				end

				illusion:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_unit", { duration = self.duration * (1 - enemy:GetStatusResistance()), enemy_entindex = enemy:entindex()})

				illusion:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_invulnerability", {duration = self.duration * (1 - enemy:GetStatusResistance())})
				illusion.owner = caster
			
				for _,mod in pairs(enemy:FindAllModifiers()) do
					if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
						illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
					end
				end

				if caster:HasModifier("modifier_terror_reflection_double") then 
					illusion:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_spells", {duration = self.spells_cd, enemy = enemy:entindex()})
				end

			

			end	

		end

		if int == true and caster:HasModifier("modifier_terror_reflection_stun") then 
			local duration = self.main_silence*(1 - enemy:GetStatusResistance())
			enemy:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_silence", {duration = duration})
		end

    end

end


modifier_custom_terrorblade_reflection_stats = class({})
function modifier_custom_terrorblade_reflection_stats:IsHidden() return false end
function modifier_custom_terrorblade_reflection_stats:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_stats:OnCreated(table)
if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
self.agi = table.stats
self.str = table.stats
self.int = table.stats


end

function modifier_custom_terrorblade_reflection_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,  
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end
function modifier_custom_terrorblade_reflection_stats:AddCustomTransmitterData() return {
agi = self.agi,
int = self.int,
str = self.str,

} end

function modifier_custom_terrorblade_reflection_stats:HandleCustomTransmitterData(data)
self.agi = data.agi
self.int = data.int
self.str = data.str
end

function modifier_custom_terrorblade_reflection_stats:GetModifierBonusStats_Agility()
return self.agi 
end

function modifier_custom_terrorblade_reflection_stats:GetModifierBonusStats_Strength()
return self.str 
end
function modifier_custom_terrorblade_reflection_stats:GetModifierBonusStats_Intellect()
return self.int
end





modifier_custom_terrorblade_reflection_invulnerability = class({})
function modifier_custom_terrorblade_reflection_invulnerability:IsHidden() return true end
function modifier_custom_terrorblade_reflection_invulnerability:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_invulnerability:GetStatusEffectName() return "particles/status_fx/status_effect_terrorblade_reflection.vpcf" end

function modifier_custom_terrorblade_reflection_invulnerability:StatusEffectPriority()
    return 10010
end




function modifier_custom_terrorblade_reflection_invulnerability:GetModifierModelScale() 
if self:GetParent():GetUnitName() == self:GetCaster():GetUnitName() then 
	return 0
end
return 30 
end

function modifier_custom_terrorblade_reflection_invulnerability:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
}

end

function modifier_custom_terrorblade_reflection_invulnerability:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_SCALE,
}
end

function modifier_custom_terrorblade_reflection_invulnerability:GetModelScale() return 2 end




modifier_custom_terrorblade_reflection_slow	= class({})


function modifier_custom_terrorblade_reflection_slow:IsPurgable() 
local mod = self:GetCaster():FindModifierByName("modifier_terror_reflection_silence")
if mod and mod:GetStackCount() > 1 then 
	return false 
end
	return true 
end

function modifier_custom_terrorblade_reflection_slow:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end


function modifier_custom_terrorblade_reflection_slow:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end
	self.move_slow	= self:GetAbility():GetSpecialValueFor("move_slow") * (-1)
end

function modifier_custom_terrorblade_reflection_slow:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end





function modifier_custom_terrorblade_reflection_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.move_slow 
end



modifier_custom_terrorblade_reflection_unit	=  class({})


function modifier_custom_terrorblade_reflection_unit:IsPurgable()	return false end

function modifier_custom_terrorblade_reflection_unit:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_custom_terrorblade_reflection_unit:OnCreated(keys)
if not IsServer() then return end
	self.target = EntIndexToHScript( keys.enemy_entindex )
	self:StartIntervalThink(0.1)
end

function modifier_custom_terrorblade_reflection_unit:OnIntervalThink()
	if self.target and not self.target:IsNull() and self:GetParent():IsAlive() and self.target:IsAlive()
	and self.target:HasModifier("modifier_custom_terrorblade_reflection_slow")   then

		if not self:GetParent():IsDisarmed() then 
     	  self:GetParent():SetForceAttackTarget(self.target)
    	  self:GetParent():MoveToTargetToAttack(self.target)
    	 end

	else
		self:DestroyIllusion()
	end
end

function modifier_custom_terrorblade_reflection_unit:DestroyIllusion()
if not IsServer() then return end
	
	 for _,mod in ipairs(self:GetParent():FindAllModifiers()) do 
        mod:Destroy()
     end

	self:GetParent():SetForceAttackTarget(nil)

	self:GetParent():ForceKill(false)
end

function modifier_custom_terrorblade_reflection_unit:OnDestroy()
if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_custom_terrorblade_reflection_speed") then 
		self:GetParent():RemoveModifierByName("modifier_custom_terrorblade_reflection_speed")
	end

	if self:GetCaster():HasModifier("modifier_custom_terrorblade_reflection_speed") then
		self:GetCaster():RemoveModifierByName("modifier_custom_terrorblade_reflection_speed")
	end
	self:DestroyIllusion()
end

function modifier_custom_terrorblade_reflection_unit:DeclareFunctions()
if self:GetCaster():HasModifier("modifier_terror_reflection_slow") then 
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end 

end
function modifier_custom_terrorblade_reflection_unit:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_terrorblade_reflection_armor", {duration = self:GetAbility().armor_duration})
end


modifier_custom_terrorblade_reflection_spells = class({})
function modifier_custom_terrorblade_reflection_spells:IsHidden() return true end
function modifier_custom_terrorblade_reflection_spells:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_spells:OnCreated(table)
if not IsServer() then return end
self:GetParent().owner = self:GetCaster()
self.target = EntIndexToHScript( table.enemy)


local j = 0
local ability = {}

for i = 0,self:GetParent():GetAbilityCount()-1 do

    local a = self:GetParent():GetAbilityByIndex(i)
    
    if not a or a:GetName() == "ability_capture" then break end

    if ContainsValue(a:GetBehavior(), DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) 
        and ContainsValue(a:GetAbilityTargetTeam(),  DOTA_UNIT_TARGET_TEAM_ENEMY) and a:GetLevel() > 0 and not a:IsHidden()
        and not ContainsValue(a:GetBehavior(), DOTA_ABILITY_BEHAVIOR_AUTOCAST)  then

        j = j + 1 
        ability[j] = a
    end
     
	
end

if #ability == 0 then return end
local r = RandomInt(1,#ability)

self.ability = ability[r]

self.t = -1
self.timer = self:GetRemainingTime()*2 
self:StartIntervalThink(0.5)
self:OnIntervalThink()

end

function modifier_custom_terrorblade_reflection_spells:OnIntervalThink()
if not IsServer() then return end
  self.t = self.t + 1
  local caster = self:GetParent()

        local number = (self.timer-self.t)/2 
        local int = 0
        int = number
       if number % 1 ~= 0 then int = number - 0.5  end

        local digits = math.floor(math.log10(number)) + 2

        local decimal = number % 1

        if decimal == 0.5 then
            decimal = 8
        else 
            decimal = 1
        end

local particleName = "particles/huskar_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end








function modifier_custom_terrorblade_reflection_spells:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if not self.target:IsRealHero() then return end
if self.target:IsInvulnerable() then return end
if not self.ability then return end

self.ability:OnSpellStart(self.target)


end







modifier_custom_terrorblade_reflection_legendary_saved = class({})
function modifier_custom_terrorblade_reflection_legendary_saved:IsHidden() return false end
function modifier_custom_terrorblade_reflection_legendary_saved:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_legendary_saved:RemoveOnDeath() return false end
function modifier_custom_terrorblade_reflection_legendary_saved:GetTexture() return 
	self.name
end

function modifier_custom_terrorblade_reflection_legendary_saved:OnCreated(table)
if not IsServer() then return end 
self:SetHasCustomTransmitterData(true)
self.name = table.name
end


function modifier_custom_terrorblade_reflection_legendary_saved:AddCustomTransmitterData() return {
name = self.name,

} end

function modifier_custom_terrorblade_reflection_legendary_saved:HandleCustomTransmitterData(data)
self.name = data.name
end



modifier_custom_terrorblade_reflection_silence = class({})
function modifier_custom_terrorblade_reflection_silence:IsHidden() return false end
function modifier_custom_terrorblade_reflection_silence:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true
}
end

function modifier_custom_terrorblade_reflection_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_custom_terrorblade_reflection_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


modifier_custom_terrorblade_reflection_attributes = class({})
function modifier_custom_terrorblade_reflection_attributes:IsHidden() return true end
function modifier_custom_terrorblade_reflection_attributes:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_attributes:OnCreated(table)
if not IsServer() then return end

self.chance = self:GetAbility().main_bash_chance
self.bash = self:GetAbility().main_bash

end

function modifier_custom_terrorblade_reflection_attributes:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}

end

function modifier_custom_terrorblade_reflection_attributes:OnAttackLanded(params)
if self:GetParent() ~= params.attacker then return end
if self.str == 0 then return end

local random = RollPseudoRandomPercentage(self.chance,193,self:GetParent())

if not random then return end

params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bashed", {duration = (1 - params.target:GetStatusResistance())*self.bash})
params.target:EmitSound("BB.Goo_stun")

end



modifier_custom_terrorblade_reflection_armor = class({})
function modifier_custom_terrorblade_reflection_armor:IsHidden() return false end
function modifier_custom_terrorblade_reflection_armor:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_armor:GetTexture() return "buffs/souls_tempo" end
function modifier_custom_terrorblade_reflection_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_custom_terrorblade_reflection_armor:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end
function modifier_custom_terrorblade_reflection_armor:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().armor_max then return end
self:IncrementStackCount()
end

function modifier_custom_terrorblade_reflection_armor:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*(self:GetAbility().armor_init + self:GetAbility().armor_inc*self:GetCaster():GetUpgradeStack("modifier_terror_reflection_slow"))
end


function modifier_custom_terrorblade_reflection_armor:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*(self:GetAbility().slow_init + self:GetAbility().slow_inc*self:GetCaster():GetUpgradeStack("modifier_terror_reflection_slow"))
end


modifier_custom_terrorblade_reflection_speed = class({})
function modifier_custom_terrorblade_reflection_speed:IsHidden() return false end
function modifier_custom_terrorblade_reflection_speed:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_speed:GetTexture() return "buffs/reflection_speed" end
function modifier_custom_terrorblade_reflection_speed:GetEffectName() return "particles/items3_fx/blink_swift_buff.vpcf" end
function modifier_custom_terrorblade_reflection_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_custom_terrorblade_reflection_speed:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().main_speed
end

modifier_custom_terrorblade_reflection_gold = class({})
function modifier_custom_terrorblade_reflection_gold:IsHidden() return true end
function modifier_custom_terrorblade_reflection_gold:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_gold:RemoveOnDeath() return false end
function modifier_custom_terrorblade_reflection_gold:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_DEATH
}
end

function modifier_custom_terrorblade_reflection_gold:OnDeath(params)
if not IsServer() then return end 
if not params.attacker then return end
if not self:GetParent():IsRealHero() then return end
if params.attacker.givegold == nil then return end
if params.attacker.givegold == false then return end
if not params.attacker.owner then return end
if not params.unit:IsCreep() then return end
if params.attacker.owner ~= self:GetParent() then return end

local gold = params.unit:GetMaximumGoldBounty()
if gold == 0 then return end

params.attacker.owner:ModifyGold(gold , true , DOTA_ModifyGold_CreepKill)
SendOverheadEventMessage(params.unit, 0, params.unit, gold, nil)

end
