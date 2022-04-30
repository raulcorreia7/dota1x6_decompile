LinkLuaModifier("modifier_werewolf_bloodrage", "abilities/npc_werewolf_bloodrage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_werewolf_cd", "abilities/npc_werewolf_bloodrage", LUA_MODIFIER_MOTION_NONE)

npc_werewolf_bloodrage = class({})

function npc_werewolf_bloodrage:OnAbilityPhaseStart()
    self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
    self:GetCaster():EmitSound("hero_bloodseeker.bloodRage")
       return true
end 


function npc_werewolf_bloodrage:OnSpellStart()

    if not IsServer() then
        return
      end

 self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_werewolf_cd", {duration = self:GetCooldownTimeRemaining()})
        local duration = self:GetSpecialValueFor("duration")
      
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_werewolf_bloodrage", {duration = duration})

end

modifier_werewolf_bloodrage = class({})

function modifier_werewolf_bloodrage:IsHidden() return false end

function modifier_werewolf_bloodrage:IsPurgable() return true end

function modifier_werewolf_bloodrage:OnCreated(table)
self.speed = self:GetAbility():GetSpecialValueFor("speed")
    if not IsServer() then
        return
    end
end

function modifier_werewolf_bloodrage:DeclareFunctions()
return
{
     MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
     MODIFIER_PROPERTY_TOOLTIP,
     MODIFIER_PROPERTY_TOOLTIP2
 
}
end

function modifier_werewolf_bloodrage:OnTooltip() return self:GetAbility():GetSpecialValueFor("speed") end
function modifier_werewolf_bloodrage:OnTooltip2() return self:GetAbility():GetSpecialValueFor("heal") end


function modifier_werewolf_bloodrage:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = true} end

function modifier_werewolf_bloodrage:GetModifierAttackSpeedBonus_Constant() return self.speed end

function modifier_werewolf_bloodrage:GetEffectName() return "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf" end
 
function modifier_werewolf_bloodrage:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_werewolf_bloodrage:DoScript()
if not IsServer() then
        return
    end
    local heal = self:GetAbility():GetSpecialValueFor("heal")
    heal = self:GetParent():GetMaxHealth()*(heal/100)
    self:GetParent():Heal(heal, self:GetParent())

end


modifier_werewolf_cd = class({})
function modifier_werewolf_cd:IsHidden() return false end
function modifier_werewolf_cd:IsPurgable() return false end
