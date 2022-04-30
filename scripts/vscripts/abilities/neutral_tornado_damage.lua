LinkLuaModifier("modifier_tornado_think", "abilities/neutral_tornado_damage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tornado_think_slow", "abilities/neutral_tornado_damage", LUA_MODIFIER_MOTION_NONE)





neutral_tornado_damage = class({})

function neutral_tornado_damage:GetIntrinsicModifierName() return "modifier_tornado_think" end 





modifier_tornado_think = class({})

function modifier_tornado_think:IsPurgable() return false end

function modifier_tornado_think:IsHidden() return true end

function modifier_tornado_think:DeclareFunctions() return 
{

MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_DEATH

    } end


    function modifier_tornado_think:GetAbsoluteNoDamageMagical() return 1 end

     function modifier_tornado_think:GetAbsoluteNoDamagePhysical() return 1 end

     function modifier_tornado_think:GetAbsoluteNoDamagePure() return 1 end

function modifier_tornado_think:OnAttackLanded( param )
 if not IsServer() then
        return
    end

    if self:GetParent() == param.target then
     self.health = self.health - 1
     self:GetParent():SetHealth(self.health)

        if self.health <= 0 then
            self:GetParent():Kill(nil, param.attacker)
        end

    end

end


function modifier_tornado_think:OnCreated(table)
if not IsServer() then return end
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.health = self:GetAbility():GetSpecialValueFor("health")
self.duration = self:GetAbility():GetSpecialValueFor("duration")
self.slow = self:GetAbility():GetSpecialValueFor("slow")
self.aoe = self:GetAbility():GetSpecialValueFor("aoe")

self:StartIntervalThink(1)
end

function modifier_tornado_think:OnIntervalThink()
if not IsServer() then return end

   local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
      for _,target in ipairs(targets) do
        if not target:IsMagicImmune() then  
             ApplyDamage({victim = target, attacker = self:GetParent(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
         	target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tornado_think_slow", {duration = 1.5*(1 - target:GetStatusResistance()), slow = self.slow})
         end   
     end


end


function modifier_tornado_think:GetEffectName() return "particles/creatures/enraged_wildkin/enraged_wildkin_tornado.vpcf" end

modifier_tornado_think_slow = class({})

function modifier_tornado_think_slow:IsHidden() return false  end

function modifier_tornado_think_slow:GetTexture() return "enraged_wildkin_tornado" end

function modifier_tornado_think_slow:IsPurgable() return true end

function modifier_tornado_think_slow:IsDebuff() return true end

function modifier_tornado_think_slow:OnCreated(table)
if not IsServer() then return end
 self:SetHasCustomTransmitterData(true)
self.slow = -table.slow
end

function modifier_tornado_think_slow:DeclareFunctions()

  return 
{

         MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
         MODIFIER_PROPERTY_TOOLTIP,
         MODIFIER_PROPERTY_TOOLTIP2
}

end


function modifier_tornado_think_slow:OnTooltip() return self:GetAbility():GetSpecialValueFor("slow") end
function modifier_tornado_think_slow:OnTooltip2() return self:GetAbility():GetSpecialValueFor("damage") end
 


function modifier_tornado_think_slow:AddCustomTransmitterData() return {
slow = self.slow


} end

function modifier_tornado_think_slow:HandleCustomTransmitterData(data)
self.slow = data.slow
end






function modifier_tornado_think_slow:GetModifierAttackSpeedBonus_Constant() return self.slow end