require("events_protector")

hero_select = class({})

PICK_STATE_PLAYERS_LOADED = "PICK_STATE_PLAYERS_LOADED"
PICK_STATE_PICK_BANNED = "PICK_STATE_PICK_BANNED"
PICK_STATE_SELECT_HERO = "PICK_STATE_SELECT_HERO"
PICK_STATE_SELECT_BASE = "PICK_STATE_SELECT_BASE"
PICK_STATE_PICK_END = "PICK_STATE_PICK_END"
PICK_STATE = PICK_STATE_PLAYERS_LOADED
BAN_TIME = 15
TIME_OF_STATE = {5, 75, 60, 0}
LOBBY_PLAYERS = {}
LOBBY_PLAYERS_MAX = 0
HEROES_FOR_PICK = {}
BASE_FOR_PICK = {2, 7, 6, 3, 8, 9}
PICKED_HEROES = {}
PICKED_BASES = {}
PICK_ORDER = 0
_G.IN_STATE = false
BAN_HEROES_VOTE = {}
_G.BANNED_HEROES = {}

NO_BANNED_HEROES = {}

BASE_POSITION = {
    Vector(-5621.416016, -5693.873047, 343),
    Vector(1569.812500, -6398.656250, 343),
    Vector(-6276.908203, 1465.867554, 343),
    Vector(5030.81, 5390.27, 343),
    Vector(-1303.977173, 6414.658691, 343),
    Vector(6515.981445, -1486.434570, 343)
}

_G.COUR_POSITION = {
    Vector(-4745.94, -5358.05, 343),
    Vector(618.509, -6416.23, 343),
    Vector(-6310.89, 539.332, 343),
    Vector(5030.584961, 5390.719727, 343),
    Vector(-320.739, 6446.09, 343),
    Vector(6556.74, -467.617, 343)
}

