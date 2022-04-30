LinkLuaModifier("modifier_abbadon_silence_self", "abilities/npc_abbadon_silence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abbadon_silence", "abilities/npc_abbadon_silence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abbadon_stack", "abilities/npc_abbadon_silence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abbadon_speed", "abilities/npc_abbadon_silence.lua", LUA_MODIFIER_MOTION_NONE)


npc_abbadon_silence = class({})


function npc_abbadon_silence:GetIntrinsicModifierName() return "modifier_abbadon_silence_self" end


modifier_abbadon_silence_self = class({})

function modifier_abbadon_silence_self:IsHidden()  return
true end

function modifier_abbadon_silence_self:IsPurgable() return false end

function modifier_abbadon_silence_self:OnCreated(table)
self.hits = self:GetAbility():GetSpecialValueFor("hits")

end


function modifier_abbadon_silence_self:DoScript(target) 
if not IsServer() then return end

if  not target:FindModifierByName("modifier_abbadon_silence") then
    target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_abbadon_stack", {duration = 5})
end

end



modifier_abbadon_stack = class({})


function modifier_abbadon_stack:IsHidden() return false end

function modifier_abbadon_stack:IsPurgable() return true end

function modifier_abbadon_stack:OnCreated(table)
    if not IsServer() then return end
   self:SetStackCount(1)
end

function modifier_abbadon_stack:OnRefresh(table)
        if not IsServer() then return end
   self:SetStackCount(self:GetStackCount()+1)
   if self:GetStackCount() == self:GetAbility():GetSpecialValueFor("hits") then 
         self:GetParent():EmitSound("Hero_Abaddon.Curse.Proc")
         self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_abbadon_silence", {duration = self:GetAbility():GetSpecialValueFor("duration")*(1 - self:GetParent():GetStatusResistance())})
         self:Destroy()
   end
end
function modifier_abbadon_stack:OnDestroy()
    if not IsServer() then return end
         ParticleManager:DestroyParticle(self.pfx, false)
        ParticleManager:ReleaseParticleIndex(self.pfx)
end

function modifier_abbadon_stack:OnStackCountChanged(iStackCount)
    if not IsServer() then return end

    if not self.pfx then
        self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    end

    ParticleManager:SetParticleControl(self.pfx, 1, Vector(0, self:GetStackCount(), 0))
end






modifier_abbadon_silence = class({})


function modifier_abbadon_silence:IsHidden() return false end

function modifier_abbadon_silence:IsPurgable() return true end

function modifier_abbadon_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end 
function modifier_abbadon_silence:OnCreated(table)

if not IsServer() then return end
local particle = "particles/generic_gameplay/generic_silence.vpcf"
local parent = self:GetParent()
local fx = ParticleManager:CreateParticle(particle, PATTACH_OVERHEAD_FOLLOW, parent)
ParticleManager:SetParticleControlEnt(fx, 0, parent, PATTACH_OVERHEAD_FOLLOW, nil, parent:GetOrigin(), true)
self:AddParticle(fx, false, false, -1, false, true)
end
function modifier_abbadon_silence:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

 

function modifier_abbadon_silence:OnTooltip()
return self:GetAbility():GetSpecialValueFor("speed")
end


function modifier_abbadon_silence:DoScript(attacker)
if not IsServer() then return end
if not attacker then return end
if not attacker:IsAlive() then return end

  attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_abbadon_speed", {duration = 1})

end

function modifier_abbadon_silence:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf" end
 
function modifier_abbadon_silence:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


modifier_abbadon_speed = class({})


function modifier_abbadon_speed:IsHidden() return false end

function modifier_abbadon_speed:IsPurgable() return false end

function modifier_abbadon_speed:OnCreated(table)
if not self:GetAbility() then return end
   self.speed = self:GetAbility():GetSpecialValueFor("speed")
   self.move = self:GetAbility():GetSpecialValueFor("move")
end
function modifier_abbadon_speed:OnTooltip2()
return self.move
end
function modifier_abbadon_speed:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end
function modifier_abbadon_speed:GetModifierAttackSpeedBonus_Constant() return self.speed end
function modifier_abbadon_speed:GetModifierMoveSpeedBonus_Percentage() return self.move end

 

function modifier_abbadon_speed:OnTooltip()
return self.speed
end


function modifier_abbadon_speed:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_frost_buff.vpcf" end
 
function modifier_abbadon_speed:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end