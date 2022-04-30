LinkLuaModifier( "modifier_alchemist_goblins_greed_custom", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_stack", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_anim", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_inventory_attribute", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_kill", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_kill_count", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_scepter", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_haste", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_dd", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_regen", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_arcane", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_orbs", "abilities/alchemist/alchemist_goblins_greed_custom", LUA_MODIFIER_MOTION_NONE )

alchemist_goblins_greed_custom = class({})

alchemist_goblins_greed_custom.current_items = 0

alchemist_goblins_greed_custom.talent_bonus_gold = 2

alchemist_goblins_greed_custom.bonus_damage_fromgold = 5

alchemist_goblins_greed_custom.gold_to_attribute = 200
alchemist_goblins_greed_custom.bonus_attribute = 1
alchemist_goblins_greed_custom.bonus_attribute_maxstacks = {20,30}

alchemist_goblins_greed_custom.blue = {1,2,3}


alchemist_goblins_greed_custom.kill_move = 1
alchemist_goblins_greed_custom.kill_duration = {20,30,40}

alchemist_goblins_greed_custom.active_manacost = 100
alchemist_goblins_greed_custom.active_cooldown = 120
alchemist_goblins_greed_custom.active_channel_time = 1.5
alchemist_goblins_greed_custom.active_cd_reduction = 1

alchemist_goblins_greed_custom.scepter_k = 200
alchemist_goblins_greed_custom.scepter_max_per_creep = 20
alchemist_goblins_greed_custom.scepter_max = 150

alchemist_goblins_greed_custom.rune_duration = 30
alchemist_goblins_greed_custom.rune_haste = 100
alchemist_goblins_greed_custom.rune_arcane = 25
alchemist_goblins_greed_custom.rune_regen = 3
alchemist_goblins_greed_custom.rune_dd = 25


function alchemist_goblins_greed_custom:OnInventoryContentsChanged()
    if not IsServer() then return end
    for i=0, 8 do
        local item = self:GetCaster():GetItemInSlot(i)
        if item then
            if ( item:GetName() == "item_alchemist_gold_skadi" or item:GetName() == "item_alchemist_gold_daedalus" or item:GetName() == "item_alchemist_gold_cuirass" or item:GetName() == "item_alchemist_gold_octarine" or item:GetName() == "item_alchemist_gold_heart" or item:GetName() == "item_alchemist_gold_bfury" ) and not item.alchemist_check_item then
                if self:GetCaster():IsRealHero() then
                    local alchemist_modifier = self:GetCaster():FindModifierByName("modifier_alchemist_goblins_greed_custom")
                    if alchemist_modifier and self.current_items < 2 then
                    	item.alchemist_check_item = true
                    	alchemist_modifier.item_droppable = true
                    end
                end
            end
        end
    end
end

function alchemist_goblins_greed_custom:GetIntrinsicModifierName()
	return "modifier_alchemist_goblins_greed_custom"
end

function alchemist_goblins_greed_custom:GetBehavior()
	if self:GetCaster():HasModifier("modifier_alchemist_greed_6") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED
	end
    return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function alchemist_goblins_greed_custom:GetManaCost(iLevel)
	if self:GetCaster():HasModifier("modifier_alchemist_greed_6") then
    	return self.active_manacost
    end
    return 0
end

function alchemist_goblins_greed_custom:GetCooldown(iLevel)
	if self:GetCaster():HasModifier("modifier_alchemist_greed_6") then
    	return self.active_cooldown
    end
    return 0
end

function alchemist_goblins_greed_custom:GetChannelTime()
	if self:GetCaster():HasModifier("modifier_alchemist_greed_6") then
    	return self.active_channel_time
    end
    return 0
end

function alchemist_goblins_greed_custom:OnSpellStart()
	if not IsServer() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_alchemist_goblins_greed_custom_anim", {duration = self.active_channel_time})
	self:GetCaster():StartGesture(ACT_DOTA_TAUNT)
	self:EndCooldown()
end

function alchemist_goblins_greed_custom:OnChannelFinish(bInterrupted)
	if not IsServer() then return end
	self:GetCaster():FadeGesture(ACT_DOTA_TAUNT)
	self:GetCaster():RemoveModifierByName("modifier_alchemist_goblins_greed_custom_anim")
	self:UseResources(false, false, true)
	if bInterrupted then return end
	local particle = 4
	self:GetCaster():EmitSound("Alch.gold")

	
	CreateRune(self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*120, DOTA_RUNE_BOUNTY)  

	local effect_cast = ParticleManager:CreateParticleForPlayer( "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster():GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end

modifier_alchemist_goblins_greed_custom_anim = class({})

function modifier_alchemist_goblins_greed_custom_anim:IsHidden() return true end
function modifier_alchemist_goblins_greed_custom_anim:IsPurgable() return false end
function modifier_alchemist_goblins_greed_custom_anim:DeclareFunctions() return {MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS} end
function modifier_alchemist_goblins_greed_custom_anim:GetActivityTranslationModifiers() return "ogre_hop_gesture" end

modifier_alchemist_goblins_greed_custom = class({})

function modifier_alchemist_goblins_greed_custom:IsPurgable()
	return false
end

function modifier_alchemist_goblins_greed_custom:AllowIllusionDuplicate()
	return false
end

function modifier_alchemist_goblins_greed_custom:OnCreated( kv )
	self.base_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
	self.bonus_gold = self:GetAbility():GetSpecialValueFor( "bonus_bonus_gold" )
	self.max_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold_cap" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	if not IsServer() then return end

	self.legendary_recipes = {
		"item_recipe_alchemist_gold_skadi",
		"item_recipe_alchemist_gold_daedalus",
		"item_recipe_alchemist_gold_cuirass",
		"item_recipe_alchemist_gold_octarine",
		"item_recipe_alchemist_gold_heart",
		"item_recipe_alchemist_gold_bfury",
	}



	if self:GetCaster():IsIllusion() then self:Destroy() return end
	self.actual_stack = 0

	self.legendary_gold_reach = 0
	self.legendary_gold_maximum = 5000
	self.item_droppable = true

	self:CalculateStack()
	self:StartIntervalThink(FrameTime())
end

function modifier_alchemist_goblins_greed_custom:OnRefresh( kv )
	self.base_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
	self.bonus_gold = self:GetAbility():GetSpecialValueFor( "bonus_bonus_gold" )
	self.max_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold_cap" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	if not IsServer() then return end
	self:CalculateStack()
end

function modifier_alchemist_goblins_greed_custom:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_alchemist_greed_4") then

		if not self:GetParent():HasModifier("modifier_alchemist_goblins_greed_custom_inventory_attribute") then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_goblins_greed_custom_inventory_attribute", {})
		end

		local modifier = self:GetParent():FindModifierByName("modifier_alchemist_goblins_greed_custom_inventory_attribute")
		if modifier then

			local prev_stack = modifier:GetStackCount()

			local price = 0
			price = self:GetCaster():GetGold()
			local stack = math.floor(price / self:GetAbility().gold_to_attribute)
		
			local new_stack = math.min(stack,self:GetAbility().bonus_attribute_maxstacks[self:GetParent():GetUpgradeStack("modifier_alchemist_greed_4")])

			modifier:SetStackCount(new_stack)
			
			if new_stack ~= prev_stack then 
				self:GetParent():CalculateStatBonus(true)
			end

		end
	end
	if self:GetParent():HasModifier("modifier_alchemist_greed_legendary") then
		if self.item_droppable then
			self.legendary_gold_reach = self:GetCaster():GetGold()
			if self.legendary_gold_reach < self.legendary_gold_maximum then
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerID()), "alchemist_progress_update", {current_gold = self.legendary_gold_reach, max_gold = self.legendary_gold_maximum})
			else
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerID()), "alchemist_progress_update", {current_gold = self.legendary_gold_maximum, max_gold = self.legendary_gold_maximum})
			end
		end


		if self.legendary_gold_reach >= self.legendary_gold_maximum and self.item_droppable then
			local recipe_name = table.remove(self.legendary_recipes, RandomInt(1, #self.legendary_recipes))

			self.item_droppable = false
			self.legendary_gold_maximum = 10000

			self:GetAbility().current_items = self:GetAbility().current_items + 1


			local hero = self:GetParent()

			local item = CreateItem(recipe_name, hero, hero)

 			item_effect = ParticleManager:CreateParticle( "particles/orange_drop.vpcf", PATTACH_WORLDORIGIN, nil )

			local point = Vector(0,0,0)

 			if self:GetCaster():IsAlive() then

 				point = hero:GetAbsOrigin() + hero:GetForwardVector()*150 

			else

 				if towers[hero:GetTeamNumber()] ~= nil then 
 					point = towers[hero:GetTeamNumber()]:GetAbsOrigin() + towers[hero:GetTeamNumber()]:GetForwardVector()*300
 				end

 			end

    		ParticleManager:SetParticleControl( item_effect, 0, point )
       
    		EmitSoundOnEntityForPlayer("powerup_02", hero,  hero:GetPlayerOwnerID())


			Timers:CreateTimer(0.4,function()
 				CreateItemOnPositionSync(GetGroundPosition(point, unit), item)
			end)

			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerID()), "alchemist_progress_close", {})
		end

	end
