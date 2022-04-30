LinkLuaModifier("modifier_custom_blink_shard", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_damage", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_tracker", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_hit", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_hit_count", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_legendary_attacks", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_legendary_nocount", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_legendary_nospeed", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_spell", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_speed", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_blink_absorb", "abilities/queen_of_pain/custom_queenofpain_blink", LUA_MODIFIER_MOTION_NONE)


custom_queenofpain_blink = class({})

custom_queenofpain_blink.cd_init = 0
custom_queenofpain_blink.cd_inc = 0.5

custom_queenofpain_blink.damage_init = 2
custom_queenofpain_blink.damage_inc = 2
custom_queenofpain_blink.damage_duration = 2

custom_queenofpain_blink.legendary_duration = 2
custom_queenofpain_blink.legendary_radius = 300
custom_queenofpain_blink.legendary_duration_attacks = FrameTime()*3

custom_queenofpain_blink.absorb_duration = 1.2
custom_queenofpain_blink.absorb_damage = -40

custom_queenofpain_blink.speed_hits = 5
custom_queenofpain_blink.speed_init = 40
custom_queenofpain_blink.speed_inc = 40

custom_queenofpain_blink.magic_radius = 200
custom_queenofpain_blink.magic_damage = 0.8
custom_queenofpain_blink.magic_chance_init = 10
custom_queenofpain_blink.magic_chance_inc = 10
custom_queenofpain_blink.magic_cd = 0.4

custom_queenofpain_blink.shard_damage = 125
custom_queenofpain_blink.shard_radius = 300
custom_queenofpain_blink.shard_silence = 1.75


function custom_queenofpain_blink:GetIntrinsicModifierName() return "modifier_custom_blink_tracker" end

function custom_queenofpain_blink:GetCooldown(iLevel)
local upgrade_cooldown = 0	
if self:GetCaster():HasModifier("modifier_queen_Blink_cd") then 
	upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Blink_cd")
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end

function custom_queenofpain_blink:GetCastRange(vLocation, hTarget)
local range = self:GetSpecialValueFor("blink_range") 
if IsClient() then 
	return range
end
return
end


function custom_queenofpain_blink:GetBehavior()
  if self:GetCaster():HasShard() or self:GetCaster():HasModifier("modifier_queen_Blink_legendary") then
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES end
 return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES 
end


function custom_queenofpain_blink:GetAOERadius() 
if self:GetCaster():HasShard() or self:GetCaster():HasModifier("modifier_queen_Blink_legendary") then 
	return 300
end
return 0
end


function custom_queenofpain_blink:ShardStrike(location)
if not IsServer() then return end
local radius = self.shard_radius
local damage = self.shard_damage
local silence = self.shard_silence
local caster = self:GetCaster()

local blink_shard_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_shard_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(blink_shard_pfx, 0, location )
ParticleManager:SetParticleControl(blink_shard_pfx, 1, location )
ParticleManager:SetParticleControl(blink_shard_pfx, 2, Vector(radius,radius,radius) )
ParticleManager:ReleaseParticleIndex(blink_shard_pfx)


local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
for _, enemy in pairs(enemies) do
	if not enemy:IsMagicImmune() then 

		ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_blink_shard", {duration = (1 - enemy:GetStatusResistance())*silence})
	end
end

end

function custom_queenofpain_blink:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()
local caster_pos = caster:GetAbsOrigin()
local target_pos = self:GetCursorPosition()


local blink_range = self:GetSpecialValueFor("blink_range") + self:GetCaster():GetCastRangeBonus()
local distance = (target_pos - caster_pos)


if distance:Length2D() > blink_range then
	target_pos = caster_pos + (distance:Normalized() * blink_range)
end

local start_b = "particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf"
local end_b = "particles/units/heroes/hero_queenofpain/queen_blink_end.vpcf"


if self:GetCaster():GetModelName() == "models/items/queenofpain/queenofpain_arcana/queenofpain_arcana.vmdl" then 
	start_b = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_blink_start.vpcf"
	end_b = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_blink_end.vpcf"


	local direction = (target_pos - caster_pos)
    direction = direction:Normalized()

    local particle_one = ParticleManager:CreateParticle(start_b, PATTACH_WORLDORIGIN, nil) 
    ParticleManager:SetParticleControl( particle_one, 0, self:GetCaster():GetAbsOrigin() )
    ParticleManager:SetParticleControlForward( particle_one, 0, direction:Normalized() )
    ParticleManager:SetParticleControl( particle_one, 1, self:GetCaster():GetForwardVector() )
   ParticleManager:SetParticleControl( particle_one, 4,Vector(10,1,0) )
    ParticleManager:ReleaseParticleIndex( particle_one )


