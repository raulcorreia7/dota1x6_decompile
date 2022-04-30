LinkLuaModifier("modifier_custom_ability_teleport", "abilities/items/item_tpscroll", LUA_MODIFIER_MOTION_NONE)

item_tpscroll_custom = class({})

function item_tpscroll_custom:GetChannelTime() 


    if self:GetCaster():HasModifier("modifier_item_travel_boots_custom")
    	or self:GetCaster():HasModifier("modifier_item_travel_boots_2_custom") then 
    		return self:GetSpecialValueFor("channel_time_travel") 
    end

	return self:GetSpecialValueFor("channel_time") 
end

function item_tpscroll_custom:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function item_tpscroll_custom:IsHiddenAbilityCastable()
    return true
end

function item_tpscroll_custom:OnSpellStart()
	if not IsServer() then return end

	local hero = self:GetCaster()

	self.point = towers[hero:GetTeamNumber()]:GetAbsOrigin() + RandomVector(220)
	self.point = GetGroundPosition(self.point, nil)
	self.point_start = self:GetCaster():GetAbsOrigin()

	hero:StartGesture(ACT_DOTA_TELEPORT)

	hero:AddNewModifier(self:GetCaster(), self, "modifier_custom_ability_teleport", {duration = self:GetChannelTime()})
 	self.teleportFromEffect = ParticleManager:CreateParticle("particles/items2_fx/teleport_start.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(self.teleportFromEffect, 2, Vector(255, 255, 255))
    self.teleport_center = CreateUnitByName("npc_dota_companion", self.point, false, nil, nil, 0)

    self:GetCaster():EmitSound("Portal.Loop_Appear")
    EmitSoundOn("Portal.Loop_Appear", self.teleport_center)

    self.teleport_center:AddNewModifier(self.teleport_center, nil, "modifier_phased", {})
    self.teleport_center:AddNewModifier(self.teleport_center, nil, "modifier_invulnerable", {})
    self.teleport_center:SetAbsOrigin(self.point)

    self.teleportToEffect = ParticleManager:CreateParticle("particles/items2_fx/teleport_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.teleport_center)
    ParticleManager:SetParticleControlEnt(self.teleportToEffect, 1, self.teleport_center, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.teleport_center:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(self.teleportToEffect, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.teleport_center:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(self.teleportToEffect, 4, Vector(0.9, 0, 0))
    ParticleManager:SetParticleControlEnt(self.teleportToEffect, 5, self.teleport_center, PATTACH_POINT_FOLLOW, "attach_hitloc", self.teleport_center:GetAbsOrigin(), true)


    local modifier_travel_boots = self:GetCaster():FindModifierByName("modifier_item_travel_boots_custom")
	local modiifer_travel_boots_2 = self:GetCaster():FindModifierByName("modifier_item_travel_boots_2_custom")

	if modiifer_travel_boots_2 then
		if modiifer_travel_boots_2:GetAbility() then
			self:EndCooldown()
			self:StartCooldown( modiifer_travel_boots_2:GetAbility():GetSpecialValueFor("tp_cooldown") * self:GetCaster():GetCooldownReduction() )
			return
		end
	end

	if modifier_travel_boots then
		if modifier_travel_boots:GetAbility() then
			self:EndCooldown()
			self:StartCooldown( modifier_travel_boots:GetAbility():GetSpecialValueFor("tp_cooldown") * self:GetCaster():GetCooldownReduction() )
		end
	end
end

function item_tpscroll_custom:OnChannelFinish(bInterrupted)
	if not IsServer() then return end
	self:GetCaster():RemoveModifierByName("modifier_custom_ability_teleport")
	
	local hero = self:GetCaster()

	StopSoundOn("Portal.Loop_Appear", self.teleport_center)
	self:GetCaster():StopSound("Portal.Loop_Appear")

    self.teleport_center:Destroy()
	self:GetCaster():RemoveGesture(ACT_DOTA_TELEPORT)

	if bInterrupted then 
		ParticleManager:DestroyParticle(self.teleportFromEffect, true)
    	ParticleManager:ReleaseParticleIndex(self.teleportFromEffect)
    	ParticleManager:DestroyParticle(self.teleportToEffect, true)
   		ParticleManager:ReleaseParticleIndex(self.teleportToEffect)

        return 
    end   

	ParticleManager:DestroyParticle(self.teleportFromEffect, false)
    ParticleManager:ReleaseParticleIndex(self.teleportFromEffect)
    ParticleManager:DestroyParticle(self.teleportToEffect, false)
    ParticleManager:ReleaseParticleIndex(self.teleportToEffect)

    EmitSoundOnLocationWithCaster(self.point_start, "Portal.Hero_Disappear", self:GetCaster())
	self:GetCaster():SetAbsOrigin(self.point)
	FindClearSpaceForUnit(self:GetCaster(), self.point, true)
	self:GetCaster():Stop()
	self:GetCaster():Interrupt()
	EmitSoundOn("Portal.Hero_Disappear", self:GetCaster())
	self:GetCaster():StartGesture(ACT_DOTA_TELEPORT_END)

end

function item_tpscroll_custom:OnChannelThink(fInterval)
    if self:GetCaster():IsRooted() or self:GetCaster():HasModifier("modifier_custom_puck_dream_coil") then
        self:GetCaster():Stop()
        self:GetCaster():Interrupt()
    end
end

modifier_custom_ability_teleport = class({})

function modifier_custom_ability_teleport:IsHidden() return false end
function modifier_custom_ability_teleport:IsPurgable() return false end

function modifier_custom_ability_teleport:CheckState()
	if not self:GetParent():HasModifier("modifier_item_travel_boots_2_custom") then
		return
	end
    
    return {
			[MODIFIER_STATE_MAGIC_IMMUNE] = true
		}
end
function modifier_custom_ability_teleport:GetEffectName()
if self:GetCaster():HasModifier("modifier_item_travel_boots_2_custom") then
	return "particles/items_fx/black_king_bar_avatar.vpcf"
end

end



function modifier_custom_ability_teleport:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }
end

function modifier_custom_ability_teleport:GetOverrideAnimation()
	return ACT_DOTA_TELEPORT
end
