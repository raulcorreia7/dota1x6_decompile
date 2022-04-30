require("debug_")

function CDOTA_BaseNPC:GetUpgradeStack(mod)
	if self:HasModifier(mod) then 
		return self:GetModifierStackCount(mod, self)
	end
	return 0
end

function CDOTA_BaseNPC:HasShard()
	return self:HasModifier("modifier_item_aghanims_shard")
end


function CDOTA_BaseNPC:UpgradeIllusion(mod, stack)
	local i = self:AddNewModifier(self, nil, mod, {})
	i:SetStackCount(stack)
end

function CDOTABaseAbility:GetState()
	return self:GetAutoCastState()
end

CDOTA_Ability_Lua.GetCastRangeBonus = function(self, hTarget)
	if not self or self:IsNull() then
		return 0
	end

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then
		return 0
	end

	return caster:GetCastRangeBonus()
end
 
CDOTABaseAbility.GetCastRangeBonus = function(self, hTarget)
	if not self or self:IsNull() then
		return 0
	end

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then
		return 0
	end

	return caster:GetCastRangeBonus()
end

CDOTA_BaseNPC.StartGesture_old = CDOTA_BaseNPC.StartGesture
CDOTA_BaseNPC.StartGesture = function(npc, activity)
	if type(activity) == "number" then
		npc:StartGesture_old(activity)
	else
		Debug:Log("invalid StartGesture(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.StartGestureFadeWithSequenceSettings_old = CDOTA_BaseNPC.StartGestureFadeWithSequenceSettings
CDOTA_BaseNPC.StartGestureFadeWithSequenceSettings = function(npc, activity)
	if type(activity) == "number" then
		npc:StartGestureFadeWithSequenceSettings_old(activity)
	else
		Debug:Log("invalid StartGestureFadeWithSequenceSettings(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.StartGestureWithFade_old = CDOTA_BaseNPC.StartGestureWithFade
CDOTA_BaseNPC.StartGestureWithFade = function(npc, activity, fadeIn, fadeOut)
	if type(activity) == "number" then
		npc:StartGestureWithFade_old(activity, fadeIn, fadeOut)
	else
		Debug:Log("invalid StartGestureWithFade(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ", " .. tostring(fadeIn) .. ", " .. tostring(fadeOut) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.StartGestureWithPlaybackRate_old = CDOTA_BaseNPC.StartGestureWithPlaybackRate
CDOTA_BaseNPC.StartGestureWithPlaybackRate = function(npc, activity, rate)
	if type(activity) == "number" then
		npc:StartGestureWithPlaybackRate_old(activity, rate)
	else
		Debug:Log("invalid StartGestureWithPlaybackRate(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ", " .. tostring(rate) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.FadeGesture_old = CDOTA_BaseNPC.FadeGesture
CDOTA_BaseNPC.FadeGesture = function(npc, activity)
	if type(activity) == "number" then
		npc:FadeGesture_old(activity)
	else
		Debug:Log("invalid FadeGesture(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.RemoveGesture_old = CDOTA_BaseNPC.RemoveGesture
CDOTA_BaseNPC.RemoveGesture = function(npc, activity)
	if type(activity) == "number" then
		npc:RemoveGesture_old(activity)
	else
		Debug:Log("invalid RemoveGesture(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ") at " .. debug.traceback())
	end
end
