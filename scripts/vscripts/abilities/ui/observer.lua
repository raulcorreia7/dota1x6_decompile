LinkLuaModifier("modifier_item_custom_observer_ward", "abilities/ui/observer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_custom_observer_ward_charges", "abilities/ui/observer", LUA_MODIFIER_MOTION_NONE)

custom_ability_observer = class({})

function custom_ability_observer:Spawn()
    if not IsServer() then return end
    if self and not self:IsTrained() then
        self:SetLevel(1)
    end
end

function custom_ability_observer:GetIntrinsicModifierName()
    return "modifier_item_custom_observer_ward_charges"
end

function custom_ability_observer:OnAbilityPhaseStart()
    local mod = self:GetCaster():FindModifierByName("modifier_item_custom_observer_ward_charges")
    if mod then
        if mod:GetStackCount() <= 0 then
            local player = PlayerResource:GetPlayer( self:GetCaster():GetPlayerID() )
            CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#dota_hud_error_no_charges"})
            return false
        end
    end
    return true
end

function custom_ability_observer:OnSpellStart()
    if not IsServer() then return end

    EmitSoundOnEntityForPlayer("DOTA_Item.ObserverWard.Activate", self:GetCaster(), self:GetCaster():GetPlayerOwnerID())

    if players[self:GetCaster():GetTeamNumber()] ~= nil then 
        players[self:GetCaster():GetTeamNumber()].obs_placed = players[self:GetCaster():GetTeamNumber()].obs_placed + 1
    end


    local hWard = CreateUnitByName("npc_dota_observer_wards", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
    hWard:AddNewModifier(self:GetCaster(), self, "modifier_item_custom_observer_ward", {})
    hWard:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = 360})
    local mod = self:GetCaster():FindModifierByName("modifier_item_custom_observer_ward_charges")
    if mod then
        mod:DecrementStackCount()
    end
end

function custom_ability_observer:OnInventoryContentsChanged()
    if not IsServer() then return end
    for i=0, 8 do
        local item = self:GetCaster():GetItemInSlot(i)
        if item then
            if item:GetName() == "item_ward_observer" and not item.use_ui then
                if self:GetCaster():IsRealHero() then
                    local modifier_observer = self:GetCaster():FindModifierByName("modifier_item_custom_observer_ward_charges")
                    if modifier_observer then
                        modifier_observer:SetStackCount(modifier_observer:GetStackCount() + item:GetCurrentCharges())
                    end
                    item.use_ui = true
                    Timers:CreateTimer(0, function()
                        UTIL_Remove( item )
                    end)
                end
            end
        end
    end
end



modifier_item_custom_observer_ward_charges = class({})
function modifier_item_custom_observer_ward_charges:IsHidden() return true end
function modifier_item_custom_observer_ward_charges:DestroyOnExpire() return false end
function modifier_item_custom_observer_ward_charges:IsPurgable() return false end

function modifier_item_custom_observer_ward_charges:OnCreated()
    self:SetStackCount(2)
    self.cooldown = 120
    self.duration = self.cooldown
    self:SetDuration(self.duration, true)
    self:StartIntervalThink(0.1)
end

function modifier_item_custom_observer_ward_charges:OnIntervalThink()
    if not IsServer() then return end
    if self:GetStackCount() >= 4 then
        self:SetDuration(self.cooldown + 0.5, true)
        return
    end
    if self.duration <= 0 then
        self:IncrementStackCount()
        self:SetDuration(self.cooldown, true)
        self.duration = self:GetRemainingTime()
        return
    end
    self.duration = self:GetRemainingTime()
end
































modifier_item_custom_observer_ward = class({})

function modifier_item_custom_observer_ward:IsHidden() return true end

function modifier_item_custom_observer_ward:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }

    return state
end

function modifier_item_custom_observer_ward:OnCreated(params)
    if not IsServer() then return end
    self.destroy_attacks            = 8
    self.hero_attack_multiplier     = 4
    self.health_increments          = self:GetParent():GetMaxHealth() / self.destroy_attacks
end

function modifier_item_custom_observer_ward:DeclareFunctions()
    local decFuncs = {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_EVENT_ON_ATTACKED
    }

    return decFuncs
end

function modifier_item_custom_observer_ward:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_item_custom_observer_ward:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_item_custom_observer_ward:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_item_custom_observer_ward:OnAttacked(keys)
    if not IsServer() then return end
    if keys.target == self:GetParent() then
        if keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
            if self:GetParent():GetHealthPercent() > 50 then
                self:GetParent():SetHealth(self:GetParent():GetHealth() - 10)
            else 
                self:GetParent():Kill(nil, keys.attacker)
            end
            return
        end
        if keys.attacker:IsRealHero() then
            self:GetParent():SetHealth(self:GetParent():GetHealth() - (self.health_increments * self.hero_attack_multiplier))
        else
            self:GetParent():SetHealth(self:GetParent():GetHealth() - self.health_increments)
        end
        if self:GetParent():GetHealth() <= 0 then
            self:GetParent():Kill(nil, keys.attacker)
        end
    end
end