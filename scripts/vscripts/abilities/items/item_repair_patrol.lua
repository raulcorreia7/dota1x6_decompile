LinkLuaModifier("modifier_repair_patrol", "abilities/items/item_repair_patrol.lua", LUA_MODIFIER_MOTION_NONE)

item_repair_patrol = class({})

function item_repair_patrol:OnSpellStart()
if not IsServer() then return end

self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_repair_patrol", {duration = self:GetSpecialValueFor("duration")})
self:GetCursorTarget():EmitSound("DOTA_Item.RepairKit.Target")
self:SpendCharge()
end


modifier_repair_patrol = class({})

function modifier_repair_patrol:IsHidden() return false end
function modifier_repair_patrol:IsPurgable() return false end
function modifier_repair_patrol:OnCreated(table)
self.heal = self:GetAbility():GetSpecialValueFor("heal")

if self:GetParent():GetUnitName() ~= "npc_towerradiant" and self:GetParent():GetUnitName() ~= "npc_towerdire" then 
	self.heal = self:GetAbility():GetSpecialValueFor("heal_shrine")
end

self.particle = ParticleManager:CreateParticle("particles/items5_fx/repair_kit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())

end
function modifier_repair_patrol:OnDestroy()
ParticleManager:DestroyParticle(self.particle , false)
ParticleManager:ReleaseParticleIndex(self.particle)
end

function modifier_repair_patrol:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_repair_patrol:GetTexture() return "item_repair_kit" end
function modifier_repair_patrol:GetModifierHealthRegenPercentage() return self.heal end
