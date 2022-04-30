LinkLuaModifier("modifier_item_patrol_eye", "abilities/items/item_patrol_eye", LUA_MODIFIER_MOTION_NONE)
item_patrol_eye = class({})


function item_patrol_eye:OnSpellStart()
if not IsServer() then return end
    self:GetParent():EmitSound("Item.SeerStone")
    self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_item_patrol_eye", {radius = self:GetSpecialValueFor("radius"), duration = self:GetSpecialValueFor("duration")})
    self:SpendCharge()
end



modifier_item_patrol_eye = class({})
function modifier_item_patrol_eye:IsHidden() return false end
function modifier_item_patrol_eye:IsPurgable() return  end
function modifier_item_patrol_eye:GetAuraRadius()
    return 900
end
function modifier_item_patrol_eye:GetTexture() return "item_third_eye" end

function modifier_item_patrol_eye:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_item_patrol_eye:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_patrol_eye:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_item_patrol_eye:GetModifierAura()
    return "modifier_truesight"
end
function modifier_item_patrol_eye:IsAura() return true end
function modifier_item_patrol_eye:OnCreated(table)

self.radius = table.radius


if not IsServer() then return end

self:StartIntervalThink(FrameTime())

end

function modifier_item_patrol_eye:OnIntervalThink()
if not IsServer() then return end
AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.radius, FrameTime(), false)

end