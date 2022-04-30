LinkLuaModifier("modifier_custom_pudge_flesh_heap","abilities/pudge/custom_pudge_flesh_heap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_flesh_heap_stack","abilities/pudge/custom_pudge_flesh_heap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_flesh_heap_creep","abilities/pudge/custom_pudge_flesh_heap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_flesh_heap_damage","abilities/pudge/custom_pudge_flesh_heap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_flesh_heap_tempo_count","abilities/pudge/custom_pudge_flesh_heap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_flesh_heap_tempo","abilities/pudge/custom_pudge_flesh_heap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_flesh_heap_legendary","abilities/pudge/custom_pudge_flesh_heap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_flesh_heap_hit_cd","abilities/pudge/custom_pudge_flesh_heap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_flesh_heap_hit_heal","abilities/pudge/custom_pudge_flesh_heap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_flesh_heap_hit_ready","abilities/pudge/custom_pudge_flesh_heap", LUA_MODIFIER_MOTION_NONE)



custom_pudge_flesh_heap = class({})

custom_pudge_flesh_heap.str_init = 0.5
custom_pudge_flesh_heap.str_inc = 0.5

custom_pudge_flesh_heap.creeps_k = 200
custom_pudge_flesh_heap.creeps_max_init = 180
custom_pudge_flesh_heap.creeps_max_inc = -20
custom_pudge_flesh_heap.creeps_max = 20

custom_pudge_flesh_heap.lowhp_health = 30
custom_pudge_flesh_heap.lowhp_init = -10
custom_pudge_flesh_heap.lowhp_inc = -1
custom_pudge_flesh_heap.lowhp_max = -40

custom_pudge_flesh_heap.tempo_duration = 8

custom_pudge_flesh_heap.legendary_duration = 10
custom_pudge_flesh_heap.legendary_scale = 30
custom_pudge_flesh_heap.legendary_speed = 150
custom_pudge_flesh_heap.legendary_multi = 2
custom_pudge_flesh_heap.legendary_cd = 60

custom_pudge_flesh_heap.armor_init = 32
custom_pudge_flesh_heap.armor_inc = -4

custom_pudge_flesh_heap.hit_str = 1.2
custom_pudge_flesh_heap.hit_cd_init = 11
custom_pudge_flesh_heap.hit_cd_inc = -3
custom_pudge_flesh_heap.hit_stun = 1
custom_pudge_flesh_heap.hit_heal = 0.8


function custom_pudge_flesh_heap:GetIntrinsicModifierName()
	return "modifier_custom_pudge_flesh_heap_stack"
end



function custom_pudge_flesh_heap:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_pudge_flesh_legendary") 
	then return self.legendary_cd 
end 
return self.BaseClass.GetCooldown(self, iLevel)
end


function custom_pudge_flesh_heap:OnSpellStart()
if not IsServer() then return end

local duration = self:GetSpecialValueFor("duration")

if self:GetCaster():HasModifier("modifier_pudge_flesh_legendary") then 
	self:GetCaster():EmitSound("Pudge.Flesh_active")
	duration = self.legendary_duration
end


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_flesh_heap_legendary", {duration = duration})

end




modifier_custom_pudge_flesh_heap_legendary = class({})
function modifier_custom_pudge_flesh_heap_legendary:IsHidden() return false end
function modifier_custom_pudge_flesh_heap_legendary:IsPurgable() return false end

function modifier_custom_pudge_flesh_heap_legendary:GetStatusEffectName()
if self:GetParent():HasModifier("modifier_pudge_flesh_legendary") then
	return "particles/status_fx/status_effect_grimstroke_dark_artistry.vpcf"
else 
	return "particles/units/heroes/hero_pudge/pudge_fleshheap_status_effect.vpcf"
end
end

function modifier_custom_pudge_flesh_heap_legendary:StatusEffectPriority()
    return 10010
end



function modifier_custom_pudge_flesh_heap_legendary:GetEffectName()
if self:GetParent():HasModifier("modifier_pudge_flesh_legendary") then 
	return "particles/units/heroes/hero_undying/undying_fg_aura.vpcf"
else 
	return "particles/units/heroes/hero_pudge/pudge_fleshheap_block_activation.vpcf"
end

end
function modifier_custom_pudge_flesh_heap_legendary:OnCreated(table)
if not IsServer() then return end


self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")

if self:GetParent():HasModifier("modifier_pudge_flesh_legendary") then 
	self.hands = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay_strength_buff.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
	ParticleManager:SetParticleControlEnt(self.hands,0,self:GetParent(),PATTACH_ABSORIGIN_FOLLOW,"follow_origin",self:GetParent():GetOrigin(),false)
	self:AddParticle(self.hands,true,false,0,false,false)
	self:StartIntervalThink(FrameTime())
end