else 
	local blink_pfx = ParticleManager:CreateParticle(start_b, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(blink_pfx, 0, caster_pos )
	ParticleManager:SetParticleControl(blink_pfx, 1, target_pos )
	ParticleManager:ReleaseParticleIndex(blink_pfx)
end

ProjectileManager:ProjectileDodge(caster)

caster:EmitSound("Hero_QueenOfPain.Blink_in")


if caster:HasShard() then 
	caster:EmitSound("Hero_QueenOfPain.Blink_in.Shard")
	self:ShardStrike(caster_pos)
end


FindClearSpaceForUnit(caster, target_pos, true)

if caster:HasShard() then 
	caster:EmitSound("Hero_QueenOfPain.Blink_Out.Shard")
	self:ShardStrike(target_pos)
end


caster:EmitSound("Hero_QueenOfPain.Blink_out")
local blink_end_pfx = ParticleManager:CreateParticle(end_b, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(blink_end_pfx, 0, target_pos )
ParticleManager:SetParticleControlForward(blink_end_pfx, 0, distance:Normalized())
ParticleManager:ReleaseParticleIndex(blink_end_pfx)

caster:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)


if caster:HasModifier("modifier_queen_Blink_damage") then 
	caster:AddNewModifier(caster, self, "modifier_custom_blink_damage", {duration = self.damage_duration})
end

if caster:HasModifier("modifier_queen_Blink_legendary") and self:GetCaster():HasModifier("modifier_custom_blink_hit_count") then

	local mod = caster:FindModifierByName("modifier_custom_blink_hit_count")

	caster:AddNewModifier(caster, self, "modifier_custom_blink_legendary_attacks", {hits = mod:GetStackCount()})
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	for _,m in pairs(caster:FindAllModifiers()) do
		if m:GetName() == "modifier_custom_blink_hit" then 
			m:Destroy()
		end
	end
end

if caster:HasModifier("modifier_queen_Blink_spells") then 
	caster:AddNewModifier(caster, self, "modifier_custom_blink_spell", {})
end



if caster:HasModifier("modifier_queen_Blink_speed") then 
	local mod_speed = caster:AddNewModifier(caster, self, "modifier_custom_blink_speed", {})
	mod_speed:SetStackCount(self.speed_hits)
end

if caster:HasModifier("modifier_queen_Blink_absorb") then 
	caster:AddNewModifier(caster, self, "modifier_custom_blink_absorb", { duration = self.absorb_duration})
end	


end


modifier_custom_blink_shard = class({})

function modifier_custom_blink_shard:IsHidden() return false end
function modifier_custom_blink_shard:IsPurgable() return true end
function modifier_custom_blink_shard:GetTexture() return "silencer_last_word" end
function modifier_custom_blink_shard:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_custom_blink_shard:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_custom_blink_shard:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


modifier_custom_blink_damage = class({})
function modifier_custom_blink_damage:IsHidden() return false end
function modifier_custom_blink_damage:IsPurgable() return true end
function modifier_custom_blink_damage:GetTexture() return "buffs/qop_blink_damage" end
function modifier_custom_blink_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end
function modifier_custom_blink_damage:GetModifierTotalDamageOutgoing_Percentage() return
	self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Blink_damage")
end






modifier_custom_blink_tracker = class({})

function modifier_custom_blink_tracker:IsHidden() return true end
function modifier_custom_blink_tracker:IsPurgable() return false end

function modifier_custom_blink_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}

end

function modifier_custom_blink_tracker:OnAttack(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_queen_Blink_legendary") then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_custom_blink_legendary_nocount") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_blink_hit", {duration = self:GetAbility().legendary_duration})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_blink_hit_count", {})

end


function modifier_custom_blink_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_queen_Blink_magic") then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if self:GetParent() ~= params.attacker then return end


local chance = self:GetAbility().magic_chance_init + self:GetAbility().magic_chance_inc*self:GetParent():GetUpgradeStack("modifier_queen_Blink_magic")

local random = RollPseudoRandomPercentage(chance,41,self:GetParent())

if not random then return end

params.target:EmitSound("QoP.Blink_attack")