function hero_select:RandomHero()
    local hero
    repeat
        local random = RandomInt(1, #HEROES_FOR_PICK)
        hero = HEROES_FOR_PICK[random]
    until not my_game:check_used(PICKED_HEROES, hero)

    return hero
end

function hero_select:RandomBase()
    local base
    repeat
        base = RandomInt(1, #BASE_FOR_PICK)
    until not my_game:check_used(PICKED_BASES, base)

    return base
end

function hero_select:PickBase(id, number)
    local player_info = LOBBY_PLAYERS[id]

    player_info.select_base = number

    table.insert(PICKED_BASES, number)

    CustomNetTables:SetTableValue(
        "custom_pick",
        "base_list",
        {
            picked_bases = PICKED_BASES,
            picked_bases_length = #PICKED_BASES
        }
    )

    CustomGameEventManager:Send_ServerToAllClients(
        "pick_select_base",
        {number = number, hero = player_info.picked_hero}
    )

    local wisp = PlayerResource:GetSelectedHeroEntity(id)
    if wisp ~= nil then
        local position = BASE_POSITION[number]

        wisp:SetAbsOrigin(position)
        FindClearSpaceForUnit(wisp, position, true)
        wisp:SetRespawnPosition(position)

        local team = wisp:GetTeamNumber()
        local spawner = Entities:FindByName(nil, "spawn" .. team)
        if spawner ~= nil then
            spawner:SetAbsOrigin(position)
        end

        local towers =
            FindUnitsInRadius(
            team,
            position,
            nil,
            3000,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
            0,
            false
        )

        for _, tower in ipairs(towers) do
            if tower:IsBuilding() or tower:GetUnitName() == "npc_teleport" then
                tower:SetTeam(team)
            end
        end
    end

    hero_select:check_picked_bases()
end

function hero_select:ChoseBase(params)
    if params.PlayerID == nil then
        return
    end
    if not params.number then
        return
    end
    if PICK_STATE ~= PICK_STATE_SELECT_BASE then
        return
    end

    local player_info = LOBBY_PLAYERS[params.PlayerID]

    if player_info.select_base ~= nil or hero_select:check_picked_base_number(params.number) then
        return
    end

    hero_select:PickBase(params.PlayerID, params.number)
end

function hero_select:PickHero(id, name, random)
    local player_info = LOBBY_PLAYERS[id]

    player_info.picked_hero = name

    table.insert(PICKED_HEROES, name)

    CustomNetTables:SetTableValue(
        "custom_pick",
        "player_list",
        {
            picked_heroes = PICKED_HEROES,
            picked_heroes_length = #PICKED_HEROES
        }
    )

    CustomGameEventManager:Send_ServerToAllClients("pick_select_hero", {hero = name, id = id, random = random})

    local wisp = PlayerResource:GetSelectedHeroEntity(id)
    if wisp then
        SelectedHeroes[id] = name

        CustomNetTables:SetTableValue("players_heroes", tostring(id), {hero = name})

        local hero = PlayerResource:ReplaceHeroWith(id, name, wisp:GetGold(), 0)
        PlayerResource:SetCameraTarget(id, nil)
        UTIL_Remove(wisp)
        my_game:initiate_player(hero, Pause_Time)
    end

    hero_select:check_picked_players()
end

function hero_select:ChoseHero(params)
    if params.PlayerID == nil then
        return
    end
    if not params.hero then
        return
    end
    if PICK_STATE ~= PICK_STATE_SELECT_HERO then
        return
    end

    local player_info = LOBBY_PLAYERS[params.PlayerID]

    if params.random then
        local random_hero = hero_select:RandomHero()

        LOBBY_PLAYERS[params.PlayerID].randomed = true

        if player_info.picked_hero ~= nil or hero_select:check_picked(random_hero) then
            return
        end
        hero_select:PickHero(params.PlayerID, random_hero, 1)
        return
    end

    if player_info.picked_hero ~= nil or hero_select:check_picked(params.hero) then
        return
    end

    LOBBY_PLAYERS[params.PlayerID].randomed = false
    hero_select:PickHero(params.PlayerID, params.hero, 0)
end

function hero_select:EndPickHeroes()
    CustomNetTables:SetTableValue(
        "custom_pick",
        "player_lobby",
        {
            lobby_players = LOBBY_PLAYERS,
            lobby_players_length = LOBBY_PLAYERS_MAX
        }
    )

    CustomGameEventManager:Send_ServerToAllClients("start_base_pick", {})
    PICK_STATE = PICK_STATE_SELECT_BASE
    hero_select:StartOrderPickBase()
end

function hero_select:EndPick()
    CustomGameEventManager:Send_ServerToAllClients("pick_base_end", {})
    PICK_STATE = PICK_STATE_PICK_END
    _G.IN_STATE = false

    Timers:CreateTimer(
        "",
        {
            useGameTime = false,
            endTime = 1,
            callback = function()
                CustomNetTables:SetTableValue(
                    "custom_pick",
                    "pick_state",
                    {
                        in_progress = false
                    }
                )

                my_game:start_game()
            end
        }
    )
end

function hero_select:check_banned_players()
    for _, i in pairs(LOBBY_PLAYERS) do
        if i.ban_hero == nil then
            return false
        end
    end

    CustomGameEventManager:Send_ServerToAllClients("EndBanStage", {no_ban_hero = NO_BANNED_HEROES})
    CustomNetTables:SetTableValue("custom_pick", "ban_stage_check", {state = false})
    hero_select:BanHero()
    hero_select:StartSelectionStage()
end
function hero_select:check_picked_players()
    for _, i in pairs(LOBBY_PLAYERS) do
        if i.picked_hero == nil then
            return false
        end
    end

    hero_select:EndPickHeroes()
end

function hero_select:check_picked_bases()
    for _, i in pairs(LOBBY_PLAYERS) do
        if i.select_base == nil then
            return false
        end
    end
    hero_select:EndPick()
end

function hero_select:check_picked(hero)
    for _, i in pairs(BANNED_HEROES) do
        if i == hero then
            return true
        end
    end

    for _, i in pairs(PICKED_HEROES) do
        if i == hero then
            return true
        end
    end

    return false
end

function hero_select:check_picked_base_number(number)
    for _, i in pairs(PICKED_BASES) do
        if i == number then
            return true
        end
    end
    return false
end

function hero_select:RegisterPlayerInfo(pid)
    if PlayerResource:GetSteamAccountID(pid) == 0 then
        return
    end

    local pinfo = LOBBY_PLAYERS[pid]
    if pinfo == nil then
        pinfo = {
            bRegistred = false,
            bLoaded = false,
            steamid = PlayerResource:GetSteamAccountID(pid),
            picked_hero = nil,
            select_base = nil,
            pick_order = nil,
            ban_hero = nil
        }
        LOBBY_PLAYERS_MAX = LOBBY_PLAYERS_MAX + 1
    end

    LOBBY_PLAYERS[pid] = pinfo

    return pinfo
end

function hero_select:CheckReadyPlayers(attempt)
    if PICK_STATE ~= PICK_STATE_PLAYERS_LOADED then
        return
    end

    local bAllReady = true
    for pid, pinfo in pairs(LOBBY_PLAYERS) do
        if pinfo.bRegistred and not pinfo.bLoaded then
            bAllReady = false
        end
    end

    if bAllReady then
        hero_select:Start()
    else
        local check_interval = 0.5
        attempt = (attempt or 0) + check_interval
        if attempt > TIME_OF_STATE[1] then
            hero_select:Start()
        else
            Timers:CreateTimer(
                "",
                {
                    useGameTime = false,
                    endTime = check_interval,
                    callback = function()
                        hero_select:CheckReadyPlayers(attempt)
                    end
                }
            )
        end
    end
end

function hero_select:PlayerConnected(kv)
	if kv.PlayerID == nil then
		return
	end
    local pinfo = hero_select:RegisterPlayerInfo(kv.PlayerID)
    pinfo.bRegistred = true
end

function hero_select:PlayerLoaded(player, pid)
    if not LOBBY_PLAYERS[pid] then
        CustomGameEventManager:Send_ServerToPlayer(player, "pick_end", {})
        return
    end

    LOBBY_PLAYERS[pid].bLoaded = true

    local team = PlayerResource:GetTeam(pid)
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    if hero ~= nil then
        hero:SetOwner(player)
        hero:SetControllableByPlayer(pid, true)
        player:SetAssignedHeroEntity(hero)
    end

    if not IN_STATE then
        CustomGameEventManager:Send_ServerToPlayer(player, "pick_end", {})

        Timers:CreateTimer(
            1.5,
            function()
                local player = PlayerResource:GetPlayer(pid)
                if player == nil then
                    return
                end
                CustomGameEventManager:Send_ServerToPlayer(
                    player,
                    "init_chat",
                    {tools = IsInToolsMode(), cheat = GameRules:IsCheatMode(), valid = Http:IsValidGame(PlayerCount)}
                )

                if hero == nil then
                    return
                end
                if players[hero:GetTeamNumber()] == nil then
                    return
                end

                for _, mod in pairs(hero:FindAllModifiers()) do
                    if mod.ActiveTalent and mod.ActiveTalent == true then
                        hero:AddNewModifier(hero, nil, mod:GetName(), {})
                    end
                end

                CustomGameEventManager:Send_ServerToPlayer(
                    player,
                    "kill_progress",
                    {
                        blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
                        purple = players[hero:GetTeamNumber()].purplepoints,
                        max = players[hero:GetTeamNumber()].bluemax,
                        max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
                    }
                )

                if players[hero:GetTeamNumber()].IsChoosing == true then
                    CustomGameEventManager:Send_ServerToPlayer(
                        player,
                        "show_choise",
                        {
                            choise = players[hero:GetTeamNumber()].choise_table[1],
                            mods = players[hero:GetTeamNumber()].choise_table[4],
                            hasup = players[hero:GetTeamNumber()].choise_table[3],
                            alert = players[hero:GetTeamNumber()].choise_table[2],
                            refresh = players[hero:GetTeamNumber()].choise_table[5]
                        }
                    )
                end
            end
        )

        return
    end

    if PICK_STATE ~= PICK_STATE_PLAYERS_LOADED then
        hero_select:DrawPickScreenForPlayer(pid)

        if PICK_STATE == PICK_STATE_PICK_BANNED then
            CustomGameEventManager:Send_ServerToPlayer(
                player,
                "reload_pick_heroes",
                {
                    lobby_players = LOBBY_PLAYERS
                }
            )

            for _, banned_hero in pairs(BAN_HEROES_VOTE) do
                CustomGameEventManager:Send_ServerToPlayer(
                    player,
                    "ban_hero_vote",
                    {hero = banned_hero.name, votes = banned_hero.votes}
                )
            end
        elseif PICK_STATE == PICK_STATE_SELECT_HERO then
            CustomGameEventManager:Send_ServerToPlayer(
                player,
                "reload_pick_heroes",
                {
                    lobby_players = LOBBY_PLAYERS
                }
            )
            for _, banned_hero in pairs(BAN_HEROES_VOTE) do
                CustomGameEventManager:Send_ServerToPlayer(
                    player,
                    "ban_hero_vote",
                    {hero = banned_hero.name, votes = banned_hero.votes}
                )
            end
            for _, banned_hero in pairs(BANNED_HEROES) do
                CustomGameEventManager:Send_ServerToPlayer(player, "ban_hero", {hero = banned_hero})
            end
        elseif PICK_STATE == PICK_STATE_SELECT_BASE then
            for current, pinfo in pairs(LOBBY_PLAYERS) do
                if pinfo.pick_order == PICK_ORDER then
                    CustomGameEventManager:Send_ServerToPlayer(
                        PlayerResource:GetPlayer(pid),
                        "pick_start_time_base",
                        {
                            order = PICK_ORDER,
                            max = LOBBY_PLAYERS_MAX,
                            id = current,
                            time = -1,
                            picked_bases = PICKED_BASES,
                            picked_bases_length = #PICKED_BASES
                        }
                    )
                    break
                end
            end

            CustomGameEventManager:Send_ServerToPlayer(
                player,
                "reload_pick_bases",
                {
                    lobby_players = LOBBY_PLAYERS
                }
            )
        elseif PICK_STATE == PICK_STATE_PICK_END then
            CustomGameEventManager:Send_ServerToPlayer(player, "pick_end", {})
        end
    end
end

function hero_select:Start()
    local r = 0
    local used_numbers = {}

     --LOBBY_PLAYERS[1] = {bRegistred = true,bLoaded = true,steamid = 1243124,picked_hero = nil,select_base = nil,pick_order = nil}
    -- LOBBY_PLAYERS[2] = {bRegistred = true,bLoaded = true,steamid = 12431224,picked_hero = nil,select_base = nil,pick_order = nil}
   --  LOBBY_PLAYERS[3] = {bRegistred = true,bLoaded = true,steamid = 124354124,picked_hero = nil,select_base = nil,pick_order = nil}
    -- LOBBY_PLAYERS[4] = {bRegistred = true,bLoaded = true,steamid = 12434124,picked_hero = nil,select_base = nil,pick_order = nil}

    for i, player in pairs(LOBBY_PLAYERS) do
        repeat
            r = RandomInt(0, LOBBY_PLAYERS_MAX - 1)
        until not my_game:check_used(used_numbers, r)
        used_numbers[#used_numbers + 1] = r
        player.pick_order = r
    end

    local place_admin = 0
    local place_normal = 1

    if LOBBY_PLAYERS_MAX > 1 then
        for i, player in pairs(LOBBY_PLAYERS) do
            if LOBBY_PLAYERS[i].pick_order == 0 then
                place_normal = i
            end
        end

        for i, player in pairs(LOBBY_PLAYERS) do
            if LOBBY_PLAYERS[i].steamid == 232290025 then
                place_admin = LOBBY_PLAYERS[i].pick_order

                LOBBY_PLAYERS[i].pick_order = 0
                LOBBY_PLAYERS[place_normal].pick_order = place_admin
                break
            end
        end
    end

    CustomNetTables:SetTableValue(
        "custom_pick",
        "player_lobby",
        {
            lobby_players = LOBBY_PLAYERS,
            lobby_players_length = LOBBY_PLAYERS_MAX
        }
    )

    for pid, pinfo in pairs(LOBBY_PLAYERS) do
        if pinfo.bLoaded then
            hero_select:DrawPickScreenForPlayer(pid)
        end
    end

    --hero_select:StartSelectionStage()
    hero_select:StartBanStage()
end

function hero_select:StartBanStage()
    PICK_STATE = PICK_STATE_PICK_BANNED
    local time_ban_stage = BAN_TIME
    CustomGameEventManager:Send_ServerToAllClients(
        "StartBanStage",
        {time = time_ban_stage, no_ban_hero = NO_BANNED_HEROES}
    )
    CustomNetTables:SetTableValue("custom_pick", "ban_stage_check", {state = true})
    Timers:CreateTimer(
        "",
        {
            useGameTime = false,
            endTime = 1,
            callback = function()
                time_ban_stage = time_ban_stage - 1
                CustomGameEventManager:Send_ServerToAllClients(
                    "TimeBanStage",
                    {time = time_ban_stage, no_ban_hero = NO_BANNED_HEROES}
                )
                if time_ban_stage <= 0 then
                    CustomGameEventManager:Send_ServerToAllClients("EndBanStage", {no_ban_hero = NO_BANNED_HEROES})
                    CustomNetTables:SetTableValue("custom_pick", "ban_stage_check", {state = false})
                    hero_select:BanHero()
                    hero_select:StartSelectionStage()
                    return
                end
                return 1
            end
        }
    )
end

function hero_select:BanHero()
    table.sort(
        BAN_HEROES_VOTE,
        function(x, y)
            return y.votes < x.votes
        end
    )
    if BAN_HEROES_VOTE[1] then
        table.insert(BANNED_HEROES, BAN_HEROES_VOTE[1].name)

        for id, hero in pairs(HEROES_FOR_PICK) do
            if hero == BAN_HEROES_VOTE[1].name then
                table.remove(HEROES_FOR_PICK, id)
                break
            end
        end

        CustomGameEventManager:Send_ServerToAllClients(
            "ban_hero",
            {hero = BAN_HEROES_VOTE[1].name, table_votes = BAN_HEROES_VOTE}
        )
    end
end

function hero_select:BanVoteHero(params)
    if params.PlayerID == nil then
        return
    end
    if LOBBY_PLAYERS[params.PlayerID].ban_hero == nil then
        for _, no_ban_hero in pairs(NO_BANNED_HEROES) do
            if no_ban_hero == params.hero then
                return
            end
        end
        LOBBY_PLAYERS[params.PlayerID].ban_hero = params.hero
        local find_banned = false
        for _, banned_hero in pairs(BAN_HEROES_VOTE) do
            if banned_hero.name == params.hero then
                banned_hero.votes = banned_hero.votes + 1
                CustomGameEventManager:Send_ServerToAllClients(
                    "ban_hero_vote",
                    {hero = params.hero, votes = banned_hero.votes, id = params.PlayerID}
                )
                find_banned = true
                break
            end
        end
        if not find_banned then
            local new_table = {name = params.hero, votes = 1}
            table.insert(BAN_HEROES_VOTE, new_table)
            CustomGameEventManager:Send_ServerToAllClients("ban_hero_vote", {hero = params.hero, votes = 1})
        end

        hero_select:check_banned_players()
    end
end

function hero_select:StartSelectionStage()
    PICK_STATE = PICK_STATE_SELECT_HERO

    Timers:CreateTimer(
        "",
        {
            useGameTime = false,
            endTime = 1,
            callback = function()
                hero_select:StartOrderPick()
            end
        }
    )
end

function hero_select:StartOrderPick()
    local time = Time_to_pick_Hero

    local id = 0

    for pid, pinfo in pairs(LOBBY_PLAYERS) do
        if pinfo.pick_order == PICK_ORDER then
            CustomGameEventManager:Send_ServerToAllClients("pick_start_time", {id = pid, time = time})
            CustomNetTables:SetTableValue(
                "custom_pick",
                "active_player",
                {
                    id = pid
                }
            )

            id = pid
            break
        end
    end

    Timers:CreateTimer(
        "",
        {
            useGameTime = false,
            endTime = 1,
            callback = function()
                if LOBBY_PLAYERS_MAX ~= 1 then
                    time = time - 1
                end

                CustomGameEventManager:Send_ServerToAllClients("change_time", {time = time, id = id})

                local server_player = FindPlayerServerData(id)
                if server_player ~= nil then
                    if server_player.has_low_priority then
                        hero_select:PickHero(id, hero_select:RandomHero(), 1)
                    end
                end

                if time <= 0 or (LOBBY_PLAYERS[id].picked_hero ~= nil) then
                    if LOBBY_PLAYERS[id].picked_hero == nil then
                        hero_select:PickHero(id, hero_select:RandomHero(), 1)
                    end

                    if PICK_STATE ~= PICK_STATE_SELECT_HERO then
                        return
                    end

                    PICK_ORDER = PICK_ORDER + 1

                    if PICK_ORDER < LOBBY_PLAYERS_MAX + 1 then
                        hero_select:StartOrderPick()
                    end

                    return
                end
                return 1
            end
        }
    )
end

function hero_select:StartOrderPickBase()
    local time = Time_to_pick_Base
    local id = 0

    for pid, pinfo in pairs(LOBBY_PLAYERS) do
        if pinfo.pick_order == PICK_ORDER then
            CustomGameEventManager:Send_ServerToAllClients(
                "pick_start_time_base",
                {
                    order = PICK_ORDER,
                    max = LOBBY_PLAYERS_MAX,
                    id = pid,
                    time = time,
                    picked_bases = PICKED_BASES,
                    picked_bases_length = #PICKED_BASES
                }
            )
            CustomNetTables:SetTableValue(
                "custom_pick",
                "active_player",
                {
                    id = pid
                }
            )

            id = pid

            break
        end
    end

    Timers:CreateTimer(
        "",
        {
            useGameTime = false,
            endTime = 1,
            callback = function()
                if LOBBY_PLAYERS_MAX ~= 0 then
                    time = time - 1
                end

                CustomGameEventManager:Send_ServerToAllClients("change_time_base", {time = time, id = id})

                if time <= 0 or (LOBBY_PLAYERS[id].select_base ~= nil) then
                    PICK_ORDER = PICK_ORDER - 1

                    if LOBBY_PLAYERS[id].select_base == nil then
                        hero_select:PickBase(id, hero_select:RandomBase())
                    end

                    if PICK_ORDER >= 0 then
                        hero_select:StartOrderPickBase()
                    end

                    return
                end

                return 1
            end
        }
    )
end

function hero_select:DrawPickScreenForPlayer(pid)
    if not PlayerResource:IsValidPlayerID(pid) then
        return
    end
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid), "pick_start", {})
end

function hero_select:init()
    _G.IN_STATE = true

    RegisterLoadListener(
        function(player, playerID)
            hero_select:PlayerLoaded(player, playerID)
        end
    )

    CustomGameEventManager:RegisterListener("chose_hero", Dynamic_Wrap(self, "ChoseHero"))
    CustomGameEventManager:RegisterListener("chose_base", Dynamic_Wrap(self, "ChoseBase"))
    CustomGameEventManager:RegisterListener("BanVoteHero", Dynamic_Wrap(self, "BanVoteHero"))

    for i = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        if PlayerResource:IsValidTeamPlayerID(i) then
            self:RegisterPlayerInfo(i)
        end
    end

    self:CheckReadyPlayers()
end


hero_changes = 
{
    ["npc_dota_hero_juggernaut"] = {"Tower","Omnislash","Healing_Ward"},
    ["npc_dota_hero_phantom_assassin"] = {"Tower","Blur","Blur","Scepter","Shard"},
    ["npc_dota_hero_huskar"] = {"Tower","Inner_Fire","Berserkers_Blood","Berserkers_Blood","Life_Break","Shard"},
    ["npc_dota_hero_nevermore"] = {"Tower","Shadowraze","Shadowraze","Shard"},
    ["npc_dota_hero_legion_commander"] = {"Tower","Duel","Duel"},
    ["npc_dota_hero_queenofpain"] = {"Dagger","Dagger","Dagger","Blink"},
    ["npc_dota_hero_terrorblade"] = {"Tower","Meta"},
    ["npc_dota_hero_bristleback"] = {"Tower","Goo","Goo","Goo","Spray","Warpath"},
    ["npc_dota_hero_puck"] = {"Tower","Orb","Rift","Coil","Shift","Shift","Coil"},
    ["npc_dota_hero_void_spirit"] = {"Tower","Astral","Remnant","Astral","Pulse","Pulse"},
    ["npc_dota_hero_ember_spirit"] = {"Tower","Guard","Fist","Guard","Guard","Shard"},
    ["npc_dota_hero_pudge"] = {"Tower","Hook","Dismember","Flesh","Shard"},
    ["npc_dota_hero_hoodwink"] = {"Tower","Sharp","Sharp","Sharp"},
    ["npc_dota_hero_skeleton_king"] = {"vampiric","reincarnation"},
    ["npc_dota_hero_lina"] = {"Tower","Dragon","Array","Laguna","Array","Soul","Soul"},
    ["npc_dota_hero_troll_warlord"] = {"Tower","rage","axes","fervor","fervor","trance","shard"},
    ["npc_dota_hero_axe"] = {"Tower","call","call","hunger","helix","culling","Shard"},
    ["npc_dota_hero_alchemist"] = {"Tower","Greed","Greed"},
    ["npc_dota_hero_ogre_magi"] = {"Tower", "Fireblast","Ignite","Ignite","Bloodlust","Shard", "Scepter", "Scepter", "Fireblast"},
    ["npc_dota_hero_antimage"] = {"Tower","Shard","Manabreak", "antimage_blink", "counterspell", "Scepter"},
}


function hero_select:RegisterHeroes()
    local enable_heroes = {}
    local hero_list = {}
    local anime = {}
    local all = {}
    local heroes = LoadKeyValues("scripts/npc/activelist.txt")
    local h = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
    local abilki = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")

    for k, v in pairs(heroes) do
        if v == 1 then
            table.insert(enable_heroes, k)
        end
    end

    for c = 1, #enable_heroes do
        local inf = h[enable_heroes[c]]
        local ability = {}
        local heroid = {}
        if inf then
            for ab = 1, 9 do
                if
                    inf["Ability" .. ab] ~= nil and inf["Ability" .. ab] ~= "" and
                        inf["Ability" .. ab] ~= "generic_hidden"
                 then
                    if abilki[inf["Ability" .. ab]] then
                        behavior = abilki[inf["Ability" .. ab]].AbilityBehavior
                    end
                    if behavior and not behavior:find("DOTA_ABILITY_BEHAVIOR_HIDDEN") then
                        table.insert(ability, inf["Ability" .. ab])
                    end
                end
            end
            CustomNetTables:SetTableValue("custom_pick", tostring(enable_heroes[c]), ability)
        end
    end

    HEROES_FOR_PICK = enable_heroes

    for _, hero in pairs(enable_heroes) do
        if h[hero].AttributePrimary == "DOTA_ATTRIBUTE_STRENGTH" then
            hero_list[hero] = 0
        elseif h[hero].AttributePrimary == "DOTA_ATTRIBUTE_AGILITY" then
            hero_list[hero] = 1
        elseif h[hero].AttributePrimary == "DOTA_ATTRIBUTE_INTELLECT" then
            hero_list[hero] = 2
        end
    end

    CustomNetTables:SetTableValue("custom_pick", "hero_list", hero_list)
    CustomNetTables:SetTableValue("custom_pick", "hero_changes", hero_changes)
end
