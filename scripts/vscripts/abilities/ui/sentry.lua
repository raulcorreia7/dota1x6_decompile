LinkLuaModifier("modifier_item_custom_sentry_ward", "abilities/ui/sentry", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_custom_sentry_ward_charges", "abilities/ui/sentry", LUA_MODIFIER_MOTION_NONE)

custom_ability_sentry = class({})

function custom_ability_sentry:Spawn()
    if not IsServer() then return end
    if self and not self:IsTrained() then
        self:SetLevel(1)
    end
end

function custom_ability_sentry:GetIntrinsicModifierName()
    return "modifier_item_custom_sentry_ward_charges"
end


function custom_ability_sentry:OnInventoryContentsChanged()
    if not IsServer() then return end
    for i=0, 8 do
        local item = self:GetCaster():GetItemInSlot(i)
        if item then
            if item:GetName() == "item_ward_sentry" and not item.use_ui then
                if self:GetCaster():IsRealHero() then
                    local modifier_sentry = self:GetCaster():FindModifierByName("modifier_item_custom_sentry_ward_charges")
                    if modifier_sentry then
                        modifier_sentry:SetStackCount(modifier_sentry:GetStackCount() + item:GetCurrentCharges())
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

function custom_ability_sentry:OnAbilityPhaseStart()

    local mod_stacks = self:GetCaster():GetModifierStackCount("modifier_item_custom_sentry_ward_charges", self:GetCaster())
    if mod_stacks and mod_stacks <= 0 then
        local player = PlayerResource:GetPlayer( self:GetCaster():GetPlayerID() )
        CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#dota_hud_error_no_charges"})
        return false
    end
    return true
end

function custom_ability_sentry:OnSpellStart()
    if not IsServer() then return end
    self:GetCaster():EmitSound("DOTA_Item.ObserverWard.Activate")
    local hWard = CreateUnitByName("npc_dota_sentry_wards", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
    hWard:AddNewModifier(self:GetCaster(), self, "modifier_item_custom_sentry_ward", {})
    hWard:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = 480})
    AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), 50, 10, false)
    local mod = self:GetCaster():FindModifierByName("modifier_item_custom_sentry_ward_charges")
    if mod then
        mod:DecrementStackCount()
    end
end

modifier_item_custom_sentry_ward = class({})

function modifier_item_custom_sentry_ward:IsHidden() return true end

function modifier_item_custom_sentry_ward:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
    }

    return state
end



function modifier_item_custom_sentry_ward:OnCreated(params)
    if not IsServer() then return end
    self.destroy_attacks            = 8
    self.hero_attack_multiplier     = 4
    self.health_increments          = self:GetParent():GetMaxHealth() / self.destroy_attacks
end

function modifier_item_custom_sentry_ward:DeclareFunctions()
    local decFuncs = {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_EVENT_ON_ATTACKED
    }

    return decFuncs
end

function modifier_item_custom_sentry_ward:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_item_custom_sentry_ward:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_item_custom_sentry_ward:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_item_custom_sentry_ward:OnAttacked(keys)
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

function modifier_item_custom_sentry_ward:IsAura()
    return true
end

function modifier_item_custom_sentry_ward:IsHidden()
    return false
end

function modifier_item_custom_sentry_ward:IsPurgable()
    return false
end

function modifier_item_custom_sentry_ward:GetAuraRadius()
    return 700
end

function modifier_item_custom_sentry_ward:GetModifierAura()
    return "modifier_truesight"
end
   
function modifier_item_custom_sentry_ward:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_custom_sentry_ward:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_item_custom_sentry_ward:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_item_custom_sentry_ward:GetAuraDuration()
    return 0.1
end



modifier_item_custom_sentry_ward_charges = class({})
function modifier_item_custom_sentry_ward_charges:IsHidden() return true end
function modifier_item_custom_sentry_ward_charges:DestroyOnExpire() return false end
function modifier_item_custom_sentry_ward_charges:IsPurgable() return false end

function modifier_item_custom_sentry_ward_charges:OnCreated()
    self:SetStackCount(0)
    self.cooldown = 120
    self.duration = self.cooldown
    self:SetDuration(self.duration, true)
    self:StartIntervalThink(0.1)
end

function modifier_item_custom_sentry_ward_charges:OnIntervalThink()
    if not IsServer() then return end
    if self:GetStackCount() >= 3 then
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