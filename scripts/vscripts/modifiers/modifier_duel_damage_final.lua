

modifier_duel_damage_final = class({})


function modifier_duel_damage_final:IsHidden() return false end
function modifier_duel_damage_final:IsPurgable() return false end
function modifier_duel_damage_final:RemoveOnDeath() return false end

function modifier_duel_damage_final:GetTexture() return "buffs/duel_win" end
function modifier_duel_damage_final:GetEffectName()
return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
end


function modifier_duel_damage_final:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}

end


function modifier_duel_damage_final:GetModifierIncomingDamage_Percentage()
    return -15
end

function modifier_duel_damage_final:GetModifierTotalDamageOutgoing_Percentage()
    return 15
end