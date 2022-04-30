LinkLuaModifier("modifier_abbadon_passive", "abilities/npc_abbadon_ulti.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abbadon_buff", "abilities/npc_abbadon_ulti.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abbadon_cd", "abilities/npc_abbadon_ulti.lua", LUA_MODIFIER_MOTION_NONE)

npc_abbadon_ulti = class({})


function npc_abbadon_ulti:GetIntrinsicModifierName() return "modifier_abbadon_passive" end
 
modifier_abbadon_passive = class ({})

function modifier_abbadon_passive:IsHidden() return true end


function modifier_abbadon_passive:DoScript()
if not IsServer() then end 
    local health = self:GetAbility():GetSpecialValueFor("health")
    if self:GetParent():GetHealthPercent() <= health and not self:GetParent():HasModifier("modifier_abbadon_cd") and self:GetParent():IsAlive() then 
        self:GetParent():EmitSound("Hero_Abaddon.BorrowedTime")
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_abbadon_cd", {duration = self:GetAbility():GetSpecialValueFor("cd")})
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_abbadon_buff", {duration = self:GetAbility():GetSpecialValueFor("duration")})
     end

end



modifier_abbadon_buff = class ({})

function modifier_abbadon_buff:IsHidden() return false end

function modifier_abbadon_buff:IsPurgable() return false end


function modifier_abbadon_buff:DeclareFunctions() 
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

end

function modifier_abbadon_buff:GetModifierIncomingDamage_Percentage(kv)
    if IsServer() then
        local target    = self:GetParent()

        local heal_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        local target_vector = target:GetAbsOrigin()
        ParticleManager:SetParticleControl(heal_particle, 0, target_vector)
        ParticleManager:SetParticleControl(heal_particle, 1, target_vector)
        ParticleManager:ReleaseParticleIndex(heal_particle)
        local heal = self:GetAbility():GetSpecialValueFor("heal")/100
        target:Heal(kv.damage*heal, target)
        
        return -9999999
    end
end

function modifier_abbadon_buff:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" end
 
function modifier_abbadon_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_abbadon_buff:GetStatusEffectName() return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end
function  modifier_abbadon_buff:StatusEffectPriority() return 15 end

modifier_abbadon_cd = class({})

function modifier_abbadon_cd:IsHidden() return false end
function modifier_abbadon_cd:IsPurgable() return false end
function modifier_abbadon_cd:IsDebuff() return true end