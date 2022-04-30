

modifier_unselect = class({})


function modifier_unselect:IsHidden() return false end
function modifier_unselect:IsPurgable() return false end



function modifier_unselect:CheckState()
    return {
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
    }
end

function modifier_unselect:RemoveOnDeath() return false end

