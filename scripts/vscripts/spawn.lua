LinkLuaModifier( "modifier_waveupgrade", "modifiers/modifier_waveupgrade", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_waveupgrade_boss", "modifiers/modifier_waveupgrade_boss", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unselect", "modifiers/modifier_unselect", LUA_MODIFIER_MOTION_NONE )


wave_types = {
	{1,0,"npc_kobold","npc_kobold","npc_kobold","npc_kobold_t","npc_kobold_t","npc_kobold_m"},
	{2,1,"npc_treant","npc_treant","npc_treant","npc_treant_b"},
	{3,1,"npc_skelet","npc_skelet","npc_skelet","npc_skelet_a"},
	{4,1,"npc_wolf","npc_wolf","npc_wolf_a","npc_wolf"},
	{5,0,"npc_boar_a","npc_boar2","npc_boar"},
	{6,0,"npc_megacreep_good","npc_megacreep_good","npc_megacreep_good","npc_megacreep_good","npc_megacreep_good","npc_megacreep_good_a"},
	{7,0,"npc_megacreep_bad","npc_megacreep_bad","npc_megacreep_bad","npc_megacreep_bad","npc_megacreep_bad","npc_megacreep_bad_a"},
	{8,0,"npc_golem_large"},
	{9,1,"npc_troll"},
	{10,1,"npc_rogue","npc_warrior","npc_archer"},
	{11,0,"npc_tusk","npc_tusk","npc_tusk","npc_tusk_a","npc_tusk_a","npc_tusk_a"},
	{12,0,"npc_ogre","npc_ogre_a","npc_ogre_a","npc_ogre_a","npc_ogre_b"},
 	{13,1,"npc_werewolf","npc_werewolf","npc_werewolf_a","npc_werewolf_a"},
	{14,1,"npc_cone","npc_cone","npc_cone","npc_cone"},
	{15,1,"npc_satyr","npc_satyr_a","npc_satyr_b","npc_satyr_b"},
	{16,1,"npc_spider","npc_spider_a","npc_spider_a"},	
	{17,1,"npc_badsiege","npc_badsiege","npc_badsiege_a","npc_badsiege_a"},
	{18,1,"npc_goodsiege","npc_goodsiege","npc_goodsiege_a","npc_goodsiege_a"},
	{19,1,"npc_slardar","npc_slardar","npc_slardar","npc_slardar_a"},
	{20,0,"npc_tombgolem","npc_tombgolem"},
	{21,1,"npc_ancient_satyr","npc_ancient_satyr","npc_ancient_satyr_a","npc_ancient_satyr_a"},
	{22,1,"npc_arc","npc_arc","npc_arc_a"},
	{23,1,"npc_techies","npc_techies","npc_techies"},
	{24,1,"npc_huskar","npc_huskar","npc_dazzle","npc_dazzle"},
	{25,1,"npc_abbadon","npc_abbadon_a","npc_abbadon_a","npc_abbadon_a"},
	{26,2,"npc_lich"},
	{26,2,"npc_lich"},
	--{27,2,"npc_lina"},
	{28,1,"npc_centaur","npc_centaur","npc_centaur","npc_centaur_a"},
	{29,1,"npc_silencer","npc_silencer","npc_antimage","npc_antimage"},
	{30,0,"npc_frostbitten","npc_frostbitten","npc_frostbitten_a","npc_frostbitten_a"}


}

info_skills = {
	{1,0,""},
	{0,2,"npc_treant_passive","npc_treant_seed"},
	{0,2,"npc_skelet_aura","npc_skelet_tomb"},
	{1,2,"npc_wolf_howl","npc_wolf_feral"},
	{1,2,"npc_boar_spit", "npc_boar_slow"},
	{1,1,"npc_megacreep_upgrade"},
	{1,1,"npc_megacreep_debuf"},
	{0,2,"golem_double", "npc_golem_passive"},
	{1,2,"npc_troll_summon", "npc_troll_skelet_heal"},
	{0,3,"npc_rogue_passive", "npc_warrior_passive", "npc_archer_silence"},
	{1,2,"npc_tusk_passive","npc_tusk_ghost_passive"},
	{0,2,"npc_ogre_root", "npc_ogre_stun"},
 	{0,2,"npc_werewolf_bloodrage", "npc_werewolf_rupture"},
	{0,1,"npc_cone_armor"},
	{0,3,"npc_satyr_aura","npc_satyr_purge","npc_satyr_manaburn"},
	{0,3,"npc_spider_toxin","npc_spider_passive","npc_spider_poison"},
	{0,2,"npc_siege_passive","npc_siege_melting"},
	{0,2,"npc_siege_passive","npc_siege_armor"},
	{1,2,"npc_slardar_armor","npc_slardar_stun"},
	{0,2,"npc_golem_decay","npc_zombie_attack"},
	{0,2,"npc_satyr_stomp","npc_satyr_root"},
	{0,2,"npc_arc_field","npc_arc_knockback"},
	{0,2,"npc_techies_bomb","npc_techies_death"},
	{1,2,"npc_huskar_lowhp","npc_dazzle_grave"},
	{1,3,"npc_abbadon_ulti","npc_abbadon_silence","npc_abbadon_proc"},
	{1,4,"npc_lich_blast","npc_lich_ice","npc_lich_ulti","npc_lich_frostbite"},
	{1,4,"npc_lich_blast","npc_lich_ice","npc_lich_ulti","npc_lich_frostbite"},
	--{1,3,"npc_lina_stun","npc_lina_ulti","npc_lina_fiery"},
	{1,2,"npc_centaur_stun","npc_centaur_double"},
	{0,3,"npc_silencer_lastword","npc_antimage_burn","npc_antimage_resist"},
	{0,2,"npc_frostbitten_spam","npc_frostbitten_heal"}
}


