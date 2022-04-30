LinkLuaModifier("item_manta_custom_invulnerable", "abilities/items/item_manta_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_manta_custom_passive", "abilities/items/item_manta_custom", LUA_MODIFIER_MOTION_NONE)


item_manta_custom = class({})


function item_manta_custom:OnSpellStart()
if not IsServer() then return end
    self:GetCaster():EmitSound("DOTA_Item.Manta.Activate")
    self:GetCaster():Purge(false, true, false, false, false)
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "item_manta_custom_invulnerable", {duration = self:GetSpecialValueFor("invuln_duration")})
    ProjectileManager:ProjectileDodge(self:GetCaster())
end


function item_manta_custom:GetIntrinsicModifierName() return  
"item_manta_custom_passive"
end


item_manta_custom_invulnerable = class({})

function item_manta_custom_invulnerable:IsHidden()     return true end
function item_manta_custom_invulnerable:IsPurgable()   return false end

function item_manta_custom_invulnerable:GetEffectName()
    return "particles/items2_fx/manta_phase.vpcf"
end

function item_manta_custom_invulnerable:OnDestroy()
    if not IsServer() or not self:GetParent():IsAlive() or not self:GetAbility() then return end

    if self:GetParent() == self:GetCaster() then
        self:GetParent():Stop()
    end

    local all_illusions = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED  , FIND_ANY_ORDER, false) 
    for _,i in ipairs(all_illusions) do
        if i.manta and i.manta == true then 
            i:ForceKill(false)
        end
    end


    AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("vision_radius"), 1, false)

    local damage = self:GetAbility():GetSpecialValueFor("images_do_damage_percent_melee")
    if self:GetParent():IsRangedAttacker() then     
        damage = self:GetAbility():GetSpecialValueFor("images_do_damage_percent_ranged")
    end

    local illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), {
        outgoing_damage = damage,
        incoming_damage = self:GetAbility():GetSpecialValueFor("images_take_damage_percent"),
        bounty_base     = self:GetCaster():GetLevel()*2, 
        bounty_growth   = nil,
        outgoing_damage_structure   = nil,
        outgoing_damage_roshan      = nil,
        duration        = self:GetAbility():GetSpecialValueFor("tooltip_illusion_duration")
    }
    , self:GetAbility():GetSpecialValueFor("images_count"), 108, true, true)

    if illusions then
        for _, illusion in pairs(illusions) do

            illusion.owner = self:GetCaster()  
            illusion.manta = true   

    
         for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
          if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
            illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
          end
         end

        end
    end


end

function item_manta_custom_invulnerable:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE]       = true,
        [MODIFIER_STATE_NO_HEALTH_BAR]      = true,
        [MODIFIER_STATE_STUNNED]            = true,
        [MODIFIER_STATE_OUT_OF_GAME]        = true,
        
        [MODIFIER_STATE_NO_UNIT_COLLISION]  = true
    }
end




item_manta_custom_passive = class({})
function item_manta_custom_passive:IsHidden() return true end
function item_manta_custom_passive:IsPurgable() return false end
function item_manta_custom_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function item_manta_custom_passive:RemoveOnDeath() return false end
function item_manta_custom_passive:DeclareFunctions()
return
{
   MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
   MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
   MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
   MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT

}
end



function item_manta_custom_passive:GetModifierBonusStats_Agility () return self:GetAbility():GetSpecialValueFor("bonus_agility") end
function item_manta_custom_passive:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function item_manta_custom_passive:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function item_manta_custom_passive:GetModifierMoveSpeedBonus_Percentage_Unique()
if self:GetParent():HasModifier("modifier_item_sange_and_yasha") or self:GetParent():HasModifier("modifier_item_yasha")
or self:GetParent():HasModifier("modifier_item_yasha_and_kaya") then return 0 end
 return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end
function item_manta_custom_passive:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end

