

modifier_target = class({})


function modifier_target:IsHidden() return false end
function modifier_target:IsPurgable() return false end
function modifier_target:IsDebuff() return true end
function modifier_target:GetTexture() return "buffs/odds_fow" end
function modifier_target:GetEffectName() return
"particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_track_trail.vpcf"
end


function modifier_target:OnCreated(table)
if not IsServer() then return end

self.attackers = {}

CustomGameEventManager:Send_ServerToAllClients('TargetAttack',  {hero = self:GetParent():GetUnitName()})

self:StartIntervalThink(10)

self.gold = Streak_k*100
self.init = false
self:SetHasCustomTransmitterData(true)
end


function modifier_target:OnIntervalThink()
if not IsServer() then return end
	for id = 0,24 do
		if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0  then 
			
			local hero = PlayerResource:GetSelectedHeroEntity(id)
			if hero and hero ~= self:GetParent() and players[hero:GetTeamNumber()] ~= nil then 
				local net_target = PlayerResource:GetNetWorth(id)
				local net_self = PlayerResource:GetNetWorth(self:GetParent():GetPlayerID()) 

				bonus_gold = 0

 				if net_self > net_target then 
 					bonus_gold = (net_self - net_target)*Streak_k
 				end
 				local time = math.floor(self:GetRemainingTime())
 				bonus_gold = math.floor(bonus_gold)

 				if self.init == false then
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'TargetTimer',  {gold = bonus_gold, hero = self:GetParent():GetUnitName(), time = time})
				else 
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'TargetTimer_change',  {gold = bonus_gold, hero = self:GetParent():GetUnitName(), time = time})
				end
			end

		end
	end

	if self.init == false then 
		self.init = true 
	end

	self:StartIntervalThink(1)
end

 


			

function modifier_target:AddCustomTransmitterData() return {
gold = self.gold,


} end

function modifier_target:HandleCustomTransmitterData(data)
self.gold = data.gold
end

function modifier_target:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_target:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end

if params.attacker:IsHero() or params.attacker.owner ~= nil then 
	return 20
end

end


function modifier_target:OnTakeDamage(params)
if not IsServer() then return end
if not params.attacker then return end
if params.attacker:GetTeamNumber() == DOTA_TEAM_CUSTOM_5 or params.attacker:GetTeamNumber() == DOTA_TEAM_NEUTRALS then return end
if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if params.unit ~= self:GetParent() then return end

local new = true

if #self.attackers > 0 then 

	for i = 1,#self.attackers do 
		if self.attackers[i][1] == params.attacker:GetTeamNumber() then 
			new = false
			self.attackers[i][2] = GameRules:GetDOTATime(false, false)
			break
		end
	end

end


if new == true then 
	local n = #self.attackers + 1
	self.attackers[n] = {}
	self.attackers[n][1] = params.attacker:GetTeamNumber()
	self.attackers[n][2] = GameRules:GetDOTATime(false, false)
end

end



function modifier_target:GetModifierProvidesFOWVision()
return 1
end

function modifier_target:OnTooltip()
return self.gold
end


function modifier_target:RemoveOnDeath() return false end

function modifier_target:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if params.attacker == nil then return end
if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end

local attacker = params.attacker

if attacker.owner ~= nil then 
	attacker = attacker.owner
end

if not attacker:IsRealHero() then return end


local heroes = {}

for _,a in pairs(self.attackers) do 
	if a[1] ~= attacker:GetTeamNumber() and (GameRules:GetDOTATime(false, false) - a[2]) < 15 then 
		if players[a[1]] ~= nil then 
			heroes[#heroes+1] = players[a[1]]
		end
	end
end

local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	
for _,enemy in pairs(enemies) do 
	local new = true

	for _,old in pairs(heroes) do 
		if old == enemy then 
			new = false
			break
		end
	end
	if new == true then 
		table.insert(heroes, enemy)
	end
end



local net_self = PlayerResource:GetNetWorth(self:GetParent():GetPlayerID()) 


for _,hero in pairs(heroes) do 
	if hero ~= params.attacker or self:GetParent():IsReincarnating() then 

		EmitSoundOnEntityForPlayer("Hunt.End", hero, hero:GetPlayerOwnerID()) 
			
		local net_enemy = PlayerResource:GetNetWorth(hero:GetPlayerID())

 		bonus_gold = 0

 		if net_self > net_enemy then 
 			bonus_gold = (net_self - net_enemy)*Streak_k
 		end

		hero:ModifyGold(bonus_gold , true , DOTA_ModifyGold_HeroKill)
 		SendOverheadEventMessage(hero, 0, hero, bonus_gold, nil)

 		if players[hero:GetTeamNumber()] ~= nil then 

			players[hero:GetTeamNumber()].purplepoints = players[hero:GetTeamNumber()].purplepoints + 1 
				 
			if players[hero:GetTeamNumber()].purplepoints >= math.floor( players[hero:GetTeamNumber()].purplemax ) then 
		
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()) , 'kill_progress', {blue = math.floor(players[hero:GetTeamNumber()].bluepoints), purple = math.floor(players[hero:GetTeamNumber()].purplemax), max = players[hero:GetTeamNumber()].bluemax, max_p = math.floor(players[hero:GetTeamNumber()].purplemax)})
		
				Timers:CreateTimer(0.5,function()
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()) , 'kill_progress', {blue = math.floor(players[hero:GetTeamNumber()].bluepoints), purple = players[hero:GetTeamNumber()].purplepoints, max = players[hero:GetTeamNumber()].bluemax, max_p = math.floor( players[hero:GetTeamNumber()].purplemax)})
				end)

				players[hero:GetTeamNumber()].purplepoints = players[hero:GetTeamNumber()].purplepoints - math.floor(players[hero:GetTeamNumber()].purplemax)
				players[hero:GetTeamNumber()].purplemax = players[hero:GetTeamNumber()].purplemax + PlusPurple
					
				players[hero:GetTeamNumber()].purple = players[hero:GetTeamNumber()].purple + 1

				local name = "item_purple_upgrade"
				local effect = "particles/purple_drop.vpcf"
				local sound = "powerup_05"

				local item = CreateItem(name, hero, hero)

 				item_effect = ParticleManager:CreateParticle( effect, PATTACH_WORLDORIGIN, nil )

				local point = Vector(0,0,0)



 				if hero:IsAlive() then

 					point = hero:GetAbsOrigin() + hero:GetForwardVector()*150 

				else

 					if towers[hero:GetTeamNumber()] ~= nil then 
 						point = towers[hero:GetTeamNumber()]:GetAbsOrigin() + towers[hero:GetTeamNumber()]:GetForwardVector()*300
 					end

 				end

    			ParticleManager:SetParticleControl( item_effect, 0, point )
       
    			EmitSoundOnEntityForPlayer(sound, hero,  hero:GetPlayerOwnerID())

   			    item.after_legen = After_Lich

				Timers:CreateTimer(0.8,function()
 					CreateItemOnPositionSync(GetGroundPosition(point, unit), item)
				end)

			else 
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()) , 'kill_progress', { blue = math.floor(players[hero:GetTeamNumber()].bluepoints), purple = players[hero:GetTeamNumber()].purplepoints, max = players[hero:GetTeamNumber()].bluemax , max_p = math.floor( players[hero:GetTeamNumber()].purplemax)})
			end
		end
	end
end





self:Destroy()

end

function modifier_target:OnDestroy()
if not IsServer() then return end
	CustomGameEventManager:Send_ServerToAllClients( 'TargetTimer_delete',  {})
end