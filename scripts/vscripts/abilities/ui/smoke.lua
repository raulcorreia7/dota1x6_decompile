
LinkLuaModifier("modifier_item_custom_smoke_charges", "abilities/ui/smoke", LUA_MODIFIER_MOTION_NONE)

custom_ability_smoke = class({})

function custom_ability_smoke:Spawn()
    if not IsServer() then return end
    if self and not self:IsTrained() then
        self:SetLevel(1)
    end
end


function custom_ability_smoke:GetIntrinsicModifierName()
    return "modifier_item_custom_smoke_charges"
end


function custom_ability_smoke:OnInventoryContentsChanged()
    if not IsServer() then return end
    for i=0, 8 do
        local item = self:GetCaster():GetItemInSlot(i)
        if item then
            if item:GetName() == "item_smoke_of_deceit" and not item.use_ui then
                if self:GetCaster():IsRealHero() then
                    local modifier_sentry = self:GetCaster():FindModifierByName("modifier_item_custom_smoke_charges")
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

function custom_ability_smoke:OnSpellStart()
    if not IsServer() then return end
    local mod_stacks = self:GetCaster():GetModifierStackCount("modifier_item_custom_smoke_charges", self:GetCaster())
    if mod_stacks and mod_stacks <= 0 then
        local player = PlayerResource:GetPlayer( self:GetCaster():GetPlayerID() )
        CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#dota_hud_error_no_charges"})
        self:EndCooldown()
        return
    end
    self:GetCaster():EmitSound("DOTA_Item.SmokeOfDeceit.Activate")
    local particle = ParticleManager:CreateParticle("particles/items2_fx/smoke_of_deceit.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(800, 1, 800))
    ParticleManager:ReleaseParticleIndex(particle)
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_smoke_of_deceit", {duration = self:GetSpecialValueFor("duration")})
    local mod = self:GetCaster():FindModifierByName("modifier_item_custom_smoke_charges")
    if mod then
        mod:DecrementStackCount()
    end
end

modifier_item_custom_smoke_charges = class({})
function modifier_item_custom_smoke_charges:IsHidden() return true end
function modifier_item_custom_smoke_charges:DestroyOnExpire() return false end
function modifier_item_custom_smoke_charges:IsPurgable() return false end

function modifier_item_custom_smoke_charges:OnCreated()
    self:SetStackCount(0)
    self.cooldown = 240
    self.duration = self.cooldown
    self:SetDuration(self.duration, true)
    self:StartIntervalThink(0.1)
end

function modifier_item_custom_smoke_charges:OnIntervalThink()
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