necro_wave_info =
{"npc_necro_melle","npc_necro_melle","npc_necro_range","npc_necro_range"}


my_game.current_wave = start_wave
my_game.go_wave = start_wave
my_game.go_boss_number = 0

function my_game:check_used( t , n ) 
	if #t == 0 then return false end
	for i = 1,#t do
		if t[i] == n then return true end
	end	
	return false
end	

---
function my_game:initiate_waves()
local first = {}
local second = {}
local boss = {}
local used_numbers = {}
local r = 0
local n = 0
local b = 0


for i = 1,#wave_types do
	if wave_types[i][2] == 0 then
		first[#first+1] = wave_types[i]
	end
	if wave_types[i][2] == 1 then
		second[#second+1] = wave_types[i]
	end
	if wave_types[i][2] == 2 then
		boss[#boss+1] = wave_types[i]
	end
end



for i = 1,#first do
	repeat r = RandomInt(1, #first)
	until not self:check_used(used_numbers,r)

	if i == 1 then 
		r = 1
	end

	used_numbers[#used_numbers+1] = r
	n = n + 1

	waves[n] = first[r]
end

used_numbers = {}

for i = 1,#second do
	repeat r = RandomInt(1, #second)
	until not self:check_used(used_numbers,r)
	used_numbers[#used_numbers+1] = r
	n = n + 1

	waves[n] = second[r]
end

used_numbers = {}

for i = 1,2 do
	repeat r = RandomInt(1, #boss)
	until not self:check_used(used_numbers,r)
	used_numbers[#used_numbers+1] = r
	b = b + 1

	boss_waves[b] = boss[r]
end


if test_wave ~= 0 then 
  for i = 1,n do  waves[i] = wave_types[test_wave] end
end

end

function my_game:GetMkb( n , boss )
if boss == true then 
	return info_skills[boss_waves[n][1]][1]
else 
	return info_skills[waves[n][1]][1]
end

end	



function my_game:GetSkills( n , boss )
local skills = {}
local j = 0
local array = {}

if boss == true then 
	array = boss_waves
else 
	array = waves
end 

if info_skills[array[n][1]][2] > 0 then 

	for i = 1,info_skills[array[n][1]][2] do
		j = j + 1
		skills[j] = info_skills[array[n][1]][i+2]
	end

end 

return skills
end	


function my_game:GetWave( n , boss )
if boss == true then 
	return boss_waves[n][3]
else 
	return waves[n][3]
end

end	

local spawn_table = {}
local max_per_tick = 6

function CreateUnitCustom(name, vector, clear_space, npc_owner, entity_owner, team, callback)
table.insert(spawn_table, function() 
	callback(CreateUnitByName(name, vector, clear_space, npc_owner, entity_owner, team))
	end)



end

function my_game:AsyncSpawn()
local limit = 0

while true do 
	local callback = spawn_table[1]
	
	if not callback then 
		return 0
	end

	table.remove(spawn_table,1)
	callback()


	limit = limit + 1
	if limit >= max_per_tick then 
		return 0
	end
end

end


function my_game:spawn_wave( team , wave_number, boss, necro_wave, lownet)


	local wave = {}
 	if not boss then 
 		for i = 1,#waves[wave_number] do 
   			wave[#wave + 1] = waves[wave_number][i]
   		end
   	else 
   		After_Lich = true
   		for i = 1,#boss_waves[wave_number] do 
   			wave[#wave + 1] = boss_waves[wave_number][i]
   		end
   	end

   	if necro_wave == true then 
   		for i = 1,#necro_wave_info do 
   			wave[#wave + 1] = necro_wave_info[i]
   		end 
   	end


    local givegold = players[team].givegold
   	local reward = players[team].reward
   	local max = #wave - 2
    local allys = {}
    local j = 0

    local multi = players[team].creeps_upgrade

    if reward == 4 then 
    	players[team].orange_count = players[team].orange_count + 1
    end

    local number = tonumber(teleports[team]:GetName())

    for i = 3,#wave do
    	local spawner = Entities:FindByName( nil, "spawner_team" ..number ):GetAbsOrigin()+RandomVector(RandomInt(-1, 1) + 125)
    	local unit = CreateUnitCustom(wave[i], spawner, true, nil, nil, DOTA_TEAM_CUSTOM_5, function(unit) 

    	j = j + 1
    	allys[j] = unit
    	unit.mkb = info_skills[waves[wave_number][1]][1]

    	allys[j].owner = players[team]

    	if not DontUpgradeCreeps then
    		if not boss or (unit:GetUnitName() == "npc_necro_melle" or unit:GetUnitName() == "npc_necro_range") then 
    			unit:AddNewModifier(unit, nil, "modifier_waveupgrade", {})
    		else 
    			unit:AddNewModifier(unit, nil, "modifier_waveupgrade_boss", {wave = wave_number})
    		end
    	end

    	allys[j].isboss = boss
    	allys[j].max = max
    	allys[j].wave_number = wave_number
    	allys[j].host = players[team]
    	allys[j].number = j
    	allys[j].givegold = givegold

    	allys[j].reward = reward
    	allys[j].lownet = lownet
    	if reward == 1 then
    		allys[j].drop = "item_gray_upgrade"
			allys[j].effect = "particles/gray_drop.vpcf"
			allys[j].sound = "powerup_04"
    	end
    	if reward == 4 then
    		allys[j].drop = "item_legendary_upgrade"
			allys[j].effect = "particles/orange_drop.vpcf"
			allys[j].sound = "powerup_02"
    	end
    	if reward == 3 then
    		allys[j].drop = "item_purple_upgrade"
			allys[j].effect = "particles/purple_drop.vpcf"
			allys[j].sound = "powerup_05"
    	end

    	if givegold then 
    		local gold = allys[j]:GetMinimumGoldBounty()
    		allys[j]:SetMinimumGoldBounty(gold*GoldComeback)
 			allys[j]:SetMaximumGoldBounty(gold*GoldComeback)
    	end

    		
    	if j == max then
    		for i = 1,j do
    			allys[i].ally = allys 		
    		end

    		if players[team] ~= nil then 

    			players[team].ActiveWave = {}
				local next_wave = my_game:GetWave(wave_number, boss)
				local skills = my_game:GetSkills(wave_number, boss)
				local mkb = my_game:GetMkb(wave_number, boss)
   			  	players[team].givegold = false 

    		    local player = PlayerResource:GetPlayer(players[team]:GetPlayerID())
                if player ~= nil then
                      CustomGameEventManager:Send_ServerToPlayer(player , 'timer_progress',  {units = max, units_max = max,  time = -1, max = -1, name = next_wave, skills = skills, mkb = mkb, reward = reward, gold = givegold, number = my_game.current_wave, hide = false})    
                end
    		end
    	end


  	end)
end




end


function my_game:spawn_portal( team )

local number = tonumber(teleports[team]:GetName())
local point = Entities:FindByName( nil, "spawner_team" ..number ):GetAbsOrigin()
   local teleport_center = CreateUnitByName("npc_dota_companion", point, false, nil, nil, 0)
    teleport_center:AddNewModifier(teleport_center, nil, "modifier_phased", {})
    teleport_center:AddNewModifier(teleport_center, nil, "modifier_invulnerable", {})
    teleport_center:AddNewModifier(teleport_center, nil, "modifier_unselect", {})


    teleport_center:EmitSound("Hero_AbyssalUnderlord.DarkRift.Cast")

		teleport_center.nWarningFX = ParticleManager:CreateParticle( "particles/portals/portal_ground_spawn_endpoint.vpcf", PATTACH_WORLDORIGIN, nil )
        ParticleManager:SetParticleControl( teleport_center.nWarningFX, 0, teleport_center:GetAbsOrigin() )


         Timers:CreateTimer(PortalDelay+0.3,function()
         	ParticleManager:DestroyParticle(teleport_center.nWarningFX, true)
         	teleport_center:StopSound("Hero_AbyssalUnderlord.DarkRift.Cast")
    		teleport_center:EmitSound("Hero_AbyssalUnderlord.DarkRift.Complete")
         	teleport_center:Destroy()
         end)


end