LinkLuaModifier("modifier_void_spirit_astral_replicant", "abilities/void_spirit/void_spirit_astral_replicant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_strikes", "abilities/void_spirit/void_spirit_astral_replicant", LUA_MODIFIER_MOTION_NONE)

void_spirit_astral_replicant = class({})

void_spirit_astral_replicant.duration = 3
void_spirit_astral_replicant.delay = 0.1

function void_spirit_astral_replicant:OnSpellStart()
if not IsServer() then return end 


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_void_spirit_astral_replicant", {duration = self.duration})

end

modifier_void_spirit_astral_replicant = class({})
function modifier_void_spirit_astral_replicant:IsHidden() return false end
function modifier_void_spirit_astral_replicant:IsPurgable() return false end

function modifier_void_spirit_astral_replicant:GetEffectName() return "particles/generic_gameplay/void_step_active.vpcf" end

function modifier_void_spirit_astral_replicant:OnCreated(table)
if not IsServer() then return end
self.targetsx = {}
self.targetsy = {}
self.targetsz = {}

self:GetParent():EmitSound("VoidSpirit.Step.Active")

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_clinkz/void_buf.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )


local effect_cast2 = ParticleManager:CreateParticle( "particles/void_buf2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControl( effect_cast2, 0, self:GetCaster():GetOrigin() )



self:AddParticle(effect_cast, false,  false,  -1,  false,  false  )
self:AddParticle(effect_cast2, false,  false,  -1,  false,  false  )


end

function modifier_void_spirit_astral_replicant:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if self:GetStackCount() == 0 then return end
if self:GetParent():HasModifier("modifier_final_duel_start") then return end
if self:GetParent():IsOutOfGame() then return end
local ability = self:GetParent():FindAbilityByName("void_spirit_astral_step_custom")

if not ability then return end

self:GetParent():EmitSound("VoidSpirit.Step.Active_End")
local mod = self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_void_spirit_astral_strikes", {max = self:GetStackCount(), duration = self:GetAbility().delay*self:GetStackCount()})

if mod then 
	mod:SetStackCount(self:GetStackCount())
	mod.x = self.targetsx
	mod.y = self.targetsy
	mod.z = self.targetsz
end


end

function modifier_void_spirit_astral_replicant:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_void_spirit_astral_replicant:OnTooltip()
return self:GetStackCount()
end
--------------------------------------------------------------------------------



modifier_void_spirit_astral_strikes = class({})
function modifier_void_spirit_astral_strikes:IsHidden() return true end
function modifier_void_spirit_astral_strikes:IsPurgable() return false end

function modifier_void_spirit_astral_strikes:OnCreated(table)
if not IsServer() then return end
self.x = {}
self.y = {}
self.z = {}
self.n = table.max 

self:StartIntervalThink(self:GetRemainingTime()/self.n)

end

function modifier_void_spirit_astral_strikes:OnIntervalThink()
if not IsServer() then return end
local point = Vector(self.x[self.n],self.y[self.n],self.z[self.n])

local ability = self:GetParent():FindAbilityByName("void_spirit_astral_step_custom")

if not ability then return end

ability:Strike(self:GetParent(), self:GetParent():GetAbsOrigin(), point,9999)

self.n = self.n - 1

end

function modifier_void_spirit_astral_strikes:CheckState()
return
{
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
}

end