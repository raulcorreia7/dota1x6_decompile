LinkLuaModifier( "modifier_lownet_blue_buff", "upgrade/general/modifier_lownet_blue", LUA_MODIFIER_MOTION_NONE )




modifier_lownet_blue = class({})


function modifier_lownet_blue:IsHidden() return true end
function modifier_lownet_blue:IsPurgable() return false end


function modifier_lownet_blue:OnCreated(table)
if not IsServer() then return end

local hero = self:GetParent()

for i = 1,lownet_blue do 

	local item = CreateItem("item_blue_upgrade", hero, hero)

	item_effect = ParticleManager:CreateParticle("particles/blue_drop.vpcf", PATTACH_WORLDORIGIN, nil)

	local point = Vector(0, 0, 0)

	if hero:IsAlive() then
		point = hero:GetAbsOrigin() + RandomVector(150)
	else
		if towers[hero:GetTeamNumber()] ~= nil then
			point = towers[hero:GetTeamNumber()]:GetAbsOrigin() + towers[hero:GetTeamNumber()]:GetForwardVector() * 300
		end
	end

	ParticleManager:SetParticleControl(item_effect, 0, point)

	EmitSoundOnEntityForPlayer("powerup_03", hero, hero:GetPlayerOwnerID())

	item.after_legen = After_Lich

	Timers:CreateTimer(
			0.8,
			function()
				CreateItemOnPositionSync(GetGroundPosition(point, hero), item)
			end
		)



end

self:Destroy()


end



modifier_lownet_blue_buff = class({})
function modifier_lownet_blue_buff:IsHidden() return false end
function modifier_lownet_blue_buff:IsPurgable() return false end
function modifier_lownet_blue_buff:RemoveOnDeath() return false end
function modifier_lownet_blue_buff:GetTexture() return "buffs/blue" end
