LinkLuaModifier( "modifier_lownet_gold", "upgrade/general/modifier_lownet_gold", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lownet_blue", "upgrade/general/modifier_lownet_blue", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lownet_purple", "upgrade/general/modifier_lownet_purple", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lownet_choose", "modifiers/modifier_lownet_choose", LUA_MODIFIER_MOTION_NONE )


if upgrade == nil then
	_G.upgrade = class({})
end

skills = {
	all = {
		{"modifier_up_primary",0,"gray",0,"gray_item","Possessed_Mask",25,6}, 
		{"modifier_up_health",0,"gray",0,"gray_item","Vitality_Booster",25,150}, 
		{"modifier_up_damage",0,"gray",0,"gray_item","Broadsword",25,10}, 
		{"modifier_up_armor",0,"gray",0,"gray_item","Chainmail",25,3},
		{"modifier_up_secondary",0,"gray",0,"gray_item","Pupil_Gift",25,6}, 
		{"modifier_up_spelldamage",0,{"mage","gray"},0,"gray_item","Kaya",25,3}, 
		{"modifier_up_movespeed",0,"gray",0,"gray_item","Boots_of_Speed",25,15}, 
		{"modifier_up_evasion",0,"gray",0,"gray_item","Talisman_of_Evasion",25,6}, 
		{"modifier_up_lifesteal",0,"gray",0,"gray_item","Morbid_Mask",25,6},
		{"modifier_up_speed",0,"gray",0,"gray_item","Gloves_of_Haste",25,12},
		{"modifier_up_towerdamage",0,"gray",0,"gray_item","The_Leveller",25,5},
		{"modifier_up_gold",0,"gray",0,"gray_item","Philosopher_Stone",25,40},
		{"modifier_up_spellsteal",0,{"mage","gray"},0,"gray_item","Voodoo_Mask",25,4},
		{"modifier_up_statusresist",0,"gray",0,"gray_item","Titan_Sliver",25,5},
		{"modifier_up_cleave",0,{"melle","gray"},0,"gray_item","Battle_Fury",25,7},
		{"modifier_up_magicresist",0,"gray",0,"gray_item","Cloak",25,6},
		{"modifier_up_javelin",0,"gray",0,"gray_item","Javelin",25,15},
		{"modifier_up_creeps",0,"gray",0,"gray_item","Quelling_Blade",25,5},
		{"modifier_up_manaregen",0,"gray",0,"gray_item","Voidstone",25,2},
	
		--{"modifier_tower_up",2,"gray",0,"gray_skill","Tower",25,2},
		
		{"modifier_up_slow",0,"blue",3,"blue_item","Penta-Edged_Sword",25,0},
		{"modifier_up_gainprimary",0,"blue",3,"blue_item","Crown",22,0},
		{"modifier_up_gainsecondary",0,"blue",3,"blue_item","Ocean_Heart",22,0},
		--{"modifier_up_repair",0,"blue",3,"blue_item","Repair_Kit",18,0},
		--{"modifier_up_bash",0,"blue",3,"blue_item","Skull_Basher",22,0},
		{"modifier_up_magicblock",0,"blue",3,"blue_item","Hood_of_Defiance",3,0},
		{"modifier_up_attackblock",0,"blue",3,"blue_item","Crimson_Guard",3,0},
		{"modifier_up_cooldown",0,"blue",3,"blue_item","Octarine_Core",3,0},
		{"modifier_up_stun",0,"blue",3,"blue_item","vest",3,0},
	
		{"modifier_up_bigdamage",0,"blue",3,"blue_skill","Defend_Matrix",22,0},
		{"modifier_up_toweraoe",2,"blue",3,"blue_skill","Tower",25,0},
	
		{"modifier_up_primaryupgrade",0,"purple",1,"purple_item","Apex",19,0},
		{"modifier_up_secondaryupgrade",0,"purple",1,"purple_item","Ultimate_Orb",19,0},
		{"modifier_up_fullhpresist",0,"purple",1,"purple_item","Aeon_Disk",22,0},
		{"modifier_up_graypoints",0,"purple",1,"purple_item","Gray",25,0},
		{"modifier_up_bluepoints",0,"purple",1,"purple_item","Blue",25,0},
		{"modifier_up_grayfour",0,"purple",1,"purple_item","Gray",25,0},
		{"modifier_up_purplepoints",0,"purple",1,"purple_item","Purple",25,0},
		{"modifier_up_orangepoints",0,"purple",1,"purple_item","orange",25,0},
	
		{"modifier_up_res",0,"purple",1,"purple_skill","Phoenix_Ash",20,0},
		--{"modifier_up_towerdisarm",2,"purple",1,"purple_skill","Tower",22,0},
	},

	lowest = {
		{"modifier_lownet_gold",0, "blue", 1, "blue_skill", "greed", 22, 0},
		{"modifier_lownet_blue",0, "blue", 1, "blue_item", "blue", 22, 0},
		{"modifier_lownet_purple",0, "blue", 1, "blue_item", "purple", 22, 0},
	},

	npc_dota_hero_juggernaut = {
		{"modifier_juggernaut_bladefury_damage",1,"blue",3,"blue_skill","Blade_Fury",25,1,"Blade_fury_1",0},
		{"modifier_juggernaut_bladefury_duration",1,"blue",3,"blue_skill","Blade_Fury",25,1,"Blade_fury_2",0},
		{"modifier_juggernaut_bladefury_chance",1,"blue",3,"blue_skill","Blade_Fury",19,1,"Blade_fury_3",1},
	
		{"modifier_juggernaut_healingward_heal",1,"blue",3,"blue_skill","Healing_Ward",25,2,"Healing_ward_1",0},
		{"modifier_juggernaut_healingward_cd",1,"blue",3,"blue_skill","Healing_Ward",25,2,"Healing_ward_2",0},
		{"modifier_juggernaut_healingward_move",1,"blue",3,"blue_skill","Healing_Ward",22,2,"Healing_ward_3",0},
	
		{"modifier_juggernaut_bladedance_lowhp",1,"blue",3,"blue_skill","Blade_Dance",18,3,"Blade_dance_1",1},
		{"modifier_juggernaut_bladedance_chance",1,"blue",3,"blue_skill","Blade_Dance",25,3,"Blade_dance_2",0},
		{"modifier_juggernaut_bladedance_speed",1,"blue",3,"blue_skill","Blade_Dance",22,3,"Blade_dance_3",0},
	
		{"modifier_juggernaut_omnislash_stack",1,"blue",3,"blue_skill","Omnislash",22,4,"Omnislash_1",0},
		{"modifier_juggernaut_omnislash_heal",1,"blue",3,"blue_skill","Omnislash",25,4,"Omnislash_4",0},
		{"modifier_juggernaut_omnislash_speed",1,"blue",3,"blue_skill","Omnislash",22,4,"Omnislash_6",0},

		{"modifier_juggernaut_bladefury_agility",1,"purple",2,"purple_skill","Blade_Fury",19,1,"Blade_fury_6",0},
		{"modifier_juggernaut_bladefury_silence",1,"purple",1,"purple_skill","Blade_Fury",25,1,"Blade_fury_4",1},
		{"modifier_juggernaut_bladefury_shield",1,"purple",1,"purple_skill","Blade_Fury",19,1,"Blade_fury_5",0},
	
		{"modifier_juggernaut_healingward_return",1,"purple",2,"purple_skill","Healing_Ward",22,2,"Healing_ward_5",1},
		{"modifier_juggernaut_healingward_purge",1,"purple",1,"purple_skill","Healing_Ward",25,2,"Healing_ward_4",1},
		{"modifier_juggernaut_healingward_stun",1,"purple",1,"purple_skill","Healing_Ward",20,2,"Healing_ward_6",1},
	
		{"modifier_juggernaut_bladedance_stack",1,"purple",2,"purple_skill","Blade_Dance",22,3,"Blade_dance_4",1},
		{"modifier_juggernaut_bladedance_double",1,"purple",1,"purple_skill","Blade_Dance",23,3,"Blade_dance_6",1},
		{"modifier_juggernaut_bladedance_parry",1,"purple",1,"purple_skill","Blade_Dance",22,3,"Blade_dance_5",0},
	
		{"modifier_juggernaut_omnislash_cd",1,"purple",2,"purple_skill","Omnislash",22,4,"Omnislash_2",1},
		{"modifier_juggernaut_omnislash_clone",1,"purple",1,"purple_skill","Omnislash",18,4,"Omnislash_3",1},
		{"modifier_juggernaut_omnislash_aoe_attack",1,"purple",1,"purple_skill","Omnislash",22,4,"Omnislash_5",1},

		{"modifier_juggernaut_bladefury_legendary",1,"orange",0,"orange_skill","Blade_Fury",25,0,1},
		{"modifier_juggernaut_healingward_legendary",1,"orange",0,"orange_skill","Healing_Ward",19,1,2},
		{"modifier_juggernaut_bladedance_legendary",1,"orange",0,"orange_skill","Blade_Dance",18,1,3},
		{"modifier_juggernaut_omnislash_legendary",1,"orange",0,"orange_skill","Omnislash",20,1,4},
	},


	npc_dota_hero_phantom_assassin = {
		{"modifier_phantom_assassin_dagger_cd",1,"blue",3,"blue_skill","Stifling_Dagger",25,1,"Stifling_Dagger_1",0},
		{"modifier_phantom_assassin_dagger_aoe",1,"blue",3,"blue_skill","Stifling_Dagger",25,1,"Stifling_Dagger_2",1},
		{"modifier_phantom_assassin_dagger_damage",1,"blue",3,"blue_skill","Stifling_Dagger",25,1,"Stifling_Dagger_5",1},
	
		{"modifier_phantom_assassin_blink_move",1,"blue",3,"blue_skill","Phantom_Strike",22,2,"Phantom_Strike_1",1},
		{"modifier_phantom_assassin_blink_duration",1,"blue",3,"blue_skill","Phantom_Strike",25,2,"Phantom_Strike_2",0},
		{"modifier_phantom_assassin_blink_damage",1,"blue",3,"blue_skill","Phantom_Strike",19,2,"Phantom_Strike_3",0},
	
		{"modifier_phantom_assassin_blur_delay",1,"blue",3,"blue_skill","Blur",25,3,"Blur_1",0},
		{"modifier_phantom_assassin_blur_heal",1,"blue",3,"blue_skill","Blur",22,3,"Blur_2",1},
		{"modifier_phantom_assassin_blur_chance",1,"blue",3,"blue_skill","Blur",25,3,"Blur_3",0},
	
		{"modifier_phantom_assassin_crit_chance",1,"blue",3,"blue_skill","Coup_de_Grace",25,4,"Coup_de_Grace_1",0},
		{"modifier_phantom_assassin_crit_damage",1,"blue",3,"blue_skill","Coup_de_Grace",22,4,"Coup_de_Grace_5",0},
		{"modifier_phantom_assassin_crit_speed",1,"blue",3,"blue_skill","Coup_de_Grace",22,4,"Coup_de_Grace_3",1},

		{"modifier_phantom_assassin_dagger_double",1,"purple",2,"purple_skill","Stifling_Dagger",19,1,"Stifling_Dagger_3",1},
		{"modifier_phantom_assassin_dagger_duration",1,"purple",1,"purple_skill","Stifling_Dagger",22,1,"Stifling_Dagger_4",0},
		{"modifier_phantom_assassin_dagger_heal",1,"purple",1,"purple_skill","Stifling_Dagger",20,1,"Stifling_Dagger_6",0},
	
		{"modifier_phantom_assassin_blink_illusion",1,"purple",2,"purple_skill","Phantom_Strike",21,2,"Phantom_Strike_6",1},
		{"modifier_phantom_assassin_blink_blink",1,"purple",1,"purple_skill","Phantom_Strike",19,2,"Phantom_Strike_4",0},
		{"modifier_phantom_assassin_blink_blind",1,"purple",1,"purple_skill","Phantom_Strike",19,2,"Phantom_Strike_5",1},
	
		{"modifier_phantom_assassin_blur_blood",1,"purple",2,"purple_skill","Blur",20,3,"Blur_5",1},
		{"modifier_phantom_assassin_blur_reduction",1,"purple",1,"purple_skill","Blur",18,3,"Blur_4",1},
		{"modifier_phantom_assassin_blur_stun",1,"purple",1,"purple_skill","Blur",20,3,"Blur_6",1},
	
		{"modifier_phantom_assassin_crit_stack",1,"purple",2,"purple_skill","Coup_de_Grace",22,4,"Coup_de_Grace_2",1},
		{"modifier_phantom_assassin_crit_lowhp",1,"purple",1,"purple_skill","Coup_de_Grace",22,4,"Coup_de_Grace_4",0},
		{"modifier_phantom_assassin_crit_steal",1,"purple",1,"purple_skill","Coup_de_Grace",22,4,"Coup_de_Grace_6",1},

		{"modifier_phantom_assassin_dagger_legendary",1,"orange",0,"orange_skill","Stifling_Dagger",18,1,1},
		{"modifier_phantom_assassin_blink_legendary",1,"orange",0,"orange_skill","Phantom_Strike",22,1,2},
		{"modifier_phantom_assassin_blur_legendary",1,"orange",0,"orange_skill","Blur",20,1,3},
		{"modifier_phantom_assassin_crit_legendary",1,"orange",0,"orange_skill","Coup_de_Grace",19,1,4},
	},

	npc_dota_hero_huskar = {
		{"modifier_huskar_disarm_duration",1,"blue",3,"blue_skill","Inner_Fire",25,1,"Inner_Fire_1",0},
		{"modifier_huskar_disarm_heal",1,"blue",3,"blue_skill","Inner_Fire",25,1,"Inner_Fire_2",1},
		{"modifier_huskar_disarm_crit",1,"blue",3,"blue_skill","Inner_Fire",2,1,"Inner_Fire_4",0},
	
		{"modifier_huskar_spears_damage",1,"blue",3,"blue_skill","Burning_Spears",25,2,"Burning_Spears_1",0},
		{"modifier_huskar_spears_blast",1,"blue",3,"blue_skill","Burning_Spears",25,2,"Burning_Spears_2",0},
		{"modifier_huskar_spears_armor",1,"blue",3,"blue_skill","Burning_Spears",22,2,"Burning_Spears_3",1},
	
		{"modifier_huskar_passive_regen",1,"blue",3,"blue_skill","Berserkers_Blood",25,3,"Berserkers_Blood_6",0},
		{"modifier_huskar_passive_speed",1,"blue",3,"blue_skill","Berserkers_Blood",22,3,"Berserkers_Blood_1",0},
		{"modifier_huskar_passive_damage",1,"blue",3,"blue_skill","Berserkers_Blood",25,3,"Berserkers_Blood_2",1},
	
		{"modifier_huskar_leap_damage",1,"blue",3,"blue_skill","Life_Break",22,4,"Life_Break_3",0},
		{"modifier_huskar_leap_cd",1,"blue",3,"blue_skill","Life_Break",25,4,"Life_Break_1",0},
		{"modifier_huskar_leap_double",1,"blue",3,"blue_skill","Life_Break",22,4,"Life_Break_5",0},
	
		{"modifier_huskar_disarm_str",1,"purple",2,"purple_skill","Inner_Fire",18,1,"Inner_Fire_3",1},
		{"modifier_huskar_disarm_silence",1,"purple",1,"purple_skill","Inner_Fire",25,1,"Inner_Fire_5",1},
		{"modifier_huskar_disarm_lowhp",1,"purple",1,"purple_skill","Inner_Fire",18,1,"Inner_Fire_6",0},
	
		{"modifier_huskar_spears_tick",1,"purple",2,"purple_skill","Burning_Spears",22,2,"Burning_Spears_4",0},
		{"modifier_huskar_spears_aoe",1,"purple",1,"purple_skill","Burning_Spears",18,2,"Burning_Spears_5",1},
		{"modifier_huskar_spears_pure",1,"purple",1,"purple_skill","Burning_Spears",22,2,"Burning_Spears_6",0},
	
		{"modifier_huskar_passive_active",1,"purple",2,"purple_skill","Berserkers_Blood",22,3,"Berserkers_Blood_5",1},
		{"modifier_huskar_passive_lowhp",1,"purple",1,"purple_skill","Berserkers_Blood",22,3,"Berserkers_Blood_4",1},
		{"modifier_huskar_passive_armor",1,"purple",1,"purple_skill","Berserkers_Blood",22,3,"Berserkers_Blood_3",0},
	
		{"modifier_huskar_leap_shield",1,"purple",2,"purple_skill","Life_Break",22,4,"Life_Break_2",1},
		{"modifier_huskar_leap_resist",1,"purple",1,"purple_skill","Life_Break",18,4,"Life_Break_4",1},
		{"modifier_huskar_leap_immune",1,"purple",1,"purple_skill","Life_Break",22,4,"Life_Break_6",1},

		{"modifier_huskar_disarm_legendary",1,"orange",0,"orange_skill","Inner_Fire",25,1,1},
		{"modifier_huskar_spears_legendary",1,"orange",0,"orange_skill","Burning_Spears",17,1,2},
		{"modifier_huskar_passive_legendary",1,"orange",0,"orange_skill","Berserkers_Blood",22,1,3},
		{"modifier_huskar_leap_legendary",1,"orange",0,"orange_skill","Life_Break",22,1,4},
	},

	npc_dota_hero_nevermore = {
		{"modifier_nevermore_raze_damage",1,"blue",3,"blue_skill","Shadowraze",25,1,"Shadowraze_1",0},
		{"modifier_nevermore_raze_cd",1,"blue",3,"blue_skill","Shadowraze",25,1,"Shadowraze_2",0},
		{"modifier_nevermore_raze_speed",1,"blue",3,"blue_skill","Shadowraze",2,1,"Shadowraze_3",1},
	
		{"modifier_nevermore_souls_damage",1,"blue",3,"blue_skill","Necromastery",25,2,"Necromastery_1",0},
		{"modifier_nevermore_souls_max",1,"blue",3,"blue_skill","Necromastery",25,2,"Necromastery_2",0},
		{"modifier_nevermore_souls_attack",1,"blue",3,"blue_skill","Necromastery",22,2,"Necromastery_3",1},
	
		{"modifier_nevermore_darklord_armor",1,"blue",3,"blue_skill","Dark_Lord",25,3,"Dark_Lord_1",0},
		{"modifier_nevermore_darklord_slow",1,"blue",3,"blue_skill","Dark_Lord",25,3,"Dark_Lord_2",0},
		{"modifier_nevermore_darklord_damage",1,"blue",3,"blue_skill","Dark_Lord",22,3,"Dark_Lord_4",0},
	
		{"modifier_nevermore_requiem_damage",1,"blue",3,"blue_skill","Requiem",22,4,"Requiem_1",0},
		{"modifier_nevermore_requiem_cd",1,"blue",3,"blue_skill","Requiem",25,4,"Requiem_2",0},
		{"modifier_nevermore_requiem_heal",1,"blue",3,"blue_skill","Requiem",22,4,"Requiem_3",0},

		{"modifier_nevermore_raze_burn",1,"purple",2,"purple_skill","Shadowraze",18,1,"Shadowraze_4",1},
		{"modifier_nevermore_raze_combocd",1,"purple",1,"purple_skill","Shadowraze",25,1,"Shadowraze_5",1},
		{"modifier_nevermore_raze_duration",1,"purple",1,"purple_skill","Shadowraze",18,1,"Shadowraze_6",0},
	
		{"modifier_nevermore_souls_tempo",1,"purple",2,"purple_skill","Necromastery",22,2,"Necromastery_6",0},
		{"modifier_nevermore_souls_heal",1,"purple",1,"purple_skill","Necromastery",18,2,"Necromastery_5",1},
		{"modifier_nevermore_souls_kills",1,"purple",1,"purple_skill","Necromastery",22,2,"Necromastery_4",0},
	
		{"modifier_nevermore_darklord_health",1,"purple",2,"purple_skill","Dark_Lord",22,3,"Dark_Lord_3",0},
		{"modifier_nevermore_darklord_self",1,"purple",1,"purple_skill","Dark_Lord",22,3,"Dark_Lord_5",0},
		{"modifier_nevermore_darklord_silence",1,"purple",1,"purple_skill","Dark_Lord",22,3,"Dark_Lord_6",1},
	
		{"modifier_nevermore_requiem_proc",1,"purple",2,"purple_skill","Requiem",22,4,"Requiem_6",1},
		{"modifier_nevermore_requiem_bkb",1,"purple",1,"purple_skill","Requiem",18,4,"Requiem_5",1},
		{"modifier_nevermore_requiem_cdsoul",1,"purple",1,"purple_skill","Requiem",22,4,"Requiem_4",1},

		{"modifier_nevermore_raze_legendary",1,"orange",0,"orange_skill","Shadowraze",25,1,1},
		{"modifier_nevermore_souls_legendary",1,"orange",0,"orange_skill","Necromastery",17,1,2},
		{"modifier_nevermore_darklord_legendary",1,"orange",0,"orange_skill","Dark_Lord",22,1,3},
		{"modifier_nevermore_requiem_legendary",1,"orange",0,"orange_skill","Requiem",22,1,4},	
	},

	npc_dota_hero_legion_commander = {
		{"modifier_legion_odds_cd",1,"blue",3,"blue_skill","Odds",25,1,"Odds_1",0},
		{"modifier_legion_odds_creep",1,"blue",3,"blue_skill","Odds",25,1,"Odds_2",0},
		{"modifier_legion_odds_triple",1,"blue",3,"blue_skill","Odds",2,1,"Odds_4",0},
	
		{"modifier_legion_press_cd",1,"blue",3,"blue_skill","Press",25,2,"Press_3",0},
		{"modifier_legion_press_regen",1,"blue",3,"blue_skill","Press",25,2,"Press_2",0},
		{"modifier_legion_press_speed",1,"blue",3,"blue_skill","Press",22,2,"Press_1",0},
	
		{"modifier_legion_moment_chance",1,"blue",3,"blue_skill","Moment",25,3,"Moment_1",0},
		{"modifier_legion_moment_defence",1,"blue",3,"blue_skill","Moment",25,3,"Moment_2",0},
		{"modifier_legion_moment_damage",1,"blue",3,"blue_skill","Moment",22,3,"Moment_3",0},
	
		{"modifier_legion_duel_passive",1,"blue",3,"blue_skill","Duel",22,4,"Duel_6",1},
		{"modifier_legion_duel_return",1,"blue",3,"blue_skill","Duel",25,4,"Duel_2",0},
		{"modifier_legion_duel_speed",1,"blue",3,"blue_skill","Duel",22,4,"Duel_3",0},

		{"modifier_legion_odds_proc",1,"purple",2,"purple_skill","Odds",18,1,"Odds_3",1},
		{"modifier_legion_odds_solo",1,"purple",1,"purple_skill","Odds",25,1,"Odds_5",1},
		{"modifier_legion_odds_mark",1,"purple",1,"purple_skill","Odds",18,1,"Odds_6",1},
	
		{"modifier_legion_press_duration",1,"purple",2,"purple_skill","Press",22,2,"Press_4",1},
		{"modifier_legion_press_after",1,"purple",1,"purple_skill","Press",18,2,"Press_5",1},
		{"modifier_legion_press_lowhp",1,"purple",1,"purple_skill","Press",22,2,"Press_6",1},
	
		{"modifier_legion_moment_armor",1,"purple",2,"purple_skill","Moment",22,3,"Moment_4",0},
		{"modifier_legion_moment_lowhp",1,"purple",1,"purple_skill","Moment",22,3,"Moment_5",0},
		{"modifier_legion_moment_bkb",1,"purple",1,"purple_skill","Moment",22,3,"Moment_6",1},
	
		{"modifier_legion_duel_damage",1,"purple",2,"purple_skill","Duel",22,4,"Duel_1",0},
		{"modifier_legion_duel_win",1,"purple",1,"purple_skill","Duel",18,4,"Duel_5",1},
		{"modifier_legion_duel_blood",1,"purple",1,"purple_skill","Duel",22,4,"Duel_4",0},

		{"modifier_legion_odds_legendary",1,"orange",0,"orange_skill","Odds",25,1,1},
		{"modifier_legion_press_legendary",1,"orange",0,"orange_skill","Press",17,1,2},
		{"modifier_legion_moment_legendary",1,"orange",0,"orange_skill","Moment",22,1,3},
		{"modifier_legion_duel_legendary",1,"orange",0,"orange_skill","Duel",22,0,4},
	},

	npc_dota_hero_queenofpain = {
		{"modifier_queen_Dagger_damage",1,"blue",3,"blue_skill","Dagger",25,1,"Dagger_1",0},
		{"modifier_queen_Dagger_heal",1,"blue",3,"blue_skill","Dagger",25,1,"Dagger_2",0},
		{"modifier_queen_Dagger_auto",1,"blue",3,"blue_skill","Dagger",2,1,"Dagger_3",1},
	
		{"modifier_queen_Blink_cd",1,"blue",3,"blue_skill","Blink",25,2,"Blink_1",0},
		{"modifier_queen_Blink_damage",1,"blue",3,"blue_skill","Blink",25,2,"Blink_2",0},
		{"modifier_queen_Blink_speed",1,"blue",3,"blue_skill","Blink",22,2,"Blink_3",1},
	
		{"modifier_queen_Scream_damage",1,"blue",3,"blue_skill","Scream",25,3,"Scream_3",0},
		{"modifier_queen_Scream_cd",1,"blue",3,"blue_skill","Scream",25,3,"Scream_2",0},
		{"modifier_queen_Scream_double",1,"blue",3,"blue_skill","Scream",22,3,"Scream_1",1},
	
		{"modifier_queen_Sonic_damage",1,"blue",3,"blue_skill","Sonic",22,4,"Sonic_1",0},
		{"modifier_queen_Sonic_fire",1,"blue",3,"blue_skill","Sonic",25,4,"Sonic_2",1},
		{"modifier_queen_Sonic_reduce",1,"blue",3,"blue_skill","Sonic",22,4,"Sonic_3",0},

		{"modifier_queen_Dagger_proc",1,"purple",2,"purple_skill","Dagger",18,1,"Dagger_4",0},
		{"modifier_queen_Dagger_aoe",1,"purple",1,"purple_skill","Dagger",25,1,"Dagger_5",0},
		{"modifier_queen_Dagger_poison",1,"purple",1,"purple_skill","Dagger",18,1,"Dagger_6",0},
	
		{"modifier_queen_Blink_magic",1,"purple",2,"purple_skill","Blink",22,2,"Blink_4",1},
		{"modifier_queen_Blink_spells",1,"purple",1,"purple_skill","Blink",18,2,"Blink_5",1},
		{"modifier_queen_Blink_absorb",1,"purple",1,"purple_skill","Blink",22,2,"Blink_6",1},
	
		{"modifier_queen_Scream_shield",1,"purple",2,"purple_skill","Scream",22,3,"Scream_6",1},
		{"modifier_queen_Scream_slow",1,"purple",1,"purple_skill","Scream",22,3,"Scream_5",1},
		{"modifier_queen_Scream_fear",1,"purple",1,"purple_skill","Scream",22,3,"Scream_4",1},
	
		{"modifier_queen_Sonic_taken",1,"purple",2,"purple_skill","Sonic",22,4,"Sonic_5",1},
		{"modifier_queen_Sonic_far",1,"purple",1,"purple_skill","Sonic",18,4,"Sonic_4",1},
		{"modifier_queen_Sonic_cd",1,"purple",1,"purple_skill","Sonic",22,4,"Sonic_6",0},

		{"modifier_queen_Dagger_legendary",1,"orange",0,"orange_skill","Dagger",25,1,1},
		{"modifier_queen_Blink_legendary",1,"orange",0,"orange_skill","Blink",17,1,2},
		{"modifier_queen_Scream_legendary",1,"orange",0,"orange_skill","Scream",22,1,3},
		{"modifier_queen_Sonic_legendary",1,"orange",0,"orange_skill","Sonic",22,0,4},
	},

	npc_dota_hero_terrorblade = {
		{"modifier_terror_reflection_duration",1,"blue",3,"blue_skill","Reflection",25,1,"Reflection_1",0},
		{"modifier_terror_reflection_speed",1,"blue",3,"blue_skill","Reflection",25,1,"Reflection_2",0},
		{"modifier_terror_reflection_slow",1,"blue",3,"blue_skill","Reflection",2,1,"Reflection_3",0},
	
		{"modifier_terror_illusion_incoming",1,"blue",3,"blue_skill","Illusion",25,2,"Illusion_1",0},
		{"modifier_terror_illusion_duration",1,"blue",3,"blue_skill","Illusion",25,2,"Illusion_2",0},
		{"modifier_terror_illusion_stack",1,"blue",3,"blue_skill","Illusion",22,2,"Illusion_3",1},
	
		{"modifier_terror_meta_stats",1,"blue",3,"blue_skill","Meta",25,3,"Meta_1",0},
		{"modifier_terror_meta_regen",1,"blue",3,"blue_skill","Meta",25,3,"Meta_2",0},
		{"modifier_terror_meta_magic",1,"blue",3,"blue_skill","Meta",22,3,"Meta_3",1},
	
		{"modifier_terror_sunder_cd",1,"blue",3,"blue_skill","Sunder",22,4,"Sunder_2",0},
		{"modifier_terror_sunder_damage",1,"blue",3,"blue_skill","Sunder",25,4,"Sunder_1",1},
		{"modifier_terror_sunder_amplify",1,"blue",3,"blue_skill","Sunder",22,4,"Sunder_5",0},

		{"modifier_terror_reflection_silence",1,"purple",2,"purple_skill","Reflection",18,1,"Reflection_4",1},
		{"modifier_terror_reflection_stun",1,"purple",1,"purple_skill","Reflection",25,1,"Reflection_5",1},
		{"modifier_terror_reflection_double",1,"purple",1,"purple_skill","Reflection",18,1,"Reflection_6",1},
	
		{"modifier_terror_illusion_double",1,"purple",2,"purple_skill","Illusion",22,2,"Illusion_5",1},
		{"modifier_terror_illusion_resist",1,"purple",1,"purple_skill","Illusion",18,2,"Illusion_4",0},
		{"modifier_terror_illusion_texture",1,"purple",1,"purple_skill","Illusion",22,2,"Illusion_6",1},
	
		{"modifier_terror_meta_start",1,"purple",2,"purple_skill","Meta",22,3,"Meta_4",0},
		{"modifier_terror_meta_range",1,"purple",1,"purple_skill","Meta",22,3,"Meta_5",1},
		{"modifier_terror_meta_lowhp",1,"purple",1,"purple_skill","Meta",22,3,"Meta_6",1},
	
		{"modifier_terror_sunder_stats",1,"purple",2,"purple_skill","Sunder",22,4,"Sunder_3",0},
		{"modifier_terror_sunder_heal",1,"purple",1,"purple_skill","Sunder",18,4,"Sunder_4",1},
		{"modifier_terror_sunder_swap",1,"purple",1,"purple_skill","Sunder",22,4,"Sunder_6",1},

		{"modifier_terror_reflection_legendary",1,"orange",0,"orange_skill","Reflection",25,1,1},
		{"modifier_terror_illusion_legendary",1,"orange",0,"orange_skill","Illusion",17,1,2},
		{"modifier_terror_meta_legendary",1,"orange",0,"orange_skill","Meta",22,0,3},
		{"modifier_terror_sunder_legendary",1,"orange",0,"orange_skill","Sunder",22,1,4},
	},

	npc_dota_hero_bristleback = {
		{"modifier_bristle_goo_max",1,"blue",3,"blue_skill","Goo",25,1,"Goo_1",0},
		{"modifier_bristle_goo_proc",1,"blue",3,"blue_skill","Goo",25,1,"Goo_2",1},
		{"modifier_bristle_goo_ground",1,"blue",3,"blue_skill","Goo",2,1,"Goo_3",1},
	
		{"modifier_bristle_spray_damage",1,"blue",3,"blue_skill","Spray",25,2,"Spray_1",0},
		{"modifier_bristle_spray_max",1,"blue",3,"blue_skill","Spray",25,2,"Spray_2",1},
		{"modifier_bristle_spray_heal",1,"blue",3,"blue_skill","Spray",22,2,"Spray_3",0},
	
		{"modifier_bristle_back_spray",1,"blue",3,"blue_skill","Back",25,3,"Back_1",0},
		{"modifier_bristle_back_return",1,"blue",3,"blue_skill","Back",25,3,"Back_2",1},
		{"modifier_bristle_back_heal",1,"blue",3,"blue_skill","Back",22,3,"Back_3",1},
	
		{"modifier_bristle_warpath_damage",1,"blue",3,"blue_skill","Warpath",22,4,"Warpath_5",0},
		{"modifier_bristle_warpath_resist",1,"blue",3,"blue_skill","Warpath",25,4,"Warpath_1",0},
		{"modifier_bristle_warpath_pierce",1,"blue",3,"blue_skill","Warpath",22,4,"Warpath_3",1},

		{"modifier_bristle_goo_damage",1,"purple",2,"purple_skill","Goo",18,1,"Goo_4",1},
		{"modifier_bristle_goo_stack",1,"purple",1,"purple_skill","Goo",25,1,"Goo_5",1},
		{"modifier_bristle_goo_status",1,"purple",1,"purple_skill","Goo",18,1,"Goo_6",0},
	
		{"modifier_bristle_spray_double",1,"purple",2,"purple_skill","Spray",22,2,"Spray_4",1},
		{"modifier_bristle_spray_lowhp",1,"purple",1,"purple_skill","Spray",18,2,"Spray_5",0},
		{"modifier_bristle_spray_reduce",1,"purple",1,"purple_skill","Spray",22,2,"Spray_6",0},
	
		{"modifier_bristle_back_damage",1,"purple",2,"purple_skill","Back",22,3,"Back_4",1},
		{"modifier_bristle_back_reflect",1,"purple",1,"purple_skill","Back",22,3,"Back_5",1},
		{"modifier_bristle_back_ground",1,"purple",1,"purple_skill","Back",22,3,"Back_6",1},
	
		{"modifier_bristle_warpath_bash",1,"purple",2,"purple_skill","Warpath",22,4,"Warpath_4",1},
		{"modifier_bristle_warpath_max",1,"purple",1,"purple_skill","Warpath",18,4,"Warpath_2",0},
		{"modifier_bristle_warpath_lowhp",1,"purple",1,"purple_skill","Warpath",22,4,"Warpath_6",1},

		{"modifier_bristle_goo_legendary",1,"orange",0,"orange_skill","Goo",25,1,1},
		{"modifier_bristle_spray_legendary",1,"orange",0,"orange_skill","Spray",17,0,2},
		{"modifier_bristle_back_legendary",1,"orange",0,"orange_skill","Back",22,1,3},
		{"modifier_bristle_warpath_legendary",1,"orange",0,"orange_skill","Warpath",22,1,4},
	},

	npc_dota_hero_puck = {
		{"modifier_puck_orb_damage",1,"blue",3,"blue_skill","Orb",18,1,"Orb_1",0},
		{"modifier_puck_orb_cd",1,"blue",3,"blue_skill","Orb",25,1,"Orb_2",0},
		{"modifier_puck_orb_range",1,"blue",3,"blue_skill","Orb",18,1,"Orb_5",1},
	
		{"modifier_puck_rift_damage",1,"blue",3,"blue_skill","Rift",22,2,"Rift_1",0},
		{"modifier_puck_rift_cd",1,"blue",3,"blue_skill","Rift",18,2,"Rift_2",0},
		{"modifier_puck_rift_mana",1,"blue",3,"blue_skill","Rift",22,2,"Rift_3",1},
	
		{"modifier_puck_shift_regen",1,"blue",3,"blue_skill","Shift",22,3,"Shift_1",0},
		{"modifier_puck_shift_damage",1,"blue",3,"blue_skill","Shift",22,3,"Shift_2",0},
		{"modifier_puck_shift_lowhp",1,"blue",3,"blue_skill","Shift",22,3,"Shift_6",1},
	
		{"modifier_puck_coil_duration",1,"blue",3,"blue_skill","Coil",22,4,"Coil_1",0},
		{"modifier_puck_coil_cd",1,"blue",3,"blue_skill","Coil",18,4,"Coil_2",0},
		{"modifier_puck_coil_resist",1,"blue",3,"blue_skill","Coil",22,4,"Coil_3",0},
		
	
	
		{"modifier_puck_orb_distance",1,"purple",2,"purple_skill","Orb",18,1,"Orb_4",1},
		{"modifier_puck_orb_double",1,"purple",1,"purple_skill","Orb",25,1,"Orb_3",0},
		{"modifier_puck_orb_blind",1,"purple",1,"purple_skill","Orb",18,1,"Orb_6",1},
	
		{"modifier_puck_rift_tick",1,"purple",2,"purple_skill","Rift",22,2,"Rift_4",1},
		{"modifier_puck_rift_purge",1,"purple",1,"purple_skill","Rift",18,2,"Rift_5",1},
		{"modifier_puck_rift_range",1,"purple",1,"purple_skill","Rift",22,2,"Rift_6",1},
	
		{"modifier_puck_shift_attacks",1,"purple",2,"purple_skill","Shift",22,3,"Shift_4",1},
		{"modifier_puck_shift_resist",1,"purple",1,"purple_skill","Shift",22,3,"Shift_5",1},
		{"modifier_puck_shift_stun",1,"purple",1,"purple_skill","Shift",22,3,"Shift_3",1},
	
		{"modifier_puck_coil_magic",1,"purple",2,"purple_skill","Coil",22,4,"Coil_4",1},
		{"modifier_puck_coil_attacks",1,"purple",1,"purple_skill","Coil",18,4,"Coil_5",1},
		{"modifier_puck_coil_cooldowns",1,"purple",1,"purple_skill","Coil",22,4,"Coil_6",0},

		{"modifier_puck_orb_legendary",1,"orange",0,"orange_skill","Orb",25,1,1},
		{"modifier_puck_rift_legendary",1,"orange",0,"orange_skill","Rift",17,1,2},
		{"modifier_puck_shift_legendary",1,"orange",0,"orange_skill","Shift",22,1,3},
		{"modifier_puck_coil_legendary",1,"orange",0,"orange_skill","Coil",22,1,4},
	},

	npc_dota_hero_void_spirit = {
		{"modifier_void_remnant_1",1,"blue",3,"blue_skill","Remnant",18,1,"Remnant_1",0},
		{"modifier_void_remnant_2",1,"blue",3,"blue_skill","Remnant",25,1,"Remnant_2",1},
		{"modifier_void_remnant_3",1,"blue",3,"blue_skill","Remnant",18,1,"Remnant_3",0},
	
		{"modifier_void_astral_1",1,"blue",3,"blue_skill","Astral",22,2,"Astral_1",0},
		{"modifier_void_astral_2",1,"blue",3,"blue_skill","Astral",18,2,"Astral_2",0},
		{"modifier_void_astral_3",1,"blue",3,"blue_skill","Astral",22,2,"Astral_3",0},
	
		{"modifier_void_pulse_1",1,"blue",3,"blue_skill","Pulse",22,3,"Pulse_1",0},
		{"modifier_void_pulse_2",1,"blue",3,"blue_skill","Pulse",22,3,"Pulse_2",0},
		{"modifier_void_pulse_3",1,"blue",3,"blue_skill","Pulse",22,3,"Pulse_4",0},
	
		{"modifier_void_step_1",1,"blue",3,"blue_skill","Step",22,4,"Step_1",0},
		{"modifier_void_step_2",1,"blue",3,"blue_skill","Step",18,4,"Step_2",0},
		{"modifier_void_step_3",1,"blue",3,"blue_skill","Step",22,4,"Step_3",1},

		{"modifier_void_remnant_4",1,"purple",2,"purple_skill","Remnant",18,1,"Remnant_4",0},
		{"modifier_void_remnant_5",1,"purple",1,"purple_skill","Remnant",25,1,"Remnant_5",1},
		{"modifier_void_remnant_6",1,"purple",1,"purple_skill","Remnant",18,1,"Remnant_6",1},
	
		{"modifier_void_astral_4",1,"purple",2,"purple_skill","Astral",22,2,"Astral_4",1},
		{"modifier_void_astral_5",1,"purple",1,"purple_skill","Astral",18,2,"Astral_5",1},
		{"modifier_void_astral_6",1,"purple",1,"purple_skill","Astral",22,2,"Astral_6",1},
	
		{"modifier_void_pulse_4",1,"purple",2,"purple_skill","Pulse",22,3,"Pulse_3",1},
		{"modifier_void_pulse_5",1,"purple",1,"purple_skill","Pulse",22,3,"Pulse_5",1},
		{"modifier_void_pulse_6",1,"purple",1,"purple_skill","Pulse",22,3,"Pulse_6",0},
	
		{"modifier_void_step_4",1,"purple",2,"purple_skill","Step",22,4,"Step_4",1},
		{"modifier_void_step_5",1,"purple",1,"purple_skill","Step",18,4,"Step_5",1},
		{"modifier_void_step_6",1,"purple",1,"purple_skill","Step",22,4,"Step_6",1},

		{"modifier_void_remnant_legendary",1,"orange",0,"orange_skill","Remnant",25,1,1},
		{"modifier_void_astral_legendary",1,"orange",0,"orange_skill","Astral",17,1,2},
		{"modifier_void_pulse_legendary",1,"orange",0,"orange_skill","Pulse",22,1,3},
		{"modifier_void_step_legendary",1,"orange",0,"orange_skill","Step",22,1,4},
	},

	npc_dota_hero_ember_spirit = {
		{"modifier_ember_chain_1",1,"blue",3,"blue_skill","Chain",18,1,"Chain_1",0},
		{"modifier_ember_chain_2",1,"blue",3,"blue_skill","Chain",25,1,"Chain_2",0},
		{"modifier_ember_chain_3",1,"blue",3,"blue_skill","Chain",18,1,"Chain_3",1},
	
		{"modifier_ember_fist_1",1,"blue",3,"blue_skill","Fist",22,2,"Fist_1",0},
		{"modifier_ember_fist_2",1,"blue",3,"blue_skill","Fist",18,2,"Fist_4",0},
		{"modifier_ember_fist_3",1,"blue",3,"blue_skill","Fist",22,2,"Fist_3",1},
	
		{"modifier_ember_guard_1",1,"blue",3,"blue_skill","Guard",22,3,"Guard_1",0},
		{"modifier_ember_guard_2",1,"blue",3,"blue_skill","Guard",22,3,"Guard_2",0},
		{"modifier_ember_guard_3",1,"blue",3,"blue_skill","Guard",22,3,"Guard_3",0},
	
		{"modifier_ember_remnant_1",1,"blue",3,"blue_skill","FireRemnant",22,4,"FireRemnant_1",0},
		{"modifier_ember_remnant_2",1,"blue",3,"blue_skill","FireRemnant",18,4,"FireRemnant_5",0},
		{"modifier_ember_remnant_3",1,"blue",3,"blue_skill","FireRemnant",22,4,"FireRemnant_3",1},

		{"modifier_ember_chain_4",1,"purple",2,"purple_skill","Chain",18,1,"Chain_4",0},
		{"modifier_ember_chain_5",1,"purple",1,"purple_skill","Chain",25,1,"Chain_5",1},
		{"modifier_ember_chain_6",1,"purple",1,"purple_skill","Chain",18,1,"Chain_6",0},
	
		{"modifier_ember_fist_4",1,"purple",2,"purple_skill","Fist",22,2,"Fist_5",0},
		{"modifier_ember_fist_5",1,"purple",1,"purple_skill","Fist",18,2,"Fist_2",0},
		{"modifier_ember_fist_6",1,"purple",1,"purple_skill","Fist",22,2,"Fist_6",1},
	
		{"modifier_ember_guard_4",1,"purple",2,"purple_skill","Guard",22,3,"Guard_4",1},
		{"modifier_ember_guard_5",1,"purple",1,"purple_skill","Guard",22,3,"Guard_5",1},
		{"modifier_ember_guard_6",1,"purple",1,"purple_skill","Guard",22,3,"Guard_6",1},
	
		{"modifier_ember_remnant_4",1,"purple",2,"purple_skill","FireRemnant",22,4,"FireRemnant_4",1},
		{"modifier_ember_remnant_5",1,"purple",1,"purple_skill","FireRemnant",18,4,"FireRemnant_2",1},
		{"modifier_ember_remnant_6",1,"purple",1,"purple_skill","FireRemnant",22,4,"FireRemnant_6",1},

		{"modifier_ember_chain_legendary",1,"orange",0,"orange_skill","Chain",25,1,1},
		{"modifier_ember_fist_legendary",1,"orange",0,"orange_skill","Fist",17,1,2},
		{"modifier_ember_guard_legendary",1,"orange",0,"orange_skill","Guard",22,1,3},
		{"modifier_ember_remnant_legendary",1,"orange",0,"orange_skill","FireRemnant",22,1,4},
	},

	npc_dota_hero_pudge = {
		{"modifier_pudge_hook_1",1,"blue",3,"blue_skill","hook",18,1,"hook_1",0},
		{"modifier_pudge_hook_2",1,"blue",3,"blue_skill","hook",25,1,"hook_2",0},
		{"modifier_pudge_hook_3",1,"blue",3,"blue_skill","hook",18,1,"hook_3",0},
	
		{"modifier_pudge_rot_1",1,"blue",3,"blue_skill","rot",22,2,"rot_1",0},
		{"modifier_pudge_rot_2",1,"blue",3,"blue_skill","rot",18,2,"rot_2",0},
		{"modifier_pudge_rot_3",1,"blue",3,"blue_skill","rot",22,2,"rot_3",0},
	
		{"modifier_pudge_flesh_1",1,"blue",3,"blue_skill","flesh",22,3,"flesh_1",0},
		{"modifier_pudge_flesh_2",1,"blue",3,"blue_skill","flesh",22,3,"flesh_2",0},
		{"modifier_pudge_flesh_3",1,"blue",3,"blue_skill","flesh",22,3,"flesh_3",0},
	
		{"modifier_pudge_dismember_1",1,"blue",3,"blue_skill","dismember",22,4,"dismember_3",0},
		{"modifier_pudge_dismember_2",1,"blue",3,"blue_skill","dismember",18,4,"dismember_2",0},
		{"modifier_pudge_dismember_3",1,"blue",3,"blue_skill","dismember",22,4,"dismember_1",0},

		{"modifier_pudge_hook_4",1,"purple",2,"purple_skill","hook",18,1,"hook_4",0},
		{"modifier_pudge_hook_5",1,"purple",1,"purple_skill","hook",25,1,"hook_5",1},
		{"modifier_pudge_hook_6",1,"purple",1,"purple_skill","hook",18,1,"hook_6",1},
	
		{"modifier_pudge_rot_4",1,"purple",2,"purple_skill","rot",22,2,"rot_4",0},
		{"modifier_pudge_rot_5",1,"purple",1,"purple_skill","rot",18,2,"rot_5",1},
		{"modifier_pudge_rot_6",1,"purple",1,"purple_skill","rot",22,2,"rot_6",0},
	
		{"modifier_pudge_flesh_4",1,"purple",2,"purple_skill","flesh",22,3,"flesh_4",1},
		{"modifier_pudge_flesh_5",1,"purple",1,"purple_skill","flesh",22,3,"flesh_5",0},
		{"modifier_pudge_flesh_6",1,"purple",1,"purple_skill","flesh",22,3,"flesh_6",0},
	
		{"modifier_pudge_dismember_4",1,"purple",2,"purple_skill","dismember",22,4,"dismember_4",0},
		{"modifier_pudge_dismember_5",1,"purple",1,"purple_skill","dismember",18,4,"dismember_5",0},
		{"modifier_pudge_dismember_6",1,"purple",1,"purple_skill","dismember",22,4,"dismember_6",0},

		{"modifier_pudge_hook_legendary",1,"orange",0,"orange_skill","hook",25,1,1},
		{"modifier_pudge_rot_legendary",1,"orange",0,"orange_skill","rot",17,1,2},
		{"modifier_pudge_flesh_legendary",1,"orange",0,"orange_skill","flesh",22,1,3},
		{"modifier_pudge_dismember_legendary",1,"orange",0,"orange_skill","dismember",22,1,4},
	},

	npc_dota_hero_hoodwink = {
		{"modifier_hoodwink_acorn_1",1,"blue",3,"blue_skill","acorn",18,1,"acorn_1",0},
		{"modifier_hoodwink_acorn_2",1,"blue",3,"blue_skill","acorn",25,1,"acorn_2",1},
		{"modifier_hoodwink_acorn_3",1,"blue",3,"blue_skill","acorn",18,1,"acorn_4",0},
	
		{"modifier_hoodwink_bush_1",1,"blue",3,"blue_skill","bush",22,2,"bush_1",0},
		{"modifier_hoodwink_bush_2",1,"blue",3,"blue_skill","bush",18,2,"bush_2",0},
		{"modifier_hoodwink_bush_3",1,"blue",3,"blue_skill","bush",22,2,"bush_3",1},
	
		{"modifier_hoodwink_scurry_1",1,"blue",3,"blue_skill","scurry",22,3,"scurry_1",1},
		{"modifier_hoodwink_scurry_2",1,"blue",3,"blue_skill","scurry",22,3,"scurry_2",0},
		{"modifier_hoodwink_scurry_3",1,"blue",3,"blue_skill","scurry",22,3,"scurry_3",0},
	
		{"modifier_hoodwink_sharp_1",1,"blue",3,"blue_skill","sharp",22,4,"sharp_1",0},
		{"modifier_hoodwink_sharp_2",1,"blue",3,"blue_skill","sharp",18,4,"sharp_2",0},
		{"modifier_hoodwink_sharp_3",1,"blue",3,"blue_skill","sharp",22,4,"sharp_3",1},

		{"modifier_hoodwink_acorn_4",1,"purple",2,"purple_skill","acorn",18,1,"acorn_3",0},
		{"modifier_hoodwink_acorn_5",1,"purple",1,"purple_skill","acorn",25,1,"acorn_5",1},
		{"modifier_hoodwink_acorn_6",1,"purple",1,"purple_skill","acorn",18,1,"acorn_6",0},
	
		{"modifier_hoodwink_bush_4",1,"purple",2,"purple_skill","bush",22,2,"bush_4",1},
		{"modifier_hoodwink_bush_5",1,"purple",1,"purple_skill","bush",18,2,"bush_5",1},
		{"modifier_hoodwink_bush_6",1,"purple",1,"purple_skill","bush",22,2,"bush_6",1},
	
		{"modifier_hoodwink_scurry_4",1,"purple",2,"purple_skill","scurry",22,3,"scurry_4",1},
		{"modifier_hoodwink_scurry_5",1,"purple",1,"purple_skill","scurry",22,3,"scurry_5",0},
		{"modifier_hoodwink_scurry_6",1,"purple",1,"purple_skill","scurry",22,3,"scurry_6",1},
	
		{"modifier_hoodwink_sharp_4",1,"purple",2,"purple_skill","sharp",22,4,"sharp_4",0},
		{"modifier_hoodwink_sharp_5",1,"purple",1,"purple_skill","sharp",18,4,"sharp_5",1},
		{"modifier_hoodwink_sharp_6",1,"purple",1,"purple_skill","sharp",22,4,"sharp_6",0},

		{"modifier_hoodwink_acorn_legendary",1,"orange",0,"orange_skill","acorn",25,1,1},
		{"modifier_hoodwink_bush_legendary",1,"orange",0,"orange_skill","bush",17,1,2},
		{"modifier_hoodwink_scurry_legendary",1,"orange",0,"orange_skill","scurry",22,1,3},
		{"modifier_hoodwink_sharp_legendary",1,"orange",0,"orange_skill","sharp",22,1,4},
	},

	npc_dota_hero_skeleton_king = {
		{"modifier_skeleton_blast_1",1,"blue",3,"blue_skill","blast",18,1,"blast_1",0},
		{"modifier_skeleton_blast_2",1,"blue",3,"blue_skill","blast",25,1,"blast_2",0},
		{"modifier_skeleton_blast_3",1,"blue",3,"blue_skill","blast",18,1,"blast_3",0},
	
		{"modifier_skeleton_vampiric_1",1,"blue",3,"blue_skill","vampiric",22,2,"vampiric_1",0},
		{"modifier_skeleton_vampiric_2",1,"blue",3,"blue_skill","vampiric",18,2,"vampiric_3",1},
		{"modifier_skeleton_vampiric_3",1,"blue",3,"blue_skill","vampiric",22,2,"vampiric_4",0},
	
		{"modifier_skeleton_strike_1",1,"blue",3,"blue_skill","strike",22,3,"strike_1",0},
		{"modifier_skeleton_strike_2",1,"blue",3,"blue_skill","strike",22,3,"strike_2",1},
		{"modifier_skeleton_strike_3",1,"blue",3,"blue_skill","strike",22,3,"strike_3",0},
	
		{"modifier_skeleton_reincarnation_1",1,"blue",3,"blue_skill","reincarnation",22,4,"reincarnation_1",1},
		{"modifier_skeleton_reincarnation_2",1,"blue",3,"blue_skill","reincarnation",18,4,"reincarnation_2",0},
		{"modifier_skeleton_reincarnation_3",1,"blue",3,"blue_skill","reincarnation",22,4,"reincarnation_3",1},

		{"modifier_skeleton_blast_4",1,"purple",2,"purple_skill","blast",18,1,"blast_4",1},
		{"modifier_skeleton_blast_5",1,"purple",1,"purple_skill","blast",25,1,"blast_5",0},
		{"modifier_skeleton_blast_6",1,"purple",1,"purple_skill","blast",18,1,"blast_6",1},
	
		{"modifier_skeleton_vampiric_4",1,"purple",2,"purple_skill","vampiric",22,2,"vampiric_2",1},
		{"modifier_skeleton_vampiric_5",1,"purple",1,"purple_skill","vampiric",18,2,"vampiric_5",1},
		{"modifier_skeleton_vampiric_6",1,"purple",1,"purple_skill","vampiric",22,2,"vampiric_6",1},
	
		{"modifier_skeleton_strike_4",1,"purple",2,"purple_skill","strike",22,3,"strike_4",1},
		{"modifier_skeleton_strike_5",1,"purple",1,"purple_skill","strike",22,3,"strike_5",1},
		{"modifier_skeleton_strike_6",1,"purple",1,"purple_skill","strike",22,3,"strike_6",1},
	
		{"modifier_skeleton_reincarnation_4",1,"purple",2,"purple_skill","reincarnation",22,4,"reincarnation_6",1},
		{"modifier_skeleton_reincarnation_5",1,"purple",1,"purple_skill","reincarnation",18,4,"reincarnation_5",1},
		{"modifier_skeleton_reincarnation_6",1,"purple",1,"purple_skill","reincarnation",22,4,"reincarnation_4",0},

		{"modifier_skeleton_blast_legendary",1,"orange",0,"orange_skill","blast",25,1,1},
		{"modifier_skeleton_vampiric_legendary",1,"orange",0,"orange_skill","vampiric",17,1,2},
		{"modifier_skeleton_strike_legendary",1,"orange",0,"orange_skill","strike",22,1,3},
		{"modifier_skeleton_reincarnation_legendary",1,"orange",0,"orange_skill","reincarnation",22,1,4},
	},

	npc_dota_hero_lina = {
		{"modifier_lina_dragon_1",1,"blue",3,"blue_skill","dragon",18,1,"dragon_1",0},
		{"modifier_lina_dragon_2",1,"blue",3,"blue_skill","dragon",25,1,"dragon_2",1},
		{"modifier_lina_dragon_3",1,"blue",3,"blue_skill","dragon",18,1,"dragon_3",0},
	
		{"modifier_lina_array_1",1,"blue",3,"blue_skill","array",22,2,"array_1",1},
		{"modifier_lina_array_2",1,"blue",3,"blue_skill","array",18,2,"array_2",0},
		{"modifier_lina_array_3",1,"blue",3,"blue_skill","array",22,2,"array_3",0},
	
		{"modifier_lina_soul_1",1,"blue",3,"blue_skill","soul",22,3,"soul_1",0},
		{"modifier_lina_soul_2",1,"blue",3,"blue_skill","soul",22,3,"soul_2",0},
		{"modifier_lina_soul_3",1,"blue",3,"blue_skill","soul",22,3,"soul_3",0},
	
		{"modifier_lina_laguna_1",1,"blue",3,"blue_skill","laguna",22,4,"laguna_1",0},
		{"modifier_lina_laguna_2",1,"blue",3,"blue_skill","laguna",18,4,"laguna_2",0},
		{"modifier_lina_laguna_3",1,"blue",3,"blue_skill","laguna",22,4,"laguna_3",0},

		{"modifier_lina_dragon_4",1,"purple",2,"purple_skill","dragon",18,1,"dragon_4",1},
		{"modifier_lina_dragon_5",1,"purple",1,"purple_skill","dragon",25,1,"dragon_5",0},
		{"modifier_lina_dragon_6",1,"purple",1,"purple_skill","dragon",18,1,"dragon_6",1},
	
		{"modifier_lina_array_4",1,"purple",2,"purple_skill","array",22,2,"array_5",1},
		{"modifier_lina_array_5",1,"purple",1,"purple_skill","array",18,2,"array_4",1},
		{"modifier_lina_array_6",1,"purple",1,"purple_skill","array",22,2,"array_6",1},
	
		{"modifier_lina_soul_4",1,"purple",2,"purple_skill","soul",22,3,"soul_4",1},
		{"modifier_lina_soul_5",1,"purple",1,"purple_skill","soul",22,3,"soul_5",0},
		{"modifier_lina_soul_6",1,"purple",1,"purple_skill","soul",22,3,"soul_6",1},
	
		{"modifier_lina_laguna_4",1,"purple",2,"purple_skill","laguna",22,4,"laguna_4",0},
		{"modifier_lina_laguna_5",1,"purple",1,"purple_skill","laguna",18,4,"laguna_5",1},
		{"modifier_lina_laguna_6",1,"purple",1,"purple_skill","laguna",22,4,"laguna_6",1},

		{"modifier_lina_dragon_legendary",1,"orange",0,"orange_skill","dragon",25,1,1},
		{"modifier_lina_array_legendary",1,"orange",0,"orange_skill","array",17,1,2},
		{"modifier_lina_soul_legendary",1,"orange",0,"orange_skill","soul",22,1,3},
		{"modifier_lina_laguna_legendary",1,"orange",0,"orange_skill","laguna",22,1,4},
	},

	npc_dota_hero_troll_warlord = {
		{"modifier_troll_rage_1",1,"blue",3,"blue_skill","rage",18,1,"rage_1",0},
		{"modifier_troll_rage_2",1,"blue",3,"blue_skill","rage",25,1,"rage_2",1},
		{"modifier_troll_rage_3",1,"blue",3,"blue_skill","rage",18,1,"rage_3",0},
	
		{"modifier_troll_axes_1",1,"blue",3,"blue_skill","axes",22,2,"axes_1",0},
		{"modifier_troll_axes_2",1,"blue",3,"blue_skill","axes",18,2,"axes_2",0},
		{"modifier_troll_axes_3",1,"blue",3,"blue_skill","axes",22,2,"axes_3",0},
	
		{"modifier_troll_fervor_1",1,"blue",3,"blue_skill","fervor",22,3,"fervor_1",0},
		{"modifier_troll_fervor_2",1,"blue",3,"blue_skill","fervor",22,3,"fervor_2",0},
		{"modifier_troll_fervor_3",1,"blue",3,"blue_skill","fervor",22,3,"fervor_3",0},
	
		{"modifier_troll_trance_1",1,"blue",3,"blue_skill","trance",22,4,"trance_1",0},
		{"modifier_troll_trance_2",1,"blue",3,"blue_skill","trance",18,4,"trance_2",0},
		{"modifier_troll_trance_3",1,"blue",3,"blue_skill","trance",22,4,"trance_3",0},

		{"modifier_troll_rage_4",1,"purple",2,"purple_skill","rage",18,1,"rage_4",1},
		{"modifier_troll_rage_5",1,"purple",1,"purple_skill","rage",25,1,"rage_5",1},
		{"modifier_troll_rage_6",1,"purple",1,"purple_skill","rage",18,1,"rage_6",0},
	
		{"modifier_troll_axes_4",1,"purple",2,"purple_skill","axes",22,2,"axes_4",1},
		{"modifier_troll_axes_5",1,"purple",1,"purple_skill","axes",18,2,"axes_5",0},
		{"modifier_troll_axes_6",1,"purple",1,"purple_skill","axes",22,2,"axes_6",1},
	
		{"modifier_troll_fervor_4",1,"purple",2,"purple_skill","fervor",22,3,"fervor_4",1},
		{"modifier_troll_fervor_5",1,"purple",1,"purple_skill","fervor",22,3,"fervor_5",1},
		{"modifier_troll_fervor_6",1,"purple",1,"purple_skill","fervor",22,3,"fervor_6",0},
	
		{"modifier_troll_trance_4",1,"purple",2,"purple_skill","trance",22,4,"trance_4",1},
		{"modifier_troll_trance_5",1,"purple",1,"purple_skill","trance",18,4,"trance_5",1},
		{"modifier_troll_trance_6",1,"purple",1,"purple_skill","trance",22,4,"trance_6",1},

		{"modifier_troll_rage_legendary",1,"orange",0,"orange_skill","rage",25,1,1},
		{"modifier_troll_axes_legendary",1,"orange",0,"orange_skill","axes",17,1,2},
		{"modifier_troll_fervor_legendary",1,"orange",0,"orange_skill","fervor",22,1,3},
		{"modifier_troll_trance_legendary",1,"orange",0,"orange_skill","trance",22,1,4},
	},

	npc_dota_hero_axe = {
		{"modifier_axe_call_1",1,"blue",3,"blue_skill","call",18,1,"call_1",1},
		{"modifier_axe_call_2",1,"blue",3,"blue_skill","call",25,1,"call_2",0},
		{"modifier_axe_call_3",1,"blue",3,"blue_skill","call",18,1,"call_3",1},
	
		{"modifier_axe_hunger_1",1,"blue",3,"blue_skill","hunger",22,2,"hunger_1",0},
		{"modifier_axe_hunger_2",1,"blue",3,"blue_skill","hunger",18,2,"hunger_2",0},
		{"modifier_axe_hunger_3",1,"blue",3,"blue_skill","hunger",22,2,"hunger_3",0},
	
		{"modifier_axe_helix_1",1,"blue",3,"blue_skill","helix",22,3,"helix_1",0},
		{"modifier_axe_helix_2",1,"blue",3,"blue_skill","helix",22,3,"helix_2",0},
		{"modifier_axe_helix_3",1,"blue",3,"blue_skill","helix",22,3,"helix_3",0},
	
		{"modifier_axe_culling_1",1,"blue",3,"blue_skill","culling",22,4,"culling_1",0},
		{"modifier_axe_culling_2",1,"blue",3,"blue_skill","culling",18,4,"culling_2",1},
		{"modifier_axe_culling_3",1,"blue",3,"blue_skill","culling",22,4,"culling_3",0},

		{"modifier_axe_call_4",1,"purple",2,"purple_skill","call",18,1,"call_4",1},
		{"modifier_axe_call_5",1,"purple",1,"purple_skill","call",25,1,"call_5",1},
		{"modifier_axe_call_6",1,"purple",1,"purple_skill","call",18,1,"call_6",1},
	
		{"modifier_axe_hunger_4",1,"purple",2,"purple_skill","hunger",22,2,"hunger_4",0},
		{"modifier_axe_hunger_5",1,"purple",1,"purple_skill","hunger",18,2,"hunger_5",1},
		{"modifier_axe_hunger_6",1,"purple",1,"purple_skill","hunger",22,2,"hunger_6",1},
	
		{"modifier_axe_helix_4",1,"purple",2,"purple_skill","helix",22,3,"helix_4",1},
		{"modifier_axe_helix_5",1,"purple",1,"purple_skill","helix",22,3,"helix_5",0},
		{"modifier_axe_helix_6",1,"purple",1,"purple_skill","helix",22,3,"helix_6",1},
	
		{"modifier_axe_culling_4",1,"purple",2,"purple_skill","culling",22,4,"culling_4",1},
		{"modifier_axe_culling_5",1,"purple",1,"purple_skill","culling",18,4,"culling_5",1},
		{"modifier_axe_culling_6",1,"purple",1,"purple_skill","culling",22,4,"culling_6",0},

		{"modifier_axe_call_legendary",1,"orange",0,"orange_skill","call",25,1,1},
		{"modifier_axe_hunger_legendary",1,"orange",0,"orange_skill","hunger",17,1,2},
		{"modifier_axe_helix_legendary",1,"orange",0,"orange_skill","helix",22,1,3},
		{"modifier_axe_culling_legendary",1,"orange",0,"orange_skill","culling",22,1,4},
	},

	npc_dota_hero_alchemist = {
		{"modifier_alchemist_spray_1",1,"blue",3,"blue_skill","acid",25,1,"acid_1",0},
		{"modifier_alchemist_spray_2",1,"blue",3,"blue_skill","acid",25,1,"acid_2",0},
		{"modifier_alchemist_spray_3",1,"blue",3,"blue_skill","acid",25,1,"acid_3",0},
	
		{"modifier_alchemist_unstable_1",1,"blue",3,"blue_skill","unstable",25,2,"unstable_1",0},
		{"modifier_alchemist_unstable_2",1,"blue",3,"blue_skill","unstable",25,2,"unstable_2",1},
		{"modifier_alchemist_unstable_3",1,"blue",3,"blue_skill","unstable",25,2,"unstable_3",0},
	
		{"modifier_alchemist_greed_1",1,"blue",3,"blue_skill","greed",25,3,"greed_1",0},
		{"modifier_alchemist_greed_2",1,"blue",3,"blue_skill","greed",25,3,"greed_2",0},
		{"modifier_alchemist_greed_3",1,"blue",3,"blue_skill","greed",25,3,"greed_3",0},
	
		{"modifier_alchemist_rage_1",1,"blue",3,"blue_skill","chemical",25,4,"chemical_1",0},
		{"modifier_alchemist_rage_2",1,"blue",3,"blue_skill","chemical",25,4,"chemical_2",0},
		{"modifier_alchemist_rage_3",1,"blue",3,"blue_skill","chemical",25,4,"chemical_3",0},

		{"modifier_alchemist_spray_4",1,"purple",2,"purple_skill","acid",25,1,"acid_4",0},
		{"modifier_alchemist_spray_5",1,"purple",1,"purple_skill","acid",25,1,"acid_5",1},
		{"modifier_alchemist_spray_6",1,"purple",1,"purple_skill","acid",25,1,"acid_6",1},
	
		{"modifier_alchemist_unstable_4",1,"purple",2,"purple_skill","unstable",25,2,"unstable_4",0},
		{"modifier_alchemist_unstable_5",1,"purple",1,"purple_skill","unstable",25,2,"unstable_5",1},
		{"modifier_alchemist_unstable_6",1,"purple",1,"purple_skill","unstable",25,2,"unstable_6",1},
	
		{"modifier_alchemist_greed_4",1,"purple",2,"purple_skill","greed",25,3,"greed_4",0},
		{"modifier_alchemist_greed_5",1,"purple",1,"purple_skill","greed",25,3,"greed_5",1},
		{"modifier_alchemist_greed_6",1,"purple",1,"purple_skill","greed",25,3,"greed_6",1},
	
		{"modifier_alchemist_rage_4",1,"purple",2,"purple_skill","chemical",25,4,"chemical_4",1},
		{"modifier_alchemist_rage_5",1,"purple",1,"purple_skill","chemical",25,4,"chemical_5",1},
		{"modifier_alchemist_rage_6",1,"purple",1,"purple_skill","chemical",25,4,"chemical_6",1},

		{"modifier_alchemist_spray_legendary",1,"orange",0,"orange_skill","acid",18,1,1},
		{"modifier_alchemist_unstable_legendary",1,"orange",0,"orange_skill","unstable",22,1,2},
		{"modifier_alchemist_greed_legendary",1,"orange",0,"orange_skill","greed",20,1,3},
		{"modifier_alchemist_rage_legendary",1,"orange",0,"orange_skill","chemical",19,1,4},
	},

	npc_dota_hero_ogre_magi = {
		{"modifier_ogremagi_blast_1",1,"blue",3,"blue_skill","fireblast",25,1,"fireblast_1",0},
		{"modifier_ogremagi_blast_2",1,"blue",3,"blue_skill","fireblast",25,1,"fireblast_2",1},
		{"modifier_ogremagi_blast_3",1,"blue",3,"blue_skill","fireblast",25,1,"fireblast_3",0},
	
		{"modifier_ogremagi_ignite_1",1,"blue",3,"blue_skill","ignite",25,2,"ignite_1",0},
		{"modifier_ogremagi_ignite_2",1,"blue",3,"blue_skill","ignite",25,2,"ignite_2",0},
		{"modifier_ogremagi_ignite_3",1,"blue",3,"blue_skill","ignite",25,2,"ignite_3",1},
	
		{"modifier_ogremagi_bloodlust_1",1,"blue",3,"blue_skill","bloodlust",25,3,"bloodlust_1",0},
		{"modifier_ogremagi_bloodlust_2",1,"blue",3,"blue_skill","bloodlust",25,3,"bloodlust_2",0},
		{"modifier_ogremagi_bloodlust_3",1,"blue",3,"blue_skill","bloodlust",25,3,"bloodlust_3",0},
	
		{"modifier_ogremagi_multi_1",1,"blue",3,"blue_skill","multicast",25,4,"multicast_1",0},
		{"modifier_ogremagi_multi_2",1,"blue",3,"blue_skill","multicast",25,4,"multicast_2",0},
		{"modifier_ogremagi_multi_3",1,"blue",3,"blue_skill","multicast",25,4,"multicast_3",1},

		{"modifier_ogremagi_blast_4",1,"purple",2,"purple_skill","fireblast",25,1,"fireblast_4",1},
		{"modifier_ogremagi_blast_5",1,"purple",1,"purple_skill","fireblast",25,1,"fireblast_5",0},
		{"modifier_ogremagi_blast_6",1,"purple",1,"purple_skill","fireblast",25,1,"fireblast_6",1},
	
		{"modifier_ogremagi_ignite_4",1,"purple",2,"purple_skill","ignite",25,2,"ignite_4",0},
		{"modifier_ogremagi_ignite_5",1,"purple",1,"purple_skill","ignite",25,2,"ignite_5",1},
		{"modifier_ogremagi_ignite_6",1,"purple",1,"purple_skill","ignite",25,2,"ignite_6",1},
	
		{"modifier_ogremagi_bloodlust_4",1,"purple",2,"purple_skill","bloodlust",25,3,"bloodlust_4",1},
		{"modifier_ogremagi_bloodlust_5",1,"purple",1,"purple_skill","bloodlust",25,3,"bloodlust_5",1},
		{"modifier_ogremagi_bloodlust_6",1,"purple",1,"purple_skill","bloodlust",25,3,"bloodlust_6",1},
	
		{"modifier_ogremagi_multi_4",1,"purple",2,"purple_skill","multicast",25,4,"multicast_4",1},
		{"modifier_ogremagi_multi_5",1,"purple",1,"purple_skill","multicast",25,4,"multicast_5",1},
		{"modifier_ogremagi_multi_6",1,"purple",1,"purple_skill","multicast",25,4,"multicast_6",0},

		{"modifier_ogremagi_blast_7",1,"orange",0,"orange_skill","fireblast",18,1,1},
		{"modifier_ogremagi_ignite_7",1,"orange",0,"orange_skill","ignite",22,1,2},
		{"modifier_ogremagi_bloodlust_7",1,"orange",0,"orange_skill","bloodlust",20,0,3},
		{"modifier_ogremagi_multi_7",1,"orange",0,"orange_skill","multicast",19,1,4},
	},

	npc_dota_hero_antimage = {
		{"modifier_antimage_break_1",1,"blue",3,"blue_skill","manabreak",25,1,"manabreak_1",0},
		{"modifier_antimage_break_2",1,"blue",3,"blue_skill","manabreak",25,1,"manabreak_2",1},
		{"modifier_antimage_break_3",1,"blue",3,"blue_skill","manabreak",25,1,"manabreak_3",0},
	
		{"modifier_antimage_blink_1",1,"blue",3,"blue_skill","antimage_blink",25,2,"antimage_blink_1",1},
		{"modifier_antimage_blink_2",1,"blue",3,"blue_skill","antimage_blink",25,2,"antimage_blink_2",1},
		{"modifier_antimage_blink_3",1,"blue",3,"blue_skill","antimage_blink",25,2,"antimage_blink_3",0},
	
		{"modifier_antimage_counter_1",1,"blue",3,"blue_skill","counterspell",25,3,"counterspell_1",0},
		{"modifier_antimage_counter_2",1,"blue",3,"blue_skill","counterspell",25,3,"counterspell_2",1},
		{"modifier_antimage_counter_3",1,"blue",3,"blue_skill","counterspell",25,3,"counterspell_3",0},
	
		{"modifier_antimage_void_1",1,"blue",3,"blue_skill","manavoid",25,4,"manavoid_1",0},
		{"modifier_antimage_void_2",1,"blue",3,"blue_skill","manavoid",25,4,"manavoid_2",0},
		{"modifier_antimage_void_3",1,"blue",3,"blue_skill","manavoid",25,4,"manavoid_3",0},

		{"modifier_antimage_break_4",1,"purple",2,"purple_skill","manabreak",25,1,"manabreak_4",1},
		{"modifier_antimage_break_5",1,"purple",1,"purple_skill","manabreak",25,1,"manabreak_5",1},
		{"modifier_antimage_break_6",1,"purple",1,"purple_skill","manabreak",25,1,"manabreak_6",0},
	
		{"modifier_antimage_blink_4",1,"purple",2,"purple_skill","antimage_blink",25,2,"antimage_blink_4",1},
		{"modifier_antimage_blink_5",1,"purple",1,"purple_skill","antimage_blink",25,2,"antimage_blink_5",0},
		{"modifier_antimage_blink_6",1,"purple",1,"purple_skill","antimage_blink",25,2,"antimage_blink_6",1},
	
		{"modifier_antimage_counter_4",1,"purple",2,"purple_skill","counterspell",25,3,"counterspell_4",1},
		{"modifier_antimage_counter_5",1,"purple",1,"purple_skill","counterspell",25,3,"counterspell_5",1},
		{"modifier_antimage_counter_6",1,"purple",1,"purple_skill","counterspell",25,3,"counterspell_6",1},
	
		{"modifier_antimage_void_4",1,"purple",2,"purple_skill","manavoid",25,4,"manavoid_4",1},
		{"modifier_antimage_void_5",1,"purple",1,"purple_skill","manavoid",25,4,"manavoid_5",1},
		{"modifier_antimage_void_6",1,"purple",1,"purple_skill","manavoid",25,4,"manavoid_6",1},

		{"modifier_antimage_break_7",1,"orange",0,"orange_skill","manabreak",18,1,1},
		{"modifier_antimage_blink_7",1,"orange",0,"orange_skill","antimage_blink",22,1,2},
		{"modifier_antimage_counter_7",1,"orange",0,"orange_skill","counterspell",20,1,3},
		{"modifier_antimage_void_7",1,"orange",0,"orange_skill","manavoid",19,1,4},
	},




	npc_dota_hero_antimage = {
		{"modifier_antimage_break_1",1,"blue",3,"blue_skill","manabreak",25,1,"manabreak_1",0},
		{"modifier_antimage_break_2",1,"blue",3,"blue_skill","manabreak",25,1,"manabreak_2",1},
		{"modifier_antimage_break_3",1,"blue",3,"blue_skill","manabreak",25,1,"manabreak_3",0},
	
		{"modifier_antimage_blink_1",1,"blue",3,"blue_skill","antimage_blink",25,2,"antimage_blink_1",1},
		{"modifier_antimage_blink_2",1,"blue",3,"blue_skill","antimage_blink",25,2,"antimage_blink_2",1},
		{"modifier_antimage_blink_3",1,"blue",3,"blue_skill","antimage_blink",25,2,"antimage_blink_3",0},
	
		{"modifier_antimage_counter_1",1,"blue",3,"blue_skill","counterspell",25,3,"counterspell_1",0},
		{"modifier_antimage_counter_2",1,"blue",3,"blue_skill","counterspell",25,3,"counterspell_2",1},
		{"modifier_antimage_counter_3",1,"blue",3,"blue_skill","counterspell",25,3,"counterspell_3",0},
	
		{"modifier_antimage_void_1",1,"blue",3,"blue_skill","manavoid",25,4,"manavoid_1",0},
		{"modifier_antimage_void_2",1,"blue",3,"blue_skill","manavoid",25,4,"manavoid_2",0},
		{"modifier_antimage_void_3",1,"blue",3,"blue_skill","manavoid",25,4,"manavoid_3",0},

		{"modifier_antimage_break_4",1,"purple",2,"purple_skill","manabreak",25,1,"manabreak_4",1},
		{"modifier_antimage_break_5",1,"purple",1,"purple_skill","manabreak",25,1,"manabreak_5",1},
		{"modifier_antimage_break_6",1,"purple",1,"purple_skill","manabreak",25,1,"manabreak_6",0},
	
		{"modifier_antimage_blink_4",1,"purple",2,"purple_skill","antimage_blink",25,2,"antimage_blink_4",1},
		{"modifier_antimage_blink_5",1,"purple",1,"purple_skill","antimage_blink",25,2,"antimage_blink_5",0},
		{"modifier_antimage_blink_6",1,"purple",1,"purple_skill","antimage_blink",25,2,"antimage_blink_6",1},
	
		{"modifier_antimage_counter_4",1,"purple",2,"purple_skill","counterspell",25,3,"counterspell_4",1},
		{"modifier_antimage_counter_5",1,"purple",1,"purple_skill","counterspell",25,3,"counterspell_5",1},
		{"modifier_antimage_counter_6",1,"purple",1,"purple_skill","counterspell",25,3,"counterspell_6",1},
	
		{"modifier_antimage_void_4",1,"purple",2,"purple_skill","manavoid",25,4,"manavoid_4",1},
		{"modifier_antimage_void_5",1,"purple",1,"purple_skill","manavoid",25,4,"manavoid_5",1},
		{"modifier_antimage_void_6",1,"purple",1,"purple_skill","manavoid",25,4,"manavoid_6",1},

		{"modifier_antimage_break_7",1,"orange",0,"orange_skill","manabreak",18,1,1},
		{"modifier_antimage_blink_7",1,"orange",0,"orange_skill","antimage_blink",22,1,2},
		{"modifier_antimage_counter_7",1,"orange",0,"orange_skill","counterspell",20,1,3},
		{"modifier_antimage_void_7",1,"orange",0,"orange_skill","manavoid",19,1,4},
	},


		npc_dota_hero_primal_beast = {
		{"modifier_primal_beast_onslaught_1",1,"blue",3,"blue_skill","onslaught",25,1,"onslaught_1",0},
		{"modifier_primal_beast_onslaught_2",1,"blue",3,"blue_skill","onslaught",25,1,"onslaught_2",1},
		{"modifier_primal_beast_onslaught_3",1,"blue",3,"blue_skill","onslaught",25,1,"onslaught_3",0},
	
		{"modifier_primal_beast_trample_1",1,"blue",3,"blue_skill","trample",25,2,"trample_1",1},
		{"modifier_primal_beast_trample_2",1,"blue",3,"blue_skill","trample",25,2,"trample_2",1},
		{"modifier_primal_beast_trample_3",1,"blue",3,"blue_skill","trample",25,2,"trample_3",0},
	
		{"modifier_primal_beast_uproar_1",1,"blue",3,"blue_skill","uproar",25,3,"uproar_1",0},
		{"modifier_primal_beast_uproar_2",1,"blue",3,"blue_skill","uproar",25,3,"uproar_2",1},
		{"modifier_primal_beast_uproar_3",1,"blue",3,"blue_skill","uproar",25,3,"uproar_3",0},
	
		{"modifier_primal_beast_pulverize_1",1,"blue",3,"blue_skill","pulverize",25,4,"pulverize_1",0},
		{"modifier_primal_beast_pulverize_2",1,"blue",3,"blue_skill","pulverize",25,4,"pulverize_2",0},
		{"modifier_primal_beast_pulverize_3",1,"blue",3,"blue_skill","pulverize",25,4,"pulverize_3",0},

		{"modifier_primal_beast_onslaught_4",1,"purple",2,"purple_skill","onslaught",25,1,"onslaught_4",1},
		{"modifier_primal_beast_onslaught_5",1,"purple",1,"purple_skill","onslaught",25,1,"onslaught_5",1},
		{"modifier_primal_beast_onslaught_6",1,"purple",1,"purple_skill","onslaught",25,1,"onslaught_6",0},
	
		{"modifier_primal_beast_trample_4",1,"purple",2,"purple_skill","trample",25,2,"trample_4",1},
		{"modifier_primal_beast_trample_5",1,"purple",1,"purple_skill","trample",25,2,"trample_5",0},
		{"modifier_primal_beast_trample_6",1,"purple",1,"purple_skill","trample",25,2,"trample_6",1},
	
		{"modifier_primal_beast_uproar_4",1,"purple",2,"purple_skill","uproar",25,3,"uproar_4",1},
		{"modifier_primal_beast_uproar_5",1,"purple",1,"purple_skill","uproar",25,3,"uproar_5",1},
		{"modifier_primal_beast_uproar_6",1,"purple",1,"purple_skill","uproar",25,3,"uproar_6",1},
	
		{"modifier_primal_beast_pulverize_4",1,"purple",2,"purple_skill","pulverize",25,4,"pulverize_4",1},
		{"modifier_primal_beast_pulverize_5",1,"purple",1,"purple_skill","pulverize",25,4,"pulverize_5",1},
		{"modifier_primal_beast_pulverize_6",1,"purple",1,"purple_skill","pulverize",25,4,"pulverize_6",1},

		{"modifier_primal_beast_onslaught_7",1,"orange",0,"orange_skill","onslaught",18,1,1},
		{"modifier_primal_beast_trample_7",1,"orange",0,"orange_skill","trample",22,1,2},
		{"modifier_primal_beast_uproar_7",1,"orange",0,"orange_skill","uproar",20,1,3},
		{"modifier_primal_beast_pulverize_7",1,"orange",0,"orange_skill","pulverize",19,1,4},
	},
}

for group_name, skill_group in pairs(skills) do
	for _, data in pairs(skill_group) do
		local path
		if data[2] == 1 then
			path = "upgrade/" .. group_name .. "/" .. data[1] .. ".lua"
		elseif data[2] == 0 then
			path = "upgrade/general/" .. data[1] .. ".lua"
		elseif data[2] == 2 then
			path = "upgrade/tower/" .. data[1] .. ".lua"
		end
		LinkLuaModifier(data[1], path, LUA_MODIFIER_MOTION_NONE)
	end
end

function upgrade:InitGameMode()
	ListenToGameEvent("entity_killed", Dynamic_Wrap(self, "OnEntityKilled"), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(self, "OnEntitySpawned"), self)

	CustomGameEventManager:RegisterListener("activate_choise", Dynamic_Wrap(self, "make_choise"))
	CustomGameEventManager:RegisterListener("refresh_sphere", Dynamic_Wrap(self, "refresh_sphere"))

	for group_name, skills_group in pairs(skills) do
		CustomNetTables:SetTableValue("all_upgrades", group_name, skills_group)
	end
end

function upgrade:OnEntitySpawned(params)
	local unit = EntIndexToHScript(params.entindex)
	local owner = unit:GetOwner()

	if not owner or owner == nil or owner:IsNull() then
		return
	end

	for i = 1, 11 do
		if players[i] ~= nil then
			if unit:GetUnitName() then
				unit.x_max = players[i].x_max
				unit.x_min = players[i].x_min
				unit.y_max = players[i].y_max
				unit.y_min = players[i].y_min
				unit.z = players[i].z
			end
		end
	end
end

function upgrade:OnEntityKilled(param)
	if param.entindex_attacker == nil then
		return
	end

	local hero = EntIndexToHScript(param.entindex_attacker)
	local unit = EntIndexToHScript(param.entindex_killed)

	if unit:IsRealHero() and unit:IsReincarnating() == false then
		if false and towers[unit:GetTeamNumber()] ~= nil then
			local tower = towers[unit:GetTeamNumber()]

			local damage = tower:GetMaxHealth() * Death_Tower_Damage
			if tower:HasModifier("modifier_tower_armor") then
				damage = tower:GetMaxHealth() * Death_Tower_Damage_reduced
			end

			tower:SetHealth(math.max(1, tower:GetHealth() - damage))
			if tower:GetHealth() == 1 then
				tower:Kill(nil, hero)
			end
		end

		if unit:HasModifier("modifier_final_duel") then
			unit:SetBuyBackDisabledByReapersScythe(true)
			unit:SetTimeUntilRespawn(round_timer + 3)
		else
			if players[unit:GetTeamNumber()] then
				if
					players[hero:GetTeamNumber()] ~= nil and hero ~= unit and hero:IsHero() and
						unit:HasModifier("modifier_player_damage")
				 then
					local target_array = players[unit:GetTeamNumber()]
					local killer_array = players[hero:GetTeamNumber()]

					local target_id = unit:GetPlayerID()
					local killer_id = hero:GetPlayerID()

					if (killer_array.damages[target_id] > 0) then
						killer_array.damages[target_id] = 0
					else
						if killer_array.damages[target_id] > -Player_damage_max then
							killer_array.damages[target_id] = killer_array.damages[target_id] - Player_damage_inc
						end
					end

					if (target_array.damages[killer_id] < 0) then
						target_array.damages[killer_id] = 0
					else
						if target_array.damages[killer_id] < Player_damage_max then
							target_array.damages[killer_id] = target_array.damages[killer_id] + Player_damage_inc
						end
					end
				end

				if players[hero:GetTeamNumber()] ~= nil and hero ~= unit and hero:IsHero() then 

					local target_array = players[unit:GetTeamNumber()]
					local killer_array = players[hero:GetTeamNumber()]

					if killer_array.hero_kills[unit:GetTeamNumber()] == nil then 
						killer_array.hero_kills[unit:GetTeamNumber()] = 0
					end

					killer_array.hero_kills[unit:GetTeamNumber()] = killer_array.hero_kills[unit:GetTeamNumber()] + 1

					if target_array then 
						target_array.hero_kills[hero:GetTeamNumber()] = 0
					end

				end


				local bonus_gold_net = PlayerResource:GetNetWorth(unit:GetPlayerID()) * kill_net_gold
				print(bonus_gold_net)

				local more_gold = bonus_gold_net

				local bonus_res = 0

				if hero:IsHero() then
					--players[unit:GetTeamNumber()].on_streak == true and
					--bonus_res = Streak_res
					--local bonus_gold =  Streak_gold
					local net_killer = PlayerResource:GetNetWorth(hero:GetPlayerID())
					local net_victim = PlayerResource:GetNetWorth(unit:GetPlayerID())

					bonus_gold = 0
					if net_victim > net_killer then
						bonus_gold = (net_victim - net_killer) * Streak_k
					end

					more_gold = more_gold + bonus_gold
				end

				if hero:IsHero() then
					hero:ModifyGold(more_gold, true, DOTA_ModifyGold_HeroKill)
					SendOverheadEventMessage(hero, 0, hero, more_gold, nil)
				end


				local mod = unit:FindModifierByName("modifier_patrol_repsawn")
 				if mod then 
 					mod:Destroy()
 					unit:SetTimeUntilRespawn(10)
 				else 
 					unit:SetTimeUntilRespawn(StartDeathTimer + my_game.current_wave*DeathTimer_PerWave)
 				end


				players[unit:GetTeamNumber()].death = players[unit:GetTeamNumber()].death + 1
			else
				unit:SetTimeUntilRespawn(5)
			end
		end
	end

	if param.entindex_attacker == nil then
		return
	end

	if
		(unit:GetTeam() == DOTA_TEAM_CUSTOM_5) and (unit:GetUnitName() == "npc_roshan_custom") and
			EntIndexToHScript(param.entindex_attacker):GetUnitName() ~= "npc_roshan_custom"
	 then
		local item = CreateItem("item_aegis", nil, nil)
		CreateItemOnPositionSync(GetGroundPosition(unit:GetAbsOrigin(), unit), item)
		if unit.number >= 1 then
			local item_2 = CreateItem("item_roshan_necro", nil, nil)
			CreateItemOnPositionSync(
				GetGroundPosition(unit:GetAbsOrigin() + RandomVector(RandomInt(-1, 1) + 100), unit),
				item_2
			)
		end
	end

	if hero.owner ~= nil then
		hero = hero.owner
	end
	if not hero:IsHero() and not hero:IsBuilding() then
		return
	end

	if
		unit:GetTeam() == DOTA_TEAM_NEUTRALS and not hero:HasModifier("modifier_final_duel") and unit.dire_patrol == nil and
			unit.radiant_patrol == nil
	 then
		local tier = 0
		local minute = math.floor(GameRules:GetDOTATime(false, false) / 60)
		if minute >= 40 then
			tier = 5
		elseif minute >= 30 then
			tier = 4
		elseif minute >= 20 then
			tier = 3
		elseif minute >= 10 then
			tier = 2
		elseif minute >= 0 then
			tier = 1
		end

		local szItemDrop = GetPotentialNeutralItemDrop(tier, hero:GetTeamNumber())
		local chance = NeutralChance - players[hero:GetTeamNumber()].NeutraItems[tier] * 3

		if my_game:IsAncientCreep(unit) then
			chance = chance * 3
		end

		local random = RollPseudoRandomPercentage(NeutralChance, 153, hero)

		if szItemDrop ~= nil and players[hero:GetTeamNumber()].NeutraItems[tier] < MaxNeutral and random then
			players[hero:GetTeamNumber()].NeutraItems[tier] = players[hero:GetTeamNumber()].NeutraItems[tier] + 1

			if hero:IsIllusion() then
				hero = hero.owner
			end

			local point = Vector(0, 0, 0)

			if hero:IsAlive() then
				point = hero:GetAbsOrigin() + hero:GetForwardVector() * 150
			else
				if towers[hero:GetTeamNumber()] ~= nil then
					point =
						towers[hero:GetTeamNumber()]:GetAbsOrigin() +
						towers[hero:GetTeamNumber()]:GetForwardVector() * 300
				end
			end

			local hItem = DropNeutralItemAtPositionForHero(szItemDrop, point, hero, tier, true)
		end
	end

	local name = nil
	local effect = nil
	local sound = nil
	local drop = true
	local owner = nil

	if (unit:GetTeam() == DOTA_TEAM_CUSTOM_5) and unit.ally and unit.ally ~= nil then
		local count_mob = 0

		for i = 1, #unit.ally do
			if not unit.ally[i]:IsNull() then
				if unit.ally[i]:IsAlive() then
					drop = false
					count_mob = count_mob + 1
				end
			end
		end

		if unit.host ~= nil and players[unit.host:GetTeamNumber()] ~= nil then
			CustomGameEventManager:Send_ServerToPlayer(
				PlayerResource:GetPlayer(players[unit.host:GetTeamNumber()]:GetPlayerID()),
				"timer_progress",
				{
					units = count_mob,
					units_max = unit.max,
					time = -1,
					max = -1,
					name = my_game:GetWave(unit.wave_number, unit.isboss),
					skills = my_game:GetSkills(unit.wave_number, unit.isboss),
					mkb = my_game:GetMkb(unit.wave_number, unit.isboss),
					reward = unit.reward,
					gold = unit.givegold,
					number = my_game.current_wave,
					hide = false
				}
			)
		end

		if drop then
			if unit.lownet == 1 then
				if not players[unit.host:GetTeamNumber()]:IsAlive() then
					players[unit.host:GetTeamNumber()].give_lownet = 1
				else
					players[unit.host:GetTeamNumber()]:AddNewModifier(
						players[unit.host:GetTeamNumber()],
						nil,
						"modifier_lownet_choose",
						{}
					)
				end
			end

			if unit.host ~= nil and players[unit.host:GetTeamNumber()] ~= nil then
				players[unit.host:GetTeamNumber()].ActiveWave = nil
			end

			if not hero:IsBuilding() or unit.drop == "item_legendary_upgrade" or (unit.drop == "item_purple_upgrade") then
				name = unit.drop
				effect = unit.effect
				sound = unit.sound

				if unit.drop == "item_legendary_upgrade" or unit.drop == "item_purple_upgrade" then
					owner = unit.owner
				end

				local distance = (hero:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D()
				if distance > 1500 then
					owner = unit.owner
				end
			end
		end
	end

	if
		(unit:GetTeam() == DOTA_TEAM_NEUTRALS or unit:IsBuilding()) and not hero:IsBuilding() and
			not hero:HasModifier("modifier_final_duel")
	 then
		if my_game:BluePoints(unit) ~= nil then
			local k = 1

			if players[hero:GetTeamNumber()]:HasModifier("modifier_up_bluepoints") then
				k = k + 0.2
			end

			if players[hero:GetTeamNumber()]:HasModifier("modifier_lownet_blue_buff") then
				--k = k + lownet_blue
			end

			local points = my_game:BluePoints(unit)

			if players[hero:GetTeamNumber()]:HasModifier("modifier_alchemist_greed_2") then
				local ability = players[hero:GetTeamNumber()]:FindAbilityByName("alchemist_goblins_greed_custom")
				points =
					points + ability.blue[players[hero:GetTeamNumber()]:GetUpgradeStack("modifier_alchemist_greed_2")]
			end

			players[hero:GetTeamNumber()].bluepoints = players[hero:GetTeamNumber()].bluepoints + points * k

			if players[hero:GetTeamNumber()].bluepoints >= players[hero:GetTeamNumber()].bluemax then
				CustomGameEventManager:Send_ServerToPlayer(
					PlayerResource:GetPlayer(hero:GetPlayerID()),
					"kill_progress",
					{
						blue = players[hero:GetTeamNumber()].bluemax,
						purple = players[hero:GetTeamNumber()].purplepoints,
						max = players[hero:GetTeamNumber()].bluemax,
						max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
					}
				)

				Timers:CreateTimer(
					0.5,
					function()
						CustomGameEventManager:Send_ServerToPlayer(
							PlayerResource:GetPlayer(hero:GetPlayerID()),
							"kill_progress",
							{
								blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
								purple = players[hero:GetTeamNumber()].purplepoints,
								max = players[hero:GetTeamNumber()].bluemax,
								max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
							}
						)
					end
				)

				players[hero:GetTeamNumber()].bluepoints =
					players[hero:GetTeamNumber()].bluepoints - players[hero:GetTeamNumber()].bluemax
				players[hero:GetTeamNumber()].bluemax = players[hero:GetTeamNumber()].bluemax + PlusBlue
				name = "item_blue_upgrade"
				effect = "particles/blue_drop.vpcf"
				sound = "powerup_03"
			else
				CustomGameEventManager:Send_ServerToPlayer(
					PlayerResource:GetPlayer(hero:GetPlayerID()),
					"kill_progress",
					{
						blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
						purple = players[hero:GetTeamNumber()].purplepoints,
						max = players[hero:GetTeamNumber()].bluemax,
						max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
					}
				)
			end
		end
	end

	if hero:IsBuilding() then
		hero = players[hero:GetTeamNumber()]
	end

	local no_purple_for_hero = false
	if players[unit:GetTeamNumber()] ~= nil and players[hero:GetTeamNumber()] ~= nil and GameRules:GetDOTATime(false, false) < Player_damage_time then 
		if players[hero:GetTeamNumber()].hero_kills and 
			( players[hero:GetTeamNumber()].hero_kills[unit:GetTeamNumber()] and players[hero:GetTeamNumber()].hero_kills[unit:GetTeamNumber()] > 3) then 
			no_purple_for_hero = true
		end
	end

	if (unit:GetUnitName() == "npc_towerdire" or unit:GetUnitName() == "npc_towerradiant") then

		name = "item_purple_upgrade"
		effect = "particles/purple_drop.vpcf"
		sound = "powerup_05"


	 	local tower_count = 0
	 	local p = FindUnitsInRadius(DOTA_TEAM_NOTEAM,Vector(0, 0, 0),nil,FIND_UNITS_EVERYWHERE,DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_BUILDING,DOTA_UNIT_TARGET_FLAG_INVULNERABLE,0,false)

	 	for _,tower1 in pairs(p) do 
	 		if tower1:GetUnitName() == "npc_towerdire" or tower1:GetUnitName() == "npc_towerradiant" then 
	 			tower_count = tower_count + 1
	 		end
	 	end

	 	if tower_count == 2 then 
	 		hero:AddNewModifier(hero, nil, "modifier_duel_damage_final", {})
	 	end
	end


	if
		((unit:IsRealHero() and
			((players[unit:GetTeamNumber()] ~= nil and players[unit:GetTeamNumber()].no_purple == false) or test)) or
			unit:GetUnitName() == "npc_roshan_custom") and
			no_purple_for_hero == false and 
			hero:GetTeamNumber() ~= unit:GetTeamNumber() and
			not unit:HasModifier("modifier_final_duel") and
			unit:IsReincarnating() == false
	 then


	 	

		players[hero:GetTeamNumber()].purplepoints = players[hero:GetTeamNumber()].purplepoints + 1

		if players[hero:GetTeamNumber()]:HasModifier("modifier_lownet_purple_buff") then
			players[hero:GetTeamNumber()].purplepoints = players[hero:GetTeamNumber()].purplepoints + lownet_purple
			players[hero:GetTeamNumber()]:RemoveModifierByName("modifier_lownet_purple_buff")
		end

		if players[hero:GetTeamNumber()].purplepoints >= math.floor(players[hero:GetTeamNumber()].purplemax) then
			CustomGameEventManager:Send_ServerToPlayer(
				PlayerResource:GetPlayer(hero:GetPlayerID()),
				"kill_progress",
				{
					blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
					purple = math.floor(players[hero:GetTeamNumber()].purplemax),
					max = players[hero:GetTeamNumber()].bluemax,
					max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
				}
			)

			Timers:CreateTimer(
				0.5,
				function()
					CustomGameEventManager:Send_ServerToPlayer(
						PlayerResource:GetPlayer(hero:GetPlayerID()),
						"kill_progress",
						{
							blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
							purple = players[hero:GetTeamNumber()].purplepoints,
							max = players[hero:GetTeamNumber()].bluemax,
							max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
						}
					)
				end
			)

			players[hero:GetTeamNumber()].purplepoints =
				players[hero:GetTeamNumber()].purplepoints - math.floor(players[hero:GetTeamNumber()].purplemax)
			players[hero:GetTeamNumber()].purplemax = players[hero:GetTeamNumber()].purplemax + PlusPurple

			name = "item_purple_upgrade"
			effect = "particles/purple_drop.vpcf"
			sound = "powerup_05"
		else
			CustomGameEventManager:Send_ServerToPlayer(
				PlayerResource:GetPlayer(hero:GetPlayerID()),
				"kill_progress",
				{
					blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
					purple = players[hero:GetTeamNumber()].purplepoints,
					max = players[hero:GetTeamNumber()].bluemax,
					max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
				}
			)
		end
	end

	if name ~= nil and players[hero:GetTeamNumber()] ~= nil then
		if name == "item_purple_upgrade" then
			players[hero:GetTeamNumber()].purple = players[hero:GetTeamNumber()].purple + 1
		end

		if hero:IsIllusion() then
			hero = hero.owner
		end

		if owner ~= nil then
			hero = owner
		end

		local item = CreateItem(name, hero, hero)

		item_effect = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)

		local point = Vector(0, 0, 0)

		if hero:IsAlive() then
			point = hero:GetAbsOrigin() + hero:GetForwardVector() * 150
		else
			if towers[hero:GetTeamNumber()] ~= nil then
				point =
					towers[hero:GetTeamNumber()]:GetAbsOrigin() + towers[hero:GetTeamNumber()]:GetForwardVector() * 300
			end
		end

		ParticleManager:SetParticleControl(item_effect, 0, point)

		EmitSoundOnEntityForPlayer(sound, hero, hero:GetPlayerOwnerID())

		item.after_legen = After_Lich

		Timers:CreateTimer(
			0.8,
			function()
				CreateItemOnPositionSync(GetGroundPosition(point, unit), item)
			end
		)
	end
end

function my_game:GetRarityName(rare)
	if rare == 1 then
		return "gray"
	end
	if rare == 2 then
		return "blue"
	end
	if rare == 3 then
		return "purple"
	end
	if rare == 4 then
		return "orange"
	end
	return nil
end

function my_game:CheckSkill(player, number, rare)
	local rarity = my_game:GetRarityName(rare)

	for _, group_name in pairs({player:GetUnitName(), "all"}) do
		for _, data in pairs(skills[group_name]) do
			if data[8] == number and data[3] == rarity then
				local mod = player:FindModifierByName(data[1])
				if mod == nil or mod:GetStackCount() < data[4] then
					return true
				end
			end
		end
	end
	return false
end

function my_game:RandomCheck(i, array)
	local f = true

	if array ~= nil then
		for j = 1, #array do
			if array[j] == i then
				return false
			end
		end
	end

	return true
end

function my_game:SortSkill(rare, player, after_legen)
	local sort = {}
	local j = 0
	local f = false
	local start = 1

	if
		players[player:GetTeamNumber()].chosen_skill ~= 0 and (after_legen == true or test == true) and
			(my_game:RandomCheck(
				players[player:GetTeamNumber()].chosen_skill,
				players[player:GetTeamNumber()].ban_skills
			))
	 then
		sort[1] = players[player:GetTeamNumber()].chosen_skill
		start = 2
	end

	for i = start, 2 do
		repeat
			j = RandomInt(1, 4)
			f = true
			for c = 1, 2 do
				if sort[c] == j and #players[player:GetTeamNumber()].ban_skills < 3 then
					f = false
					break
				end
			end
			if not my_game:RandomCheck(j, players[player:GetTeamNumber()].ban_skills) then
				f = false
			end
		until f == true

		sort[i] = j
	end

	return sort
end

_G.skill_number = {}

function check_type(player, types, rarity)
	if type(types) == "string" then
		return types == rarity
	end

	local matches_rarity = false
	local matches_type = false
	for i = 1, #players[player:GetTeamNumber()].HeroType do
		for _, type_s in pairs(types) do
			if type_s == rarity then
				matches_rarity = true
			end
			if players[player:GetTeamNumber()].HeroType[i] == type_s then
				matches_type = true
			end
		end
	end

	return matches_rarity and matches_type
end

function find_skill(player, rare, skill, bans)
	if bans == nil then
		bans = {}
		for i, name in ipairs(players[player:GetTeamNumber()].choise) do
			bans[i] = name
		end
	end
	local buffer = {}
	local rarity = my_game:GetRarityName(rare)

	for _, group_name in pairs({player:GetUnitName(), "all"}) do
		for _, data in pairs(skills[group_name]) do
			local banned = false
			for j = 1, #bans do
				if data[1] == bans[j] then
					banned = true
				end
			end
			if not banned then
				local mod = nil
				if data[2] == 2 then
					mod = towers[player:GetTeamNumber()]:FindModifierByName(data[1])
				else
					mod = player:FindModifierByName(data[1])
				end
	
				local stacks = 0
				if mod ~= nil then
					stacks = mod:GetStackCount()
				end

				if
					(rare == 1 or data[8] == skill or skill == 5)
					and check_type(player, data[3], rarity)
					and (stacks < data[4] or data[4] == 0)
				then
					table.insert(buffer, data[1])
					table.insert(bans, data[1])
				end
			end
		end
	end

	if #buffer == 0 then
		return find_skill(player, rare - 1, skill, bans)
	end

	return buffer[RandomInt(1, #buffer)]
end

function find_legendary(player)
	players[player:GetTeamNumber()].choise = {}

	for _, data in pairs(skills[player:GetUnitName()]) do
		if data[3] == "orange" then
			local mod = player:FindModifierByName(data[1])
			if not mod then
				table.insert(players[player:GetTeamNumber()].choise, data[1])
			end
		end
	end
end

LinkLuaModifier("using_item", "upgrade/item_upgrade", LUA_MODIFIER_MOTION_NONE)

function upgrade:init_upgrade(player, rarity, can_refresh, after_legen)
	if not test then
		players[player:GetTeamNumber()].IsChoosing = true
	end
	players[player:GetTeamNumber()].choise = {}

	if rarity ~= 10 then
		if rarity == 4 then
			find_legendary(player)

			local alert = 0
			if players[player:GetTeamNumber()].chosen_skill == 0 then
				alert = 1
			end

			CustomGameEventManager:Send_ServerToPlayer(
				PlayerResource:GetPlayer(player:GetPlayerID()),
				"show_choise",
				{
					choise = players[player:GetTeamNumber()].choise,
					mods = {},
					hasup = players[player:GetTeamNumber()]:HasModifier("modifier_up_graypoints"),
					alert = alert
				}
			)

			players[player:GetTeamNumber()].choise_table = {
				players[player:GetTeamNumber()].choise,
				alert,
				false,
				{},
				false
			}

			return
		elseif rarity == 1 then
			players[player:GetTeamNumber()].choise[1] = find_skill(player, rarity, 5)
			players[player:GetTeamNumber()].choise[2] = find_skill(player, rarity, 5)
			players[player:GetTeamNumber()].choise[3] = find_skill(player, rarity, 5)
		else
			local j = 0
			players[player:GetTeamNumber()].ban_skills = {}
			for i = 1, 4 do
				if not my_game:CheckSkill(player, i, rarity) then
					j = j + 1
					players[player:GetTeamNumber()].ban_skills[j] = i
				end
			end

			if j == 4 then
				if rarity == 2 then
					players[player:GetTeamNumber()].choise[1] = find_skill(player, 1, 5)
					players[player:GetTeamNumber()].choise[2] = find_skill(player, 1, 5)
				else
					local t = 0
					players[player:GetTeamNumber()].ban_skills = {}
					for i = 1, 4 do
						if not my_game:CheckSkill(player, i, rarity - 1) then
							t = t + 1
							players[player:GetTeamNumber()].ban_skills[t] = i
						end
					end

					if t == 4 then
						players[player:GetTeamNumber()].choise[1] = find_skill(player, 1, 5)
						players[player:GetTeamNumber()].choise[2] = find_skill(player, 1, 5)
					else
						local skill_number = my_game:SortSkill(rarity - 1, player, after_legen)
						players[player:GetTeamNumber()].choise[1] = find_skill(player, rarity - 1, skill_number[1])
						players[player:GetTeamNumber()].choise[2] = find_skill(player, rarity - 1, skill_number[2])
					end
				end
			else
				local skill_number = my_game:SortSkill(rarity, player, after_legen)
				players[player:GetTeamNumber()].choise[1] = find_skill(player, rarity, skill_number[1])
				players[player:GetTeamNumber()].choise[2] = find_skill(player, rarity, skill_number[2])
			end

			skill_number[3] = 0
			players[player:GetTeamNumber()].choise[3] = find_skill(player, rarity, skill_number[3])
		end
	else
		players[player:GetTeamNumber()].choise = {
			"modifier_lownet_gold",
			"modifier_lownet_blue",
			"modifier_lownet_purple",
		}
	end


	if rarity == 1 and player:HasModifier("modifier_up_grayfour") then
		players[player:GetTeamNumber()].choise[4] = find_skill(player, 1, 5)
	end

	local refresh = false

	if can_refresh == nil then
		if rarity == 3 and player:HasModifier("modifier_up_purplepoints") then
			refresh = true
		end
	end

	local mod_stacks = {}
	for i = 1, #players[player:GetTeamNumber()].choise do
		mod_stacks[i] = 0
		local name = players[player:GetTeamNumber()].choise[i]

		local b = player:FindModifierByName(name) or towers[player:GetTeamNumber()]:FindModifierByName(name)
		if b then
			mod_stacks[i] = b:GetStackCount()
		end
	end

	players[player:GetTeamNumber()].can_refresh_choise = refresh

	CustomGameEventManager:Send_ServerToPlayer(
		PlayerResource:GetPlayer(player:GetPlayerID()),
		"show_choise",
		{
			choise = players[player:GetTeamNumber()].choise,
			mods = mod_stacks,
			legendary = l,
			hasup = players[player:GetTeamNumber()]:HasModifier("modifier_up_graypoints"),
			refresh = refresh
		}
	)

	players[player:GetTeamNumber()].choise_table = {
		players[player:GetTeamNumber()].choise,
		false,
		players[player:GetTeamNumber()]:HasModifier("modifier_up_graypoints"),
		mod_stacks,
		refresh
	}

	mod_stacks = {}
end

function upgrade:make_choise(kv)
	if kv.PlayerID == nil then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity(kv.PlayerID)

	if hero == nil then
		return
	end

	if players[hero:GetTeamNumber()] == nil then
		return
	end

	if #players[hero:GetTeamNumber()].choise == 0 then
		return
	end

	players[hero:GetTeamNumber()].IsChoosing = false
	players[hero:GetTeamNumber()].choise_table = {}
	players[hero:GetTeamNumber()].can_refresh_choise = false

	local skill_name = players[hero:GetTeamNumber()].choise[kv.chosen]
	if skill_name == nil then
		return
	end

	local skill_data = nil
	for _, group_name in pairs({hero:GetUnitName(), "all", "lowest"}) do
		local skills_group = skills[group_name]
		for _, data in ipairs(skills_group) do
			if data[1] == skill_name then
				skill_data = data
				break
			end
		end
	end
	if skill_data == nil then
		return
	end


	if (skill_data[3] == "orange") and (players[hero:GetTeamNumber()].chosen_skill == 0) then
		players[hero:GetTeamNumber()].chosen_skill = skill_data[9]
	end

	if skill_data[3] == "orange" or skill_data[3] == "purple" then
		CustomGameEventManager:Send_ServerToAllClients("show_skill_event", {hero = hero:GetUnitName(), skill = skill_name})
	end

	local mod = hero:FindModifierByName("using_item")
	if mod then
		mod:Destroy()
	end

	if skill_data[2] ~= 2 then
		if hero:IsAlive() then
			local mod = hero:AddNewModifier(hero, nil, skill_name, {})
			if mod then
				mod.IsUpgrade = true
				mod.IsOrangeTalent = skill_data[3] == "orange"
				mod.TalentTree = skill_data[6]
			end
		else
			players[hero:GetTeamNumber()].respawn_mod = skill_name
		end
		players[hero:GetTeamNumber()].upgrades[skill_name] = hero:FindModifierByName(skill_name):GetStackCount()
	else
		towers[hero:GetTeamNumber()]:AddNewModifier(hero, nil, skill_name, {})
	end

	CustomNetTables:SetTableValue(
		"upgrades_player",
		hero:GetUnitName(),
		{
			upgrades = players[hero:GetTeamNumber()].upgrades,
			hasup = hero:HasModifier("modifier_up_graypoints")
		}
	)

	players[hero:GetTeamNumber()].choise = {}
end

function upgrade:refresh_sphere(kv)
	if kv.PlayerID == nil then
		return
	end
	local hero = PlayerResource:GetSelectedHeroEntity(kv.PlayerID)

	if players[hero:GetTeamNumber()] == nil then
		return
	end
	if #players[hero:GetTeamNumber()].choise == 0 then
		return
	end

	if not players[hero:GetTeamNumber()].can_refresh_choise then
		return
	end

	players[hero:GetTeamNumber()].can_refresh_choise = false

	players[hero:GetTeamNumber()].choise = {}

	upgrade:init_upgrade(hero, 3, false, true)
end