local blink_shard_pfx = ParticleManager:CreateParticle("particles/qop_attack_.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
ParticleManager:SetParticleControlEnt(blink_shard_pfx, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(blink_shard_pfx, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(blink_shard_pfx, 3, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(blink_shard_pfx)





if self:GetAbility():GetCooldownTimeRemaining() > 0 then 
	local cd = self:GetAbility():GetCooldownTimeRemaining()
	self:GetAbility():EndCooldown()
	
	if cd > self:GetAbility().magic_cd then 
		self:GetAbility():StartCooldown(cd - self:GetAbility().magic_cd)
	end
end

local damage = self:GetAbility().magic_damage * self:GetParent():GetIntellect()

local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), params.target:GetAbsOrigin() , nil, self:GetAbility().magic_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, enemy in pairs(enemies) do
		ApplyDamage({victim = enemy, attacker = self:GetParent(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(enemy, 4, enemy, damage, nil)
	end


end



modifier_custom_blink_hit = class({})
function modifier_custom_blink_hit:IsHidden() return true end
function modifier_custom_blink_hit:IsPurgable() return false end
function modifier_custom_blink_hit:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_blink_hit:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_custom_blink_hit_count")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end


end

modifier_custom_blink_hit_count = class({})
function modifier_custom_blink_hit_count:IsHidden() return false end
function modifier_custom_blink_hit_count:IsPurgable() return false end
function modifier_custom_blink_hit_count:GetTexture() return "buffs/qop_blink_attack" end
function modifier_custom_blink_hit_count:OnCreated(table)
if not IsServer() then return end
	self:SetStackCount(1)
end

function modifier_custom_blink_hit_count:OnRefresh(table)
if not IsServer() then return end
	self:IncrementStackCount()
end

function modifier_custom_blink_hit_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_custom_blink_hit_count:OnTooltip() return self:GetStackCount() end

modifier_custom_blink_legendary_attacks = class({})
function modifier_custom_blink_legendary_attacks:IsHidden() return true end
function modifier_custom_blink_legendary_attacks:IsPurgable() return false end 
function modifier_custom_blink_legendary_attacks:OnCreated(table)
if not IsServer() then return end
self.hits = table.hits
self.radius = self:GetAbility().legendary_radius
self.count = 0
self:GetParent():EmitSound("QoP.Blink_legendary")



self.enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().legendary_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

for _,enemy in ipairs(self.enemies) do
	enemy.qop_mark = ParticleManager:CreateParticle("particles/qop_marker.vpcf", PATTACH_OVERHEAD_FOLLOW, enemy)
	ParticleManager:SetParticleControl(enemy.qop_mark, 0 , enemy:GetAbsOrigin())
end

if #self.enemies == 0 then 
	self:Destroy()
end

self:StartIntervalThink(self:GetAbility().legendary_duration_attacks)
end

function modifier_custom_blink_legendary_attacks:OnIntervalThink()
if not IsServer() then return end
self.count = self.count + 1 


local array = {}

for _,enemy in ipairs(self.enemies) do 
	if enemy:IsAlive() then 
		array[#array+1] = enemy
	end
end

if #array > 0 then 
	 local random = RandomInt(1, #array)

	 	local no = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_blink_legendary_nocount", {})
	 	self:GetParent():PerformAttack(array[random], true, true, true, false, true, false, false)	
		 if no then no:Destroy() end
else 
	self:Destroy()
end


if self.count >= self.hits then self:Destroy() end

end

function modifier_custom_blink_legendary_attacks:OnDestroy()
if not IsServer() then return end
for _,enemy in ipairs(self.enemies) do
	if  enemy.qop_mark then 
		ParticleManager:DestroyParticle(enemy.qop_mark, false)
		ParticleManager:ReleaseParticleIndex(enemy.qop_mark)
	end
end
end

modifier_custom_blink_legendary_nocount = class({})
function modifier_custom_blink_legendary_nocount:IsHidden() return true end
function modifier_custom_blink_legendary_nocount:IsPurgable() return false end

modifier_custom_blink_legendary_nospeed = class({})
function modifier_custom_blink_legendary_nospeed:IsHidden() return true end
function modifier_custom_blink_legendary_nospeed:IsPurgable() return false end


modifier_custom_blink_spell = class({})
function modifier_custom_blink_spell:IsHidden() return false end
function modifier_custom_blink_spell:IsPurgable() return false end
function modifier_custom_blink_spell:GetTexture() return "buffs/qop_blink_spell" end

function modifier_custom_blink_spell:OnCreated(table)
 self.RemoveForDuel = true
end




modifier_custom_blink_speed = class({})
function modifier_custom_blink_speed:IsHidden() return false end
function modifier_custom_blink_speed:IsPurgable() return true end
function modifier_custom_blink_speed:GetTexture() return "buffs/Crit_damage" end

function modifier_custom_blink_speed:OnCreated(table)
 self.RemoveForDuel = true
end
function modifier_custom_blink_speed:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_ATTACK
}
end

function modifier_custom_blink_speed:GetModifierAttackSpeedBonus_Constant()
return
self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Blink_speed")
end

function modifier_custom_blink_speed:OnAttack(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_custom_blink_legendary_nocount") or
self:GetParent():HasModifier("modifier_custom_blink_legendary_nospeed")
 then return end
self:DecrementStackCount()

if self:GetStackCount() == 0 then 
	self:Destroy()
end

end


modifier_custom_blink_absorb = class({})
function modifier_custom_blink_absorb:IsHidden() return false end
function modifier_custom_blink_absorb:IsPurgable() return false end
function modifier_custom_blink_absorb:GetTexture() return "buffs/qop_blink_cd" end

function modifier_custom_blink_absorb:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/qop_linken_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)


end

function modifier_custom_blink_absorb:OnDestroy()
if not IsServer() then return end
ParticleManager:DestroyParticle(self.particle, false)
ParticleManager:ReleaseParticleIndex(self.particle)

end


function modifier_custom_blink_absorb:DeclareFunctions()
return
{
MODIFIER_PROPERTY_ABSORB_SPELL,
MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_custom_blink_absorb:GetAbsorbSpell(params) 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end

local particle = ParticleManager:CreateParticle("particles/qop_linken.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")

return 1 
end



function modifier_custom_blink_absorb:GetModifierIncomingDamage_Percentage()
return self:GetAbility().absorb_damage
end
