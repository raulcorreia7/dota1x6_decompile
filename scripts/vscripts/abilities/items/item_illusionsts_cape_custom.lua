LinkLuaModifier("item_illusionsts_cape_custom_aura", "abilities/items/item_illusionsts_cape_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_illusionsts_cape_custom_aura_damage", "abilities/items/item_illusionsts_cape_custom", LUA_MODIFIER_MOTION_NONE)


item_illusionsts_cape_custom = class({})



function item_illusionsts_cape_custom:GetIntrinsicModifierName() return "item_illusionsts_cape_custom_aura" end

function item_illusionsts_cape_custom:OnSpellStart()
if not IsServer() then return end

    local illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), {
        outgoing_damage = self:GetSpecialValueFor("outgoing_damage"),
        incoming_damage = self:GetSpecialValueFor("incoming_damage"),
        bounty_base     = self:GetCaster():GetLevel()*2, 
        bounty_growth   = nil,
        outgoing_damage_structure   = nil,
        outgoing_damage_roshan      = nil,
        duration        = self:GetSpecialValueFor("illusion_duration")
    }
    , 1, 108, true, true)

    if illusions then
        for _, illusion in pairs(illusions) do

            illusion.owner = self:GetCaster()    
            illusion.cape = true
    
         for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
          if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
            illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
          end
         end

        end
    end

end



item_illusionsts_cape_custom_aura = class({})

function item_illusionsts_cape_custom_aura:IsPurgable() return false end

function item_illusionsts_cape_custom_aura:IsHidden() return true end

function item_illusionsts_cape_custom_aura:IsAura() return true end

function item_illusionsts_cape_custom_aura:GetAuraDuration() return 0.1 end

function item_illusionsts_cape_custom_aura:GetAuraRadius() return FIND_UNITS_EVERYWHERE end

function item_illusionsts_cape_custom_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function item_illusionsts_cape_custom_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end


function item_illusionsts_cape_custom_aura:GetAuraEntityReject(hTarget)
    return hTarget == self:GetParent() or self:GetParent():IsIllusion() or 
    not hTarget:IsIllusion() or hTarget:GetPlayerOwnerID() ~= self:GetCaster():GetPlayerOwnerID() 
    or hTarget:HasModifier("modifier_terrorblade_reflection_invulnerability")
end


function item_illusionsts_cape_custom_aura:GetModifierAura() return "item_illusionsts_cape_custom_aura_damage" end


function item_illusionsts_cape_custom_aura:DeclareFunctions()
return
{
   MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
   MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,

}
end



function item_illusionsts_cape_custom_aura:GetModifierBonusStats_Agility () return self:GetAbility():GetSpecialValueFor("bonus_agi") end
function item_illusionsts_cape_custom_aura:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_str") end




item_illusionsts_cape_custom_aura_damage = class({})

function item_illusionsts_cape_custom_aura_damage:IsHidden() return false end
function item_illusionsts_cape_custom_aura_damage:IsPurgable() return false end
function item_illusionsts_cape_custom_aura_damage:OnDestroy()
if not IsServer() then return end
if self:GetParent().cape and self:GetParent().cape == true then
    self:GetParent():ForceKill(false)
end
end
function item_illusionsts_cape_custom_aura_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function item_illusionsts_cape_custom_aura_damage:GetModifierDamageOutgoing_Percentage()
return
self:GetAbility():GetSpecialValueFor("attack_damage_aura")
end




