LinkLuaModifier( "modifier_ogre_magi_smash_custom_buff", "abilities/ogre_magi/ogre_magi_smash", LUA_MODIFIER_MOTION_NONE )

ogre_magi_smash_custom = class({})

function ogre_magi_smash_custom:OnInventoryContentsChanged()
    if self:GetCaster():HasShard() then
        self:SetHidden(false)        
        if not self:IsTrained() then
            self:SetLevel(1)
        end
    else
        self:SetHidden(true)
    end
end

function ogre_magi_smash_custom:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end

function ogre_magi_smash_custom:OnSpellStart(multi)
	if not IsServer() then return end
	
	self:GetCaster():EmitSound("Hero_OgreMagi.FireShield.Target")
	if self:GetCaster():HasModifier("modifier_ogre_magi_bloodlust_custom_legendary_5") then 
		local ability = self:GetCaster():FindAbilityByName("ogre_magi_bloodlust_custom")
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_bloodlust_custom_legendary_resist", {duration = ability.legendary_resist_duration})
	end

	if self:GetCaster():HasModifier("modifier_ogremagi_multi_2") then 
		local ability = self:GetCaster():FindAbilityByName("ogre_magi_multicast_custom")
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_multicast_custom_spell", {duration = ability.spell_duration[self:GetCaster():GetUpgradeStack("modifier_ogremagi_multi_2")]})
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_multicast_custom_spell_count", {duration = ability.spell_duration[self:GetCaster():GetUpgradeStack("modifier_ogremagi_multi_2")]})
	end


	local duration = self:GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ogre_magi_smash_custom_buff", {duration = duration})
end

modifier_ogre_magi_smash_custom_buff = class({})

function modifier_ogre_magi_smash_custom_buff:IsPurgable() return false end


function modifier_ogre_magi_smash_custom_buff:OnCreated()
	if not IsServer() then return end
	self.max_stacks = self:GetAbility():GetSpecialValueFor("attacks")


	self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield.vpcf", PATTACH_CENTER_FOLLOW , self:GetParent() )
	ParticleManager:SetParticleControlEnt(  self.particle, 0, self:GetParent(), PATTACH_CENTER_FOLLOW , nil, self:GetParent():GetOrigin(), true )
	ParticleManager:SetParticleControl( self.particle, 1, Vector( 3, 0, 0 ) )
	ParticleManager:SetParticleControl( self.particle, 9, Vector( 1, 0, 0 ) )
	ParticleManager:SetParticleControl( self.particle, 10, Vector( 1, 0, 0 ) )
	ParticleManager:SetParticleControl( self.particle, 11, Vector( 1, 0, 0 ) )

	self:SetStackCount(self.max_stacks)
end

function modifier_ogre_magi_smash_custom_buff:OnStackCountChanged(iStackCount)
	if not IsServer() then return end
	ParticleManager:SetParticleControl( self.particle, 1, Vector( 3, 0, 0 ) )
	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end

function modifier_ogre_magi_smash_custom_buff:OnRefresh()
	if not IsServer() then return end
	self:SetStackCount(self:GetStackCount() + self.max_stacks)
	ParticleManager:SetParticleControl( self.particle, 1, Vector( 3, 0, 0 ) )	
end

function modifier_ogre_magi_smash_custom_buff:OnDestroy()
	if not IsServer() then return end
	if not self.particle then return end
  	ParticleManager:DestroyParticle(self.particle, true)
  	ParticleManager:ReleaseParticleIndex(self.particle) 
end

function modifier_ogre_magi_smash_custom_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_ogre_magi_smash_custom_buff:GetModifierIncomingDamage_Percentage(params)
	if not IsServer() then return end
	if params.attacker and params.inflictor == nil and params.damage then	
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self then 	
			self:DecrementStackCount()
			self:RemoveStack(params.attacker)
			return -70
		end
	end
end

function modifier_ogre_magi_smash_custom_buff:RemoveStack(target)
	if not IsServer() then return end

	if self:GetStackCount() <= 2 then
		ParticleManager:SetParticleControl( self.particle, 9, Vector( 0, 0, 0 ) )
	end

	if self:GetStackCount() <= 1 then
		ParticleManager:SetParticleControl( self.particle, 10, Vector( 0, 0, 0 ) )
	end

	local info = {
		Target = target,
		Source = self:GetCaster(),
		Ability = self:GetAbility(),	
		EffectName = "particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield_projectile.vpcf",
		iMoveSpeed = self:GetAbility():GetSpecialValueFor("projectile_speed"),
		bReplaceExisting = false,
		bProvidesVision = true,
		iVisionRadius = 50,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),			
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function ogre_magi_smash_custom:OnProjectileHit(target, vLocation)
	if target then
		local damage = self:GetSpecialValueFor("damage")
		target:EmitSound("Hero_OgreMagi.FireShield.Damage")
		ApplyDamage( { victim = target, attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbilityDamageType(), ability = self } )
	end
end