end




function modifier_custom_pudge_flesh_heap_legendary:OnIntervalThink()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_custom_pudge_flesh_heap")

if mod then 
	self:SetStackCount(mod:GetStackCount()*self:GetAbility().legendary_multi)
end

end

function modifier_custom_pudge_flesh_heap_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_SCALE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,

}
end
function modifier_custom_pudge_flesh_heap_legendary:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end

if params.damage_type == DAMAGE_TYPE_MAGICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_magic_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end

if params.damage_type == DAMAGE_TYPE_PHYSICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_attack_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end

return self.damage_block

end


function modifier_custom_pudge_flesh_heap_legendary:OnTooltip()
local bonus = 0

if self:GetParent():HasModifier("modifier_pudge_flesh_2") then 
	bonus = self:GetAbility().str_init + self:GetAbility().str_inc*self:GetParent():GetUpgradeStack("modifier_pudge_flesh_2")
end

local str = (self:GetAbility():GetSpecialValueFor("flesh_heap_strength_buff_amount") + bonus)


return self:GetStackCount()*str

end




function modifier_custom_pudge_flesh_heap_legendary:GetModifierModelScale()
if not self:GetParent():HasModifier("modifier_pudge_flesh_legendary") then return end
return self:GetAbility().legendary_scale
end


function modifier_custom_pudge_flesh_heap_legendary:GetModifierAttackSpeedBonus_Constant()
if not self:GetParent():HasModifier("modifier_pudge_flesh_legendary") then return end
return self:GetAbility().legendary_speed
end




modifier_custom_pudge_flesh_heap = class({})

modifier_custom_pudge_flesh_heap.radius = 450

function modifier_custom_pudge_flesh_heap:IsHidden() return true end
function modifier_custom_pudge_flesh_heap:IsPurgable() return false end
function modifier_custom_pudge_flesh_heap:RemoveOnDeath() return false end

function modifier_custom_pudge_flesh_heap:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_custom_pudge_flesh_heap:OnDeath(params)
local target = params.unit
if self:GetCaster():GetTeamNumber() == target:GetTeamNumber() then return end
if target:IsReincarnating() then return end
if not self:GetCaster():IsRealHero() then return end


if target:GetTeam() == DOTA_TEAM_NEUTRALS and self:GetCaster():HasModifier("modifier_custom_pudge_flesh_heap_creep") and params.attacker == self:GetParent() then 
	local inc = math.min(self:GetAbility().creeps_max,target:GetMaxHealth()/self:GetAbility().creeps_k)

	local mod = self:GetCaster():FindModifierByName("modifier_custom_pudge_flesh_heap_creep")

	local max = self:GetAbility().creeps_max_init + self:GetAbility().creeps_max_inc*self:GetCaster():GetUpgradeStack("modifier_pudge_flesh_1")

	if mod:GetStackCount() + inc < max then 
		mod:SetStackCount(mod:GetStackCount() + inc)
	else 
		mod:SetStackCount(inc - (max - mod:GetStackCount()))
		self:SetStackCount(self:GetStackCount() + 1)
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(pfx)
	end

end


if not target:IsRealHero() then return end

if ((self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= self.radius) or (params.attacker and params.attacker == self:GetParent()) then
	self:SetStackCount(self:GetStackCount() + 1)

	if self:GetParent():HasModifier("modifier_custom_pudge_flesh_heap_legendary") and self:GetCaster():HasModifier("modifier_pudge_flesh_legendary") then 
		self:SetStackCount(self:GetStackCount() + 1)
	end

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(pfx)
end

end

modifier_custom_pudge_flesh_heap_stack = class({})

function modifier_custom_pudge_flesh_heap_stack:IsDebuff() return false end
function modifier_custom_pudge_flesh_heap_stack:IsHidden() 
	return self:GetParent():HasModifier("modifier_custom_pudge_flesh_heap_legendary")
end
function modifier_custom_pudge_flesh_heap_stack:IsPurgable() return false end
function modifier_custom_pudge_flesh_heap_stack:IsStunDebuff() return false end
function modifier_custom_pudge_flesh_heap_stack:RemoveOnDeath() return false end

function modifier_custom_pudge_flesh_heap_stack:OnCreated()
if not IsServer() then return end

if self:GetParent():IsIllusion() and self:GetParent():GetPlayerOwner():GetAssignedHero():HasModifier("modifier_custom_pudge_flesh_heap_stack") then
	self:SetStackCount(self:GetParent():GetPlayerOwner():GetAssignedHero():FindModifierByName("modifier_custom_pudge_flesh_heap_stack"):GetStackCount())
end
		
if not self:GetParent():IsIllusion() then
	self:StartIntervalThink(0.1)
end

end

function modifier_custom_pudge_flesh_heap_stack:OnIntervalThink()
	if self:GetCaster():HasModifier("modifier_custom_pudge_flesh_heap") then
		self:SetStackCount(self:GetCaster():FindModifierByName("modifier_custom_pudge_flesh_heap"):GetStackCount())
	end
	self:GetCaster():CalculateStatBonus(true)
end

function modifier_custom_pudge_flesh_heap_stack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    	MODIFIER_PROPERTY_PRE_ATTACK,
	}
