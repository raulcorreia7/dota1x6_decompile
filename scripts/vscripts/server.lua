require("debug_")

Http = {}

function string.starts(String,Start)
    return  string.sub(String,1,string.len(Start))==Start
 end

function Http:WillSendData()
    return not IsInToolsMode() and IsDedicatedServer() and not string.starts(GetDedicatedServerKeyV2(''), "Invalid_")
end

function Http:IsValidGame(PlayerCount)
    return PlayerCount >= 6 and Http:WillSendData()
end
