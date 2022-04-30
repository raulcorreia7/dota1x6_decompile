

modifier_duel_finish = class({})


function modifier_duel_finish:IsHidden() return true end
function modifier_duel_finish:IsPurgable() return false end
function modifier_duel_finish:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true} end