end

function modifier_custom_pudge_flesh_heap_stack:GetModifierPreAttack(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_pudge_flesh_4") then return end
if self:GetParent():HasModifier("modifier_custom_pudge_flesh_heap_hit_cd") then return end
if params.target and params.target:IsBuilding() then return end


self.record = params.record

end



function modifier_custom_pudge_flesh_heap_stack:GetModifierPreAttack_BonusDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_pudge_flesh_4") then return end
if self:GetParent():HasModifier("modifier_custom_pudge_flesh_heap_hit_cd") then return end
if params.target and params.target:IsBuilding() then return end

return self:GetParent():GetStrength()*self:GetAbility().hit_str

end

function modifier_custom_pudge_flesh_heap_stack:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_pudge_flesh_4") then return end
if self:GetParent():HasModifier("modifier_custom_pudge_flesh_heap_hit_cd") then return end
if params.target:IsBuilding() then return end
if self.record ~= params.record then return end

local cd = self:GetAbility().hit_cd_init + self:GetAbility().hit_cd_inc*self:GetParent():GetUpgradeStack("modifier_pudge_flesh_4")

params.target:EmitSound("Pudge.Flesh_bash")

self:GetParent():EmitSound("Pudge.Flesh_hit")

local forward = (params.target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/centaur/centaur_ti9/flesh_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target )
	ParticleManager:SetParticleControlEnt(effect_cast,0,self:GetCaster(),PATTACH_POINT_FOLLOW,"attach_hitloc",params.target:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(effect_cast,1,params.target,PATTACH_POINT_FOLLOW,"attach_hitloc",params.target:GetOrigin(), true)
	ParticleManager:SetParticleControl( effect_cast, 2, params.target:GetOrigin() )
    ParticleManager:SetParticleControl(effect_cast, 3, params.target:GetAbsOrigin())
	ParticleManager:SetParticleControl( effect_cast, 5, params.target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 6, Vector(150,1,1) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_pudge_flesh_heap_hit_cd", {duration = cd})
params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bashed", {duration = (1 - params.target:GetStatusResistance())*self:GetAbility().hit_stun})
params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_pudge_flesh_heap_hit_heal", {duration = 0.1})

end




function modifier_custom_pudge_flesh_heap_stack:GetModifierPhysicalArmorBonus()
if self:GetParent():HasModifier("modifier_pudge_flesh_3") then 
	return self:GetParent():GetStrength()/(self:GetAbility().armor_init + self:GetAbility().armor_inc*self:GetParent():GetUpgradeStack("modifier_pudge_flesh_3"))
end

end


function modifier_custom_pudge_flesh_heap_stack:GetModifierBonusStats_Strength()
local bonus = 0
if self:GetParent():HasModifier("modifier_pudge_flesh_2") then 
	bonus = self:GetAbility().str_init + self:GetAbility().str_inc*self:GetParent():GetUpgradeStack("modifier_pudge_flesh_2")
end


if self:GetParent():HasModifier("modifier_custom_pudge_flesh_heap_legendary") and self:GetParent():HasModifier("modifier_pudge_flesh_legendary") then 
	return (self:GetAbility():GetSpecialValueFor("flesh_heap_strength_buff_amount") + bonus) * self:GetParent():GetUpgradeStack("modifier_custom_pudge_flesh_heap_legendary")
else 
	return (self:GetAbility():GetSpecialValueFor("flesh_heap_strength_buff_amount") + bonus) * self:GetStackCount()	
end


end

function modifier_custom_pudge_flesh_heap_stack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() then return end
if not self:GetParent():HasModifier("modifier_pudge_flesh_6") then return end

local duration = self:GetAbility().tempo_duration

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_pudge_flesh_heap_tempo", {duration = duration})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_pudge_flesh_heap_tempo_count", {duration = duration})

end


modifier_custom_pudge_flesh_heap_creep = class({})
function modifier_custom_pudge_flesh_heap_creep:IsHidden()
 return false
end
function modifier_custom_pudge_flesh_heap_creep:IsPurgable() return false end
function modifier_custom_pudge_flesh_heap_creep:RemoveOnDeath() return false end
function modifier_custom_pudge_flesh_heap_creep:GetTexture() return "buffs/flesh_creep" end
function modifier_custom_pudge_flesh_heap_creep:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_custom_pudge_flesh_heap_creep:OnTooltip()
return self:GetAbility().creeps_max_init + self:GetAbility().creeps_max_inc*self:GetCaster():GetUpgradeStack("modifier_pudge_flesh_1")
end

modifier_custom_pudge_flesh_heap_damage = class({})
function modifier_custom_pudge_flesh_heap_damage:IsHidden()
if self:GetParent():PassivesDisabled() then return true end
return self:GetParent():GetHealthPercent() > self:GetAbility().lowhp_health
end
function modifier_custom_pudge_flesh_heap_damage:IsPurgable() return false end
function modifier_custom_pudge_flesh_heap_damage:RemoveOnDeath() return false end
function modifier_custom_pudge_flesh_heap_damage:GetTexture() return "buffs/flesh_lowhp" end
function modifier_custom_pudge_flesh_heap_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_custom_pudge_flesh_heap_damage:GetModifierIncomingDamage_Percentage()
if self:GetParent():GetHealthPercent() > self:GetAbility().lowhp_health then return end
if self:GetParent():PassivesDisabled() then return end

local name = "modifier_custom_pudge_flesh_heap"
if self:GetParent():HasModifier("modifier_custom_pudge_flesh_heap_legendary") then 
	name = "modifier_custom_pudge_flesh_heap_legendary"
end

local reduce = math.max(self:GetAbility().lowhp_max, self:GetAbility().lowhp_init + self:GetAbility().lowhp_inc*self:GetParent():GetUpgradeStack(name))

return reduce
end


modifier_custom_pudge_flesh_heap_tempo = class({})
function modifier_custom_pudge_flesh_heap_tempo:IsHidden() return true end
function modifier_custom_pudge_flesh_heap_tempo:IsPurgable() return false end
function modifier_custom_pudge_flesh_heap_tempo:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_pudge_flesh_heap_tempo:OnCreated(table)
self.RemoveForDuel = true 
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_custom_pudge_flesh_heap")
if mod then 
	mod:IncrementStackCount()
end

end

function modifier_custom_pudge_flesh_heap_tempo:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_custom_pudge_flesh_heap_tempo_count")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

mod = self:GetParent():FindModifierByName("modifier_custom_pudge_flesh_heap")
if mod then 
	mod:DecrementStackCount()
end


end

modifier_custom_pudge_flesh_heap_tempo_count = class({})
function modifier_custom_pudge_flesh_heap_tempo_count:IsHidden() return false end
function modifier_custom_pudge_flesh_heap_tempo_count:IsPurgable() return false end
function modifier_custom_pudge_flesh_heap_tempo_count:GetTexture() return "buffs/quill_cdr" end
function modifier_custom_pudge_flesh_heap_tempo_count:OnCreated(table)
self.RemoveForDuel = true
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_custom_pudge_flesh_heap_tempo_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

modifier_custom_pudge_flesh_heap_hit_cd = class({})
function modifier_custom_pudge_flesh_heap_hit_cd:IsHidden() return false end
function modifier_custom_pudge_flesh_heap_hit_cd:IsPurgable() return false end
function modifier_custom_pudge_flesh_heap_hit_cd:IsDebuff() return true end
function modifier_custom_pudge_flesh_heap_hit_cd:RemoveOnDeath() return false end
function modifier_custom_pudge_flesh_heap_hit_cd:GetTexture() return "buffs/flesh_hit" end
function modifier_custom_pudge_flesh_heap_hit_cd:OnCreated(table)
self.RemoveForDuel = true
end

modifier_custom_pudge_flesh_heap_hit_heal = class({})
function modifier_custom_pudge_flesh_heap_hit_heal:IsHidden() return true end
function modifier_custom_pudge_flesh_heap_hit_heal:IsPurgable() return false end
function modifier_custom_pudge_flesh_heap_hit_heal:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_custom_pudge_flesh_heap_hit_heal:OnTakeDamage(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if params.inflictor ~= nil then return end
if params.attacker ~= self:GetCaster() then return end

local heal = self:GetAbility().hit_heal*params.damage

self:GetCaster():Heal(heal, self:GetAbility())

local particle = ParticleManager:CreateParticle( "particles/pudge_bash_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
 ParticleManager:ReleaseParticleIndex( particle )

 SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

self:Destroy()
end


modifier_custom_pudge_flesh_heap_hit_ready = class({})
function modifier_custom_pudge_flesh_heap_hit_ready:IsHidden() return self:GetParent():HasModifier("modifier_custom_pudge_flesh_heap_hit_cd") end
function modifier_custom_pudge_flesh_heap_hit_ready:IsPurgable() return false end
function modifier_custom_pudge_flesh_heap_hit_ready:RemoveOnDeath() return false end
function modifier_custom_pudge_flesh_heap_hit_ready:GetTexture() return "buffs/flesh_hit" end