end

function modifier_alchemist_goblins_greed_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end







function modifier_alchemist_goblins_greed_custom:OnDeath( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end
	if self:GetCaster():GetTeamNumber()==params.unit:GetTeamNumber() then return end
	if params.unit:IsBuilding() then return end
	if not self:GetParent():IsAlive() then return end


	local gold = self:GetStackCount()
	PlayerResource:ModifyGold( self:GetParent():GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )

	self:AddStack()


	local target = params.unit

	if target:GetTeam() == DOTA_TEAM_NEUTRALS and self:GetCaster():HasScepter() and self:GetParent():IsRealHero() and my_game:BluePoints(target) ~= nil then 
		local inc = math.min(self:GetAbility().scepter_max_per_creep, target:GetMaxHealth()/self:GetAbility().scepter_k)

		local mod = self:GetCaster():FindModifierByName("modifier_alchemist_goblins_greed_custom_scepter")

		if not mod then 
			mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_goblins_greed_custom_scepter", {})
		end

		local max = self:GetAbility():GetSpecialValueFor("scepter_max")

		if mod:GetStackCount() + inc < max then 
			mod:SetStackCount(mod:GetStackCount() + inc)
		else 
			mod:SetStackCount(inc - (max - mod:GetStackCount()))

			local mod_o = self:GetParent():FindModifierByName("modifier_alchemist_goblins_greed_custom_orbs")
			if mod_o then 
				mod_o:IncrementStackCount()
			end

			local hero = self:GetParent()

			local item = CreateItem("item_gray_upgrade", hero, hero)

 			item_effect = ParticleManager:CreateParticle( "particles/gray_drop.vpcf", PATTACH_WORLDORIGIN, nil )

			local point = Vector(0,0,0)



 			if self:GetCaster():IsAlive() then

 				point = hero:GetAbsOrigin() + hero:GetForwardVector()*150 

			else

 				if towers[hero:GetTeamNumber()] ~= nil then 
 					point = towers[hero:GetTeamNumber()]:GetAbsOrigin() + towers[hero:GetTeamNumber()]:GetForwardVector()*300
 				end

 			end

    		ParticleManager:SetParticleControl( item_effect, 0, point )
       
    		EmitSoundOnEntityForPlayer("powerup_04", hero,  hero:GetPlayerOwnerID())


			Timers:CreateTimer(0.8,function()
 				CreateItemOnPositionSync(GetGroundPosition(point, unit), item)
			end)
		end

	end




	if self:GetParent():HasModifier("modifier_alchemist_greed_3") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_goblins_greed_custom_kill", {duration = self:GetAbility().kill_duration[self:GetParent():GetUpgradeStack("modifier_alchemist_greed_3")]})
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_goblins_greed_custom_kill_count", {duration = self:GetAbility().kill_duration[self:GetParent():GetUpgradeStack("modifier_alchemist_greed_3")]})
	end

	local effect_cast = ParticleManager:CreateParticleForPlayer( "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local digit = string.len(tostring(math.floor(gold))) + 1
	local effect_cast_2 = ParticleManager:CreateParticleForPlayer( "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast_2, 1, Vector( 0, gold, 0 ) )
	ParticleManager:SetParticleControl( effect_cast_2, 2, Vector( 1, digit, 0 ) )
	ParticleManager:SetParticleControl( effect_cast_2, 3, Vector( 255, 255, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast_2 )


	if self:GetParent():HasModifier("modifier_alchemist_greed_6") then 
		local cd = self:GetAbility():GetCooldownTimeRemaining()

		self:GetAbility():EndCooldown()
		if cd > self:GetAbility().active_cd_reduction then 
			self:GetAbility():StartCooldown(cd - self:GetAbility().active_cd_reduction)
		end

	end
	
end

function modifier_alchemist_goblins_greed_custom:AddStack()
	self.actual_stack = self.actual_stack + 1
	self:CalculateStack()
	local duration = self.duration

	local modifier = self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_alchemist_goblins_greed_custom_stack", { duration = self.duration } )

	modifier.parent_modifier = self
end

function modifier_alchemist_goblins_greed_custom:RemoveStack()
	self.actual_stack = self.actual_stack - 1
	self:CalculateStack()
end

function modifier_alchemist_goblins_greed_custom:CalculateStack()
	local max_gold_bonus = self.max_gold

	if self:GetParent():HasModifier("modifier_alchemist_greed_1") then
		max_gold_bonus = max_gold_bonus + (self:GetAbility().talent_bonus_gold * self:GetCaster():GetUpgradeStack("modifier_alchemist_greed_1"))
	end

	local stack = math.min( self.base_gold + self.actual_stack*self.bonus_gold, max_gold_bonus )
	self:SetStackCount( stack )

end



modifier_alchemist_goblins_greed_custom_stack = class({})

function modifier_alchemist_goblins_greed_custom_stack:IsHidden()
	return true
end

function modifier_alchemist_goblins_greed_custom_stack:IsPurgable()
	return false
end

function modifier_alchemist_goblins_greed_custom_stack:RemoveOnDeath()
	return false
end

function modifier_alchemist_goblins_greed_custom_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_alchemist_goblins_greed_custom_stack:OnDestroy()
	if not IsServer() then return end
	self.parent_modifier:RemoveStack()
end

modifier_alchemist_goblins_greed_custom_inventory_attribute = class({})

function modifier_alchemist_goblins_greed_custom_inventory_attribute:IsPurgable() return false end
function modifier_alchemist_goblins_greed_custom_inventory_attribute:RemoveOnDeath() return false end
function modifier_alchemist_goblins_greed_custom_inventory_attribute:GetTexture() return "buffs/greed_gold" end



function modifier_alchemist_goblins_greed_custom_inventory_attribute:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end
function modifier_alchemist_goblins_greed_custom_inventory_attribute:GetModifierBonusStats_Strength() return self:GetStackCount() * self:GetAbility().bonus_attribute end
function modifier_alchemist_goblins_greed_custom_inventory_attribute:GetModifierBonusStats_Agility() return self:GetStackCount() * self:GetAbility().bonus_attribute end
function modifier_alchemist_goblins_greed_custom_inventory_attribute:GetModifierBonusStats_Intellect() return self:GetStackCount() * self:GetAbility().bonus_attribute  end







modifier_alchemist_goblins_greed_custom_kill_count = class({})
function modifier_alchemist_goblins_greed_custom_kill_count:IsHidden() return false end
function modifier_alchemist_goblins_greed_custom_kill_count:IsPurgable() return false end
function modifier_alchemist_goblins_greed_custom_kill_count:GetTexture() return "buffs/greed_kill" end


function modifier_alchemist_goblins_greed_custom_kill_count:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.RemoveForDuel = true
end
function modifier_alchemist_goblins_greed_custom_kill_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_alchemist_goblins_greed_custom_kill_count:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}

end

function modifier_alchemist_goblins_greed_custom_kill_count:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self:GetAbility().kill_move
end





modifier_alchemist_goblins_greed_custom_kill = class({})
function modifier_alchemist_goblins_greed_custom_kill:IsHidden() return true end
function modifier_alchemist_goblins_greed_custom_kill:IsPurgable() return false end
function modifier_alchemist_goblins_greed_custom_kill:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_alchemist_goblins_greed_custom_kill:OnCreated(table)
self.RemoveForDuel = true
end

function modifier_alchemist_goblins_greed_custom_kill:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_alchemist_goblins_greed_custom_kill_count")
if not mod then return end
mod:DecrementStackCount()

if mod:GetStackCount() == 0 then 
  mod:Destroy()
end
end





modifier_alchemist_goblins_greed_custom_scepter = class({})
function modifier_alchemist_goblins_greed_custom_scepter:IsHidden()
 return false
end
function modifier_alchemist_goblins_greed_custom_scepter:IsPurgable() return false end
function modifier_alchemist_goblins_greed_custom_scepter:RemoveOnDeath() return false end
function modifier_alchemist_goblins_greed_custom_scepter:GetTexture() return "buffs/greed_scepter" end
function modifier_alchemist_goblins_greed_custom_scepter:OnCreated(table)
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_goblins_greed_custom_orbs", {})
end



function modifier_alchemist_goblins_greed_custom_scepter:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end

function modifier_alchemist_goblins_greed_custom_scepter:OnTooltip()
return self:GetAbility().scepter_max
end


function modifier_alchemist_goblins_greed_custom_scepter:OnTooltip2()
return self:GetParent():GetUpgradeStack("modifier_alchemist_goblins_greed_custom_orbs")
end




modifier_alchemist_goblins_greed_custom_haste = class({})
function modifier_alchemist_goblins_greed_custom_haste:IsHidden() return false end
function modifier_alchemist_goblins_greed_custom_haste:IsPurgable() return true end
function modifier_alchemist_goblins_greed_custom_haste:GetTexture() return "rune_haste" end
function modifier_alchemist_goblins_greed_custom_haste:GetEffectName()
return "particles/generic_gameplay/rune_haste_owner.vpcf"
end

function modifier_alchemist_goblins_greed_custom_haste:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_haste")
self.RemoveForDuel = true
end

function modifier_alchemist_goblins_greed_custom_haste:OnRefresh(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_haste")
end


function modifier_alchemist_goblins_greed_custom_haste:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end

function modifier_alchemist_goblins_greed_custom_haste:GetModifierMoveSpeedBonus_Constant()
return self:GetAbility().rune_haste
end





modifier_alchemist_goblins_greed_custom_dd = class({})
function modifier_alchemist_goblins_greed_custom_dd:IsHidden() return false end
function modifier_alchemist_goblins_greed_custom_dd:IsPurgable() return true end
function modifier_alchemist_goblins_greed_custom_dd:GetTexture() return "rune_doubledamage" end
function modifier_alchemist_goblins_greed_custom_dd:GetEffectName()
return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
end

function modifier_alchemist_goblins_greed_custom_dd:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_dd")
self.RemoveForDuel = true
end

function modifier_alchemist_goblins_greed_custom_dd:OnRefresh(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_dd")
end


function modifier_alchemist_goblins_greed_custom_dd:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_alchemist_goblins_greed_custom_dd:GetModifierDamageOutgoing_Percentage()
return self:GetAbility().rune_dd
end





modifier_alchemist_goblins_greed_custom_regen = class({})
function modifier_alchemist_goblins_greed_custom_regen:IsHidden() return false end
function modifier_alchemist_goblins_greed_custom_regen:IsPurgable() return true end
function modifier_alchemist_goblins_greed_custom_regen:GetTexture() return "rune_regen" end
function modifier_alchemist_goblins_greed_custom_regen:GetEffectName()
return "particles/generic_gameplay/rune_regen_owner.vpcf"
end

function modifier_alchemist_goblins_greed_custom_regen:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_regen")
self.RemoveForDuel = true
end

function modifier_alchemist_goblins_greed_custom_regen:OnRefresh(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_regen")
end


function modifier_alchemist_goblins_greed_custom_regen:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_alchemist_goblins_greed_custom_regen:GetModifierHealthRegenPercentage()
return self:GetAbility().rune_regen
end




modifier_alchemist_goblins_greed_custom_arcane = class({})
function modifier_alchemist_goblins_greed_custom_arcane:IsHidden() return false end
function modifier_alchemist_goblins_greed_custom_arcane:IsPurgable() return true end
function modifier_alchemist_goblins_greed_custom_arcane:GetTexture() return "rune_arcane" end
function modifier_alchemist_goblins_greed_custom_arcane:GetEffectName()
return "particles/generic_gameplay/rune_arcane_owner.vpcf"
end

function modifier_alchemist_goblins_greed_custom_arcane:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_arcane")
self.RemoveForDuel = true
end

function modifier_alchemist_goblins_greed_custom_arcane:OnRefresh(table)
if not IsServer() then return end
self:GetParent():EmitSound("Alch.Rune_arcane")
end


function modifier_alchemist_goblins_greed_custom_arcane:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
}
end

function modifier_alchemist_goblins_greed_custom_arcane:GetModifierPercentageCooldown()
return self:GetAbility().rune_arcane
end

modifier_alchemist_goblins_greed_custom_orbs = class({})
function modifier_alchemist_goblins_greed_custom_orbs:RemoveOnDeath() return false end
function modifier_alchemist_goblins_greed_custom_orbs:IsHidden() return true end
function modifier_alchemist_goblins_greed_custom_orbs:IsPurgable() return false end