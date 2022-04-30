LinkLuaModifier("modifier_item_essence_of_speed", "abilities/items/item_essence_of_speed", LUA_MODIFIER_MOTION_NONE)
item_essence_of_speed = class({})


function item_essence_of_speed:OnAbilityPhaseStart()
if not IsServer() then return end
if self:GetCaster():HasModifier("modifier_item_essence_of_speed") then 
	 CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerID()), "CreateIngameErrorMessage", {message = "#essence_speed"})
   
	return false
end
return true
end


function item_essence_of_speed:OnSpellStart()
if not IsServer() then return end
    self:GetParent():EmitSound("Item.MoonShard.Consume")
    self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_item_essence_of_speed", {speed = self:GetSpecialValueFor("speed_bonus")})
    self:SpendCharge()
end



modifier_item_essence_of_speed = class({})
function modifier_item_essence_of_speed:IsHidden() return false end
function modifier_item_essence_of_speed:IsPurgable() return false end
function modifier_item_essence_of_speed:GetTexture() return 
"items/essence_speed" end

function modifier_item_essence_of_speed:RemoveOnDeath() return false end
function modifier_item_essence_of_speed:OnCreated(table)
if not IsServer() then return end
self.speed = table.speed
self:SetHasCustomTransmitterData(true)
end


function modifier_item_essence_of_speed:AddCustomTransmitterData() return 
{
speed = self.speed
} 
end

function modifier_item_essence_of_speed:HandleCustomTransmitterData(data)
self.speed = data.speed
end


function modifier_item_essence_of_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end

function modifier_item_essence_of_speed:GetModifierMoveSpeedBonus_Constant()
return self.speed
end