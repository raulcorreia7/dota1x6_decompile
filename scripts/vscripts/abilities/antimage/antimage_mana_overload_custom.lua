LinkLuaModifier("modifier_antimage_mana_overload_custom_illusion", "abilities/antimage/antimage_mana_overload_custom", LUA_MODIFIER_MOTION_NONE)

antimage_mana_overload_custom = class({})

function antimage_mana_overload_custom:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() then
        self:SetHidden(false)       
        if not self:IsTrained() then
            self:SetLevel(1)
        end
    else
        self:SetHidden(true)
    end
end

function antimage_mana_overload_custom:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end

function antimage_mana_overload_custom:OnSpellStart()
	if not IsServer() then return end

	local point = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor("duration")

	local outgoing_damage = self:GetSpecialValueFor("outgoing_damage")

	local incoming_damage = self:GetSpecialValueFor("incoming_damage")	

	local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), {duration=duration,outgoing_damage=outgoing_damage,incoming_damage=incoming_damage}, 1, 0, false, false )  

	for k, v in pairs(illusion) do
		v.illusion_counter_spell = true
		--v:SetControllableByPlayer(-1, true)
		v.owner = self:GetCaster()
		v:AddNewModifier(self:GetCaster(), self, "modifier_antimage_mana_overload_custom_illusion", {})

		local direction = (point - v:GetAbsOrigin())
		direction.z = 0
		direction = direction:Normalized()


		local particle_start = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", PATTACH_ABSORIGIN, v )
		ParticleManager:SetParticleControl( particle_start, 0, v:GetAbsOrigin() )
		ParticleManager:SetParticleControlForward( particle_start, 0, direction:Normalized() )
		ParticleManager:ReleaseParticleIndex( particle_start )
		EmitSoundOnLocationWithCaster( v:GetAbsOrigin(), "Hero_Antimage.Blink_out", v )

    	FindClearSpaceForUnit(v, point, true)

    	v:StartGesture(ACT_DOTA_CAST_ABILITY_2)

		local particle_end = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", PATTACH_ABSORIGIN, v )
		ParticleManager:SetParticleControl( particle_end, 0, v:GetOrigin() )
		ParticleManager:SetParticleControlForward( particle_end, 0, direction:Normalized() )
		ParticleManager:ReleaseParticleIndex( particle_end )
		EmitSoundOnLocationWithCaster( v:GetOrigin(), "Hero_Antimage.Blink_in", v )

    	Timers:CreateTimer(0.1, function()
    		v:MoveToPositionAggressive(point)
    	end)
    end
end






modifier_antimage_mana_overload_custom_illusion = class({})
function modifier_antimage_mana_overload_custom_illusion:IsHidden() return false end
function modifier_antimage_mana_overload_custom_illusion:IsPurgable() return false end




function modifier_antimage_mana_overload_custom_illusion:CheckState()
return
{
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
}
end