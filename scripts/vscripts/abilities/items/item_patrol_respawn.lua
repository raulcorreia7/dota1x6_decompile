LinkLuaModifier("modifier_patrol_repsawn", "abilities/items/item_patrol_respawn", LUA_MODIFIER_MOTION_NONE)

item_patrol_respawn               = class({})





function item_patrol_respawn:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("Patrol.Respawn")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_patrol_repsawn", {duration = self:GetSpecialValueFor("minutes")*60})
self:SpendCharge()

end

modifier_patrol_repsawn = class({})

function modifier_patrol_repsawn:IsHidden() return false end
function modifier_patrol_repsawn:GetTexture() return "item_phoenix_ash" end
function modifier_patrol_repsawn:IsPurgable() return false end
function modifier_patrol_repsawn:RemoveOnDeath() return false end

function modifier_patrol_repsawn:GetEffectName() return "particles/patrol_respawn.vpcf" end
