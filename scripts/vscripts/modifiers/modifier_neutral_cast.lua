

modifier_neutral_cast = class({})


function modifier_neutral_cast:IsHidden() return true end
function modifier_neutral_cast:IsPurgable() return false end

function modifier_neutral_cast:CheckState() return {[MODIFIER_STATE_DISARMED] = true,
[MODIFIER_STATE_ROOTED] = true } end


function modifier_neutral_cast:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_DISABLE_TURNING
}

end



function modifier_neutral_cast:GetModifierDisableTurning() 
return 1
 end 