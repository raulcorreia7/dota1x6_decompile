

modifier_on_respawn = class({})


function modifier_on_respawn:IsHidden() return false end
function modifier_on_respawn:IsPurgable() return false end



function modifier_on_respawn:DeclareFunctions()
return 
{
	MODIFIER_EVENT_ON_RESPAWN,
	MODIFIER_EVENT_ON_DEATH
}

end
LinkLuaModifier( "modifier_lownet_choose", "modifiers/modifier_lownet_choose", LUA_MODIFIER_MOTION_NONE )

function modifier_on_respawn:RemoveOnDeath() return false end


function modifier_on_respawn:OnDeath(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

self.reinc = false 
if self:GetParent():IsReincarnating() then 
	self.reinc = true
end

end
function modifier_on_respawn:OnRespawn(param)
if not IsServer() then return end
if param.unit ~= self:GetParent() then return end 

    if self.reinc == false then 
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_invulnerable", {duration = 2})
    end


    self.reinc = false

    local parent_player = players[self:GetParent():GetTeamNumber()]
    if parent_player == nil then
        return
    end
    if parent_player.respawn_mod ~= nil then 
        local mod = self:GetParent():AddNewModifier(self:GetParent(), nil,parent_player.respawn_mod, {})
        parent_player.respawn_mod = nil 
        if mod then 
            mod.IsUpgrade = true
        end
    end


    if parent_player.give_lownet == 1 then 
        parent_player.give_lownet = 0
        parent_player:AddNewModifier(parent_player, nil, "modifier_lownet_choose", {})
    end
end