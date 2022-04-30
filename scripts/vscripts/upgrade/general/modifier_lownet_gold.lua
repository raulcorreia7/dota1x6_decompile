LinkLuaModifier( "modifier_lownet_gold_buff", "upgrade/general/modifier_lownet_gold", LUA_MODIFIER_MOTION_NONE )
modifier_lownet_gold = class({})


function modifier_lownet_gold:IsHidden() return true end
function modifier_lownet_gold:IsPurgable() return false end


function modifier_lownet_gold:OnCreated(table)
if not IsServer() then return end
self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_lownet_gold_buff", {duration = lownet_duration})
end



modifier_lownet_gold_buff = class({})
function modifier_lownet_gold_buff:IsHidden() return false end
function modifier_lownet_gold_buff:IsPurgable() return false end
function modifier_lownet_gold_buff:RemoveOnDeath() return false end
function modifier_lownet_gold_buff:GetTexture() return "buffs/greed" end
function modifier_lownet_gold_buff:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_DEATH
}
end


function modifier_lownet_gold_buff:OnDeath(params)
if not IsServer() then return end 
if not params.attacker then return end

local attacker = params.attacker
if attacker.owner ~= nil then 
	attacker = attacker.owner
end
if attacker ~= self:GetParent() then return end
if not params.unit:IsCreep() then return end

local gold = params.unit:GetMaximumGoldBounty()*lownet_gold
if gold == 0 then return end

self:GetParent():ModifyGold(gold , true , DOTA_ModifyGold_CreepKill)
SendOverheadEventMessage(self:GetParent(), 0, self:GetParent(), gold, nil)

end
