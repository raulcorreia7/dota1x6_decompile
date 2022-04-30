mid_teleport = class ({})

LinkLuaModifier("modifier_mid_teleport_cd", "abilities/mid_teleport", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mid_teleport_cast", "abilities/mid_teleport", LUA_MODIFIER_MOTION_NONE)


function mid_teleport:GetChannelTime() return 3 end

function mid_teleport:OnSpellStart()
	local hero = self:GetCaster()

	--if self.roshan == false then 
	--	self.point = Vector(38.047356, 150.919510, 343)
	--else {

		
		local point_1 = GetGroundPosition( Vector(1422.55, 1652.11, 103.706), self:GetCaster())
		local point_2 = GetGroundPosition( Vector(-1193.24, -1613.35, 103.706), self:GetCaster())

		if (self:GetCaster():GetAbsOrigin() - point_1):Length2D() > (self:GetCaster():GetAbsOrigin() - point_2):Length2D() then 
			self.point = point_1
		else
			self.point = point_2
		end
	--end

	AddFOWViewer(self:GetCaster():GetTeamNumber(), self.point, 1400, 3, false)

	local duration_cd = teleport_cd


	hero:AddNewModifier(hero, self, "modifier_mid_teleport_cast", {})	
	hero:AddNewModifier(hero, self, "modifier_mid_teleport_cd", { duration = duration_cd })

	teleports[self:GetCaster():GetTeamNumber()]:RemoveGesture(ACT_DOTA_IDLE)
	teleports[self:GetCaster():GetTeamNumber()]:StartGesture(ACT_DOTA_CHANNEL_ABILITY_1)
	teleports[hero:GetTeamNumber()]:EmitSound("Outpost.Channel")
	self.blight_spot = ParticleManager:CreateParticle("particles/world_outpost/world_outpost_channel.vpcf", PATTACH_CUSTOMORIGIN, teleports[hero:GetTeamNumber()])
	ParticleManager:SetParticleControlEnt(self.blight_spot, 0, teleports[hero:GetTeamNumber()], PATTACH_POINT_FOLLOW, "attach_fx", teleports[hero:GetTeamNumber()]:GetAbsOrigin(), true)

	hero:StartGesture(ACT_DOTA_TELEPORT)
	
 	self.teleportFromEffect = ParticleManager:CreateParticle("particles/items2_fx/teleport_start.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(self.teleportFromEffect, 2, Vector(255, 255, 255))
    self.teleport_center = CreateUnitByName("npc_dota_companion", self.point, false, nil, nil, 0)

    EmitSoundOn("Portal.Loop_Appear", self.teleport_center)
    self.teleport_center:AddNewModifier(self.teleport_center, nil, "modifier_phased", {})
    self.teleport_center:AddNewModifier(self.teleport_center, nil, "modifier_invulnerable", {})

    self.teleport_center:SetAbsOrigin(self.point)

    self.teleportToEffect = ParticleManager:CreateParticle("particles/items2_fx/teleport_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.teleport_center)
    ParticleManager:SetParticleControlEnt(self.teleportToEffect, 1, self.teleport_center, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.teleport_center:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(self.teleportToEffect, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.teleport_center:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(self.teleportToEffect, 4, Vector(0.9, 0, 0))
    ParticleManager:SetParticleControlEnt(self.teleportToEffect, 5, self.teleport_center, PATTACH_POINT_FOLLOW, "attach_hitloc", self.teleport_center:GetAbsOrigin(), true)

         


end



function mid_teleport:OnChannelFinish(bInterrupted)

	self:GetCaster():RemoveModifierByName("modifier_mid_teleport_cast")

	ParticleManager:DestroyParticle(self.teleportFromEffect, false)
    ParticleManager:ReleaseParticleIndex(self.teleportFromEffect)
    ParticleManager:DestroyParticle(self.teleportToEffect, false)
    ParticleManager:ReleaseParticleIndex(self.teleportToEffect)
    ParticleManager:DestroyParticle(self.blight_spot, false)
	local hero = self:GetCaster()
	teleports[hero:GetTeamNumber()]:StopSound("Outpost.Channel")

	StopSoundOn("Portal.Loop_Appear", self.teleport_center)
	EmitSoundOn("Portal.Hero_Disappear", hero)
    self.teleport_center:Destroy()

	local ability_name = self:GetAbilityName()
	for i = 0,23 do
		local ability_search = hero:GetAbilityByIndex(i)
		if ability_search ~= nil then
		if ability_search:GetAbilityName() == ability_name then hero:RemoveAbility(ability_name)	
		end
	end

	end
	local point = Entities:FindByName(nil, "mid_teleport"):GetAbsOrigin()
	teleports[hero:GetTeamNumber()]:RemoveGesture(ACT_DOTA_CHANNEL_ABILITY_1)
	teleports[hero:GetTeamNumber()]:StartGesture(ACT_DOTA_IDLE)
	hero:RemoveGesture(ACT_DOTA_TELEPORT)

	if bInterrupted then 

        return 
    end   
	teleports[hero:GetTeamNumber()]:EmitSound("Outpost.Captured")
	hero:SetAbsOrigin(self.point)
	FindClearSpaceForUnit(hero, self.point, true)
	hero:Stop()
	hero:Interrupt()
end


modifier_mid_teleport_cd = class({})

function modifier_mid_teleport_cd:IsDebuff() return true end
function modifier_mid_teleport_cd:IsPurgable() return false end
function modifier_mid_teleport_cd:RemoveOnDeath() return false end
function modifier_mid_teleport_cd:GetTexture() return "item_tpscroll" end

function modifier_mid_teleport_cd:OnDestroy()
if not IsServer() then return end

EmitSoundOnEntityForPlayer("Outpost.Captured.Notification", self:GetParent(), self:GetParent():GetPlayerOwnerID())
 	local t = teleports[self:GetParent():GetTeamNumber()]


    local number = tonumber(t:GetName())



	 if number == DOTA_TEAM_BADGUYS or number == DOTA_TEAM_CUSTOM_3 or number == DOTA_TEAM_CUSTOM_4 then
 		t.ray = ParticleManager:CreateParticle("particles/world_outpost/world_outpost_dire_ambient.vpcf", PATTACH_CUSTOMORIGIN, t)
 	end
 	if number == DOTA_TEAM_GOODGUYS or number == DOTA_TEAM_CUSTOM_1 or number == DOTA_TEAM_CUSTOM_2 then
 		t.ray = ParticleManager:CreateParticle("particles/world_outpost/world_outpost_radiant_ambient.vpcf", PATTACH_CUSTOMORIGIN, t)
 	end



	ParticleManager:SetParticleControlEnt(t.ray, 0, t, PATTACH_POINT_FOLLOW, "attach_fx", t:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(t.ray, 1, t, PATTACH_POINT_FOLLOW, "attach_fx", t:GetAbsOrigin(), true)

end

function modifier_mid_teleport_cd:OnCreated(table)
if not IsServer() then return end	
	if teleports[self:GetParent():GetTeamNumber()].ray then
   	  ParticleManager:DestroyParticle(teleports[self:GetParent():GetTeamNumber()].ray, false)
	end
end


modifier_mid_teleport_cast = class({})

function modifier_mid_teleport_cast:IsHidden() return true end
function modifier_mid_teleport_cast:IsPurgable() return false end