ogre_magi_unrefined_fireblast_custom = class({})

function ogre_magi_unrefined_fireblast_custom:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() then
        self:SetHidden(false)        
        if not self:IsTrained() then
            self:SetLevel(1)
        end
    else
        self:SetHidden(true)
    end
end

function ogre_magi_unrefined_fireblast_custom:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end

function ogre_magi_unrefined_fireblast_custom:GetManaCost( level )
	local pct = self:GetSpecialValueFor( "scepter_mana" ) / 100
	return math.floor( self:GetCaster():GetMana() * pct )
end

function ogre_magi_unrefined_fireblast_custom:OnSpellStart(new_target)
	if not IsServer() then return end

	local target = self:GetCursorTarget()

	if new_target ~= nil then 
		target = new_target
	end

	if target:TriggerSpellAbsorb( self ) then return end

	local duration = self:GetSpecialValueFor( "stun_duration" )

	local damage = self:GetSpecialValueFor( "fireblast_damage" )

	ApplyDamage( { victim = target, attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbilityDamageType(), ability = self } )

	target:AddNewModifier( self:GetCaster(), self,  "modifier_stunned",  {duration = duration * ( 1 - target:GetStatusResistance() )} )

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_unr_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:SetParticleControl( particle, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( particle )

	self:GetCaster():EmitSound("Hero_OgreMagi.Fireblast.Cast")
	target:EmitSound("Hero_OgreMagi.Fireblast.Target")
end