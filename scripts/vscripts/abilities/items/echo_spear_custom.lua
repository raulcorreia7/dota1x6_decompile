LinkLuaModifier("modifier_item_echo_spear_custom", "abilities/items/echo_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_echo_spear_custom_active", "abilities/items/echo_spear_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_item_echo_spear_custom_caster", "abilities/items/echo_spear_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_item_echo_spear_custom_enemy", "abilities/items/echo_spear_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_item_echo_spear_speed", "abilities/items/echo_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_echo_spear_cd", "abilities/items/echo_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_echo_spear_slow", "abilities/items/echo_spear_custom", LUA_MODIFIER_MOTION_NONE)

item_echo_spear_custom = class({})

function item_echo_spear_custom:GetIntrinsicModifierName()
    return "modifier_item_echo_spear_custom"
end

function item_echo_spear_custom:OnSpellStart()
    if not IsServer() then return end
    local target = self:GetCursorTarget()

    if self:GetCaster():HasModifier("modifier_item_echo_spear_cd") then 
        self:GetCaster():RemoveModifierByName("modifier_item_echo_spear_cd")
    end

    if self:GetCaster():GetTeamNumber() == target:GetTeamNumber() then
        target:EmitSound("DOTA_Item.HurricanePike.Activate")
        target:AddNewModifier(self:GetCaster(), self, "modifier_item_echo_spear_custom_active", {duration = 0.4})
    else
        if target:TriggerSpellAbsorb(self) then
            return nil
        end
        target:EmitSound("DOTA_Item.HurricanePike.Activate")
        self:GetCaster():EmitSound("DOTA_Item.HurricanePike.Activate")
        target:AddNewModifier(self:GetCaster(), self, "modifier_item_echo_spear_custom_enemy", {})
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_echo_spear_custom_caster", {target = target:entindex()})
    end
end

modifier_item_echo_spear_custom = class({})

function modifier_item_echo_spear_custom:IsHidden()      return true end
function modifier_item_echo_spear_custom:IsPurgable()        return false end
function modifier_item_echo_spear_custom:RemoveOnDeath() return false end
function modifier_item_echo_spear_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_echo_spear_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_FAIL,

    }
end


function modifier_item_echo_spear_custom:StartSpeed(target, slow)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_echo_spear_cd", {duration = 6*self:GetParent():GetCooldownReduction()})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_echo_spear_speed", {})

for i = 0,8 do 
    local item = self:GetParent():GetItemInSlot(i)
    if item and item:GetName() == "item_echo_sabre" then 
        item:StartCooldown(6*self:GetParent():GetCooldownReduction())
    end
end

if self:GetAbility() and not target:IsBuilding() and not target:IsMagicImmune() and slow then 
    target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_echo_spear_slow", {duration = 0.8})
end

end


function modifier_item_echo_spear_custom:OnAttackFail(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.attacker:FindAllModifiersByName(self:GetName())[1] ~= self then return end 
if self:GetParent():HasModifier("modifier_item_echo_spear_cd") then return end
if self:GetParent():IsRangedAttacker() then return end

self:StartSpeed(params.target, false)
end


function modifier_item_echo_spear_custom:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.attacker:FindAllModifiersByName(self:GetName())[1] ~= self then return end 
if self:GetParent():HasModifier("modifier_item_echo_spear_cd") then return end
if self:GetParent():IsRangedAttacker() then return end


self:StartSpeed(params.target, true)


end


function modifier_item_echo_spear_custom:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_echo_spear_custom:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end



function modifier_item_echo_spear_custom:GetModifierConstantManaRegen()
    return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_item_echo_spear_custom:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_speed")
end

function modifier_item_echo_spear_custom:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_echo_spear_custom:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_strength")
end



modifier_item_echo_spear_custom_active = class({})

function modifier_item_echo_spear_custom_active:IsDebuff() return false end
function modifier_item_echo_spear_custom_active:IsHidden() return true end

function modifier_item_echo_spear_custom_active:OnCreated()
    if not IsServer() then return end
    self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:GetParent():StartGesture(ACT_DOTA_FLAIL)
    self.angle = self:GetParent():GetForwardVector():Normalized()
    self.distance = self:GetAbility():GetSpecialValueFor("push_length") / ( self:GetDuration() / FrameTime())

    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end
end

function modifier_item_echo_spear_custom_active:DeclareFunctions()
return
{
   -- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
  --  MODIFIER_PROPERTY_DISABLE_TURNING
}
end

function modifier_item_echo_spear_custom_active:GetActivityTranslationModifiers()
--return "haste"
end


--function modifier_item_echo_spear_custom_active:GetModifierDisableTurning() return 1 end


function modifier_item_echo_spear_custom_active:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_item_echo_spear_custom_active:StatusEffectPriority() return 100 end

function modifier_item_echo_spear_custom_active:OnDestroy()
    if not IsServer() then return end
    self:GetParent():InterruptMotionControllers( true )
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)
    self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end


function modifier_item_echo_spear_custom_active:UpdateHorizontalMotion( me, dt )
    if not IsServer() then return end
    local pos = self:GetParent():GetAbsOrigin()
    GridNav:DestroyTreesAroundPoint(pos, 80, false)
    local pos_p = self.angle * self.distance
    local next_pos = GetGroundPosition(pos + pos_p,self:GetParent())
    self:GetParent():SetAbsOrigin(next_pos)
end

function modifier_item_echo_spear_custom_active:OnHorizontalMotionInterrupted()
    self:Destroy()
end

--///////////////////

modifier_item_echo_spear_custom_caster = class({})

function modifier_item_echo_spear_custom_caster:IsDebuff() return false end
function modifier_item_echo_spear_custom_caster:IsHidden() return true end

function modifier_item_echo_spear_custom_caster:OnCreated(params)
    if not IsServer() then return end
    self.target = EntIndexToHScript(params.target)
    self.speed = 1000
    self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

    self:GetParent():StartGesture(ACT_DOTA_FLAIL)

    self.angle = (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
    self.point = (self:GetParent():GetAbsOrigin() + self.target:GetAbsOrigin()) / 2

    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end
end

function modifier_item_echo_spear_custom_caster:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_item_echo_spear_custom_caster:StatusEffectPriority() return 100 end

function modifier_item_echo_spear_custom_caster:OnDestroy()
    if not IsServer() then return end
    self:GetParent():InterruptMotionControllers( true )
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)

    self:GetParent():FadeGesture(ACT_DOTA_FLAIL)

    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

    if not self:GetParent():IsChanneling() then 
         self:GetParent():MoveToTargetToAttack(self.target)
    end
end


function modifier_item_echo_spear_custom_caster:UpdateHorizontalMotion( me, dt )
    if not IsServer() then return end
    local origin = self:GetParent():GetOrigin()
    if not self.target:IsAlive() then
        self:Destroy()
    end
    local direction = self.point - origin
    direction.z = 0
    local distance = direction:Length2D()
    direction = direction:Normalized()

    local flPad = self:GetParent():GetPaddedCollisionRadius()

    if distance<flPad then
        self:Destroy()
    elseif distance>1500 then
        self:Destroy()
    end

    GridNav:DestroyTreesAroundPoint(origin, 80, false)
    local target = origin + direction * self.speed * dt
    self:GetParent():SetOrigin( target )
    self:GetParent():FaceTowards( self.target:GetOrigin() )
end

function modifier_item_echo_spear_custom_caster:OnHorizontalMotionInterrupted()
    self:Destroy()
end

modifier_item_echo_spear_custom_enemy = class({})

function modifier_item_echo_spear_custom_enemy:IsDebuff() return false end
function modifier_item_echo_spear_custom_enemy:IsHidden() return true end

function modifier_item_echo_spear_custom_enemy:OnCreated(params)
    if not IsServer() then return end
    self.target = self:GetCaster()
    self.speed = 1000
    self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:GetParent():StartGesture(ACT_DOTA_FLAIL)
    self.angle = (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
    self.point = (self:GetParent():GetAbsOrigin() + self.target:GetAbsOrigin()) / 2

    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end
end

function modifier_item_echo_spear_custom_enemy:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_item_echo_spear_custom_enemy:StatusEffectPriority() return 100 end

function modifier_item_echo_spear_custom_enemy:OnDestroy()
    if not IsServer() then return end
    self:GetParent():InterruptMotionControllers( true )
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)
    self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

    if not self:GetParent():IsChanneling() and self:GetParent():IsHero() then 
         self:GetParent():MoveToTargetToAttack(self:GetCaster())
    end
end


function modifier_item_echo_spear_custom_enemy:UpdateHorizontalMotion( me, dt )
    if not IsServer() then return end
    local origin = self:GetParent():GetOrigin()
    if not self.target:IsAlive() then
        self:Destroy()
    end
    local direction = self.point - origin
    direction.z = 0
    local distance = direction:Length2D()
    direction = direction:Normalized()

    local flPad = self:GetParent():GetPaddedCollisionRadius()

    if distance<flPad then
        self:Destroy()
    elseif distance>1500 then
        self:Destroy()
    end

    GridNav:DestroyTreesAroundPoint(origin, 80, false)
    local target = origin + direction * self.speed * dt
    self:GetParent():SetOrigin( target )
    self:GetParent():FaceTowards( self.target:GetOrigin() )
end

function modifier_item_echo_spear_custom_enemy:OnHorizontalMotionInterrupted()
    self:Destroy()
end


modifier_item_echo_spear_cd = class({})
function modifier_item_echo_spear_cd:IsHidden() return false end
function modifier_item_echo_spear_cd:IsPurgable() return false end
function modifier_item_echo_spear_cd:RemoveOnDeath() return false end
function modifier_item_echo_spear_cd:IsDebuff() return true end



modifier_item_echo_spear_speed = class({})
function modifier_item_echo_spear_speed:IsHidden() return true end
function modifier_item_echo_spear_speed:IsPurgable() return false end
function modifier_item_echo_spear_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_ATTACK_FAIL
}
end

function modifier_item_echo_spear_speed:GetModifierAttackSpeedBonus_Constant()

return 500
end

function modifier_item_echo_spear_speed:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0.2)
end

function modifier_item_echo_spear_speed:OnIntervalThink()
if self:GetParent():IsRangedAttacker() or not self:GetAbility() then 
    self:Destroy()
end

end

function modifier_item_echo_spear_speed:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():IsRangedAttacker() then return end

if self:GetAbility() and not params.target:IsBuilding() and not params.target:IsMagicImmune() then 
    params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_echo_spear_slow", {duration = 0.8})
end

self:Destroy()

end

function modifier_item_echo_spear_speed:OnAttackFail(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():IsRangedAttacker() then return end


self:Destroy()

end



modifier_item_echo_spear_slow = class({})
function modifier_item_echo_spear_slow:IsHidden() return false end
function modifier_item_echo_spear_slow:IsPurgable() return true end
function modifier_item_echo_spear_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_item_echo_spear_slow:GetModifierMoveSpeedBonus_Percentage()
return -100
end

