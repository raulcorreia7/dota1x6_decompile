LinkLuaModifier("modifier_item_force_boots_custom", "abilities/items/item_force_boots_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_force_boots_custom_active", "abilities/items/item_force_boots_custom", LUA_MODIFIER_MOTION_HORIZONTAL)

item_force_boots_custom = class({})

function item_force_boots_custom:GetIntrinsicModifierName()
    return "modifier_item_force_boots_custom"
end

function item_force_boots_custom:OnSpellStart()
    if not IsServer() then return end
    local target = self:GetCaster()


    self:GetCaster():Purge(false, true, false, false, false)


    target:EmitSound("DOTA_Item.Force_Boots.Cast")

    target:AddNewModifier(self:GetCaster(), self, "modifier_item_force_boots_custom_active", {duration = self:GetSpecialValueFor("push_duration")})

end

modifier_item_force_boots_custom = class({})

function modifier_item_force_boots_custom:IsHidden()      return true end
function modifier_item_force_boots_custom:IsPurgable()        return false end
function modifier_item_force_boots_custom:RemoveOnDeath() return false end
function modifier_item_force_boots_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_force_boots_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,

    }
end




function modifier_item_force_boots_custom:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("hp_regen")
end

function modifier_item_force_boots_custom:GetModifierMoveSpeedBonus_Special_Boots() 
    return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end



modifier_item_force_boots_custom_active = class({})

function modifier_item_force_boots_custom_active:IsDebuff() return false end
function modifier_item_force_boots_custom_active:IsHidden() return true end

function modifier_item_force_boots_custom_active:OnCreated()
    if not IsServer() then return end
    self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:GetParent():StartGesture(ACT_DOTA_FLAIL)
    self.angle = self:GetParent():GetForwardVector():Normalized()
    self.distance = self:GetAbility():GetSpecialValueFor("push_length") / ( self:GetDuration() / FrameTime())

    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end
end

function modifier_item_force_boots_custom_active:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_item_force_boots_custom_active:StatusEffectPriority() return 100 end

function modifier_item_force_boots_custom_active:OnDestroy()
    if not IsServer() then return end
    self:GetParent():InterruptMotionControllers( true )
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)
    self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end


function modifier_item_force_boots_custom_active:UpdateHorizontalMotion( me, dt )
    if not IsServer() then return end
    local pos = self:GetParent():GetAbsOrigin()
    GridNav:DestroyTreesAroundPoint(pos, 80, false)
    local pos_p = self.angle * self.distance
    local next_pos = GetGroundPosition(pos + pos_p,self:GetParent())
    self:GetParent():SetAbsOrigin(next_pos)
end

function modifier_item_force_boots_custom_active:OnHorizontalMotionInterrupted()
    self:Destroy()
end
