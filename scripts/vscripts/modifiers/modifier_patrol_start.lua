modifier_patrol_start = class({})


function modifier_patrol_start:IsHidden() return true end
function modifier_patrol_start:IsPurgable() return false end
function modifier_patrol_start:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end





modifier_patrol_gospawn = class({})

function modifier_patrol_gospawn:IsHidden() return true end
function modifier_patrol_gospawn:IsPurgable() return false end
function modifier_patrol_gospawn:CheckState()
return
{
  [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end
function modifier_patrol_gospawn:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_patrol_gospawn:GetModifierMoveSpeedBonus_Percentage() return 50 end


modifier_patrol_death = class({})

function modifier_patrol_death:IsHidden() return true end
function modifier_patrol_death:IsPurgable() return false end



function modifier_patrol_death:OnCreated(table)
if not IsServer() then return end
self:GetParent().killer_table = {}
self:StartIntervalThink(0.1)
end


function modifier_patrol_death:OnIntervalThink()
if not IsServer() then return end

for i = 1,12 do 
	if players[i] ~= nil then 

 		AddFOWViewer(i, self:GetParent():GetAbsOrigin(), 500, 0.1, false)
	end
end


end



function modifier_patrol_death:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_DEATH
}
end

function modifier_patrol_death:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end


local killer = params.attacker 

if killer then 

	if killer.owner ~= nil then 
		killer = killer.owner
	end

	if killer:IsRealHero() then 
		if self:GetParent().item ~= nil then 

			local point = self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(-1, 1) + 100)

			EmitSoundOnLocationWithCaster(point, "Patrol_drop", self:GetParent())



			local item = CreateItem(self:GetParent().item, killer, killer)
			item.IsPatrolItem = true
	 		CreateItemOnPositionSync(GetGroundPosition(point, self:GetParent()), item)
	 		item_effect = ParticleManager:CreateParticle( "particles/neutral_fx/neutral_item_drop_lvl2.vpcf", PATTACH_WORLDORIGIN, nil )
	    	ParticleManager:SetParticleControl( item_effect, 0, point )

		end
	end

end


if self:GetParent().friends == nil then return end
local no_friends = true

for _,friend in pairs(self:GetParent().friends) do 
	if not friend:IsNull() and friend:IsAlive() then 

		no_friends = false
	end
end

local team = -1
if killer then
	team = killer:GetTeamNumber()
end

table.insert(my_game.ravager_table, team)



if GameRules:GetDOTATime(false, false) >= patrol_second_tier then
	local count = my_game.ravager_max - #my_game.ravager_table
	CustomGameEventManager:Send_ServerToAllClients( 'patrol_count', {count =  count, max = my_game.ravager_max} )
end


if #my_game.ravager_table >= my_game.ravager_max then


	if GameRules:GetDOTATime(false, false) >= patrol_second_tier then

		local heroes = {}

		for _,player in pairs(players) do 

			local drop = true 
			
			for _,killer_team in pairs(my_game.ravager_table) do 
				if killer_team == player:GetTeamNumber() then 
					drop = false
					break 
				end
			end


			if drop == true and towers[player:GetTeamNumber()] then 

				self.particle3  = ParticleManager:CreateParticle("particles/roshan_meteor_spell_.vpcf", PATTACH_WORLDORIGIN, nil)
		        ParticleManager:SetParticleControl(self.particle3, 0, towers[player:GetTeamNumber()]:GetAbsOrigin() + Vector(0, 0, 1200)) -- 1000 feels kinda arbitrary but it also feels correct
		        ParticleManager:SetParticleControl(self.particle3, 1, towers[player:GetTeamNumber()]:GetAbsOrigin())
		        ParticleManager:SetParticleControl(self.particle3, 2, Vector(0.5, 0, 0))
		        ParticleManager:ReleaseParticleIndex(self.particle3)
		   
		        ScreenShake(Vector(41.3801, 140.545, 277.778), 300, 1.1, 0.7, 12000, 0, true)

		        towers[player:GetTeamNumber()]:AddNewModifier(towers[player:GetTeamNumber()], nil, "modifier_ravager", {})

		        heroes[#heroes + 1] = player:GetUnitName()
		    end


		end

		if #heroes > 0 then 
		   CustomGameEventManager:Send_ServerToAllClients( 'ravager_used',  {heroes = heroes})
		end
	end

	my_game.ravager_table = {}

end

if no_friends == true then 
	if self:GetParent().radiant_patrol == true then 
		
		my_game.radiant_patrol_alive = false

	else 

		my_game.dire_patrol_alive = false
	end
end


end


