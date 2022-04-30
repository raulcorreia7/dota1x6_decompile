LinkLuaModifier("modifier_neutral_cast", "modifiers/modifier_neutral_cast", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_centaur_stun", "abilities/neutral_centaur_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_centaur_stun_cd", "abilities/neutral_centaur_stun", LUA_MODIFIER_MOTION_NONE)




neutral_centaur_stun = class({})

function neutral_centaur_stun:GetIntrinsicModifierName() return "modifier_centaur_stun" end


modifier_centaur_stun = class({})

function modifier_centaur_stun:IsPurgable() return false end

function modifier_centaur_stun:IsHidden() return true end

function modifier_centaur_stun:OnCreated(table)
    if not IsServer() then
        return
    end
	local ability = self:GetAbility()
	if not IsValidEntity(ability) then return end

    self.stun = ability:GetSpecialValueFor("stun")
    self.cd = ability:GetSpecialValueFor("cd")
    self.aoe = ability:GetSpecialValueFor("aoe")
    self.damage = ability:GetSpecialValueFor("damage")
    self.target = nil
    self.timer = nil
    self:StartIntervalThink(FrameTime())
end


function modifier_centaur_stun:OnIntervalThink()
    if not IsServer() then
        return
    end

	local parent = self:GetParent()
	if not IsValidEntity(parent) then return end

	local ability = self:GetAbility()
	if not IsValidEntity(ability) then return end

    if parent:IsSilenced() or parent:IsStunned() or not parent:IsAlive() then
        if self.timer then
            Timers:RemoveTimer(self.timer)
            self.timer = nil
            parent:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
            parent:RemoveModifierByName("modifier_neutral_cast")
            ParticleManager:DestroyParticle(self.sign, true)
        end
        return
    end

	self.target = parent:GetAttackTarget()

	if not IsValidEntity(self.target) then return end
	if parent:HasModifier("modifier_centaur_stun_cd") then return end
	if parent:HasModifier("modifier_neutral_cast") then return end
	if self.target:IsMagicImmune() then return end
	if parent:GetMana() < self:GetAbility():GetManaCost(1) then return end

	parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1)
	parent:EmitSound("n_creep_Centaur.Stomp")
	self.sign = ParticleManager:CreateParticle("particles/generic_gameplay/generic_has_quest.vpcf",
		PATTACH_OVERHEAD_FOLLOW, parent)

	parent:AddNewModifier(parent, ability, "modifier_neutral_cast", {})

	self.timer = Timers:CreateTimer(0.5, function()
		if not IsValidEntity(parent) then return end

		self.timer = nil

		ParticleManager:DestroyParticle(self.sign, true)
		parent:RemoveModifierByName("modifier_neutral_cast")

		if not parent:IsAlive() or parent:GetMana() < ability:GetManaCost(1) then
			return
		end

		parent:AddNewModifier(parent, ability, "modifier_centaur_stun_cd", {
			duration = self.cd
		})

		parent:SpendMana(ability:GetManaCost(1), ability)
		local targets = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil,
			self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE +
				DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

		for _, target in ipairs(targets) do
			if IsValidEntity(target) and not target:IsMagicImmune() then
				ApplyDamage({
					victim = target,
					attacker = parent,
					damage = self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = ability
				})
				target:AddNewModifier(parent, ability, "modifier_stunned", {
					duration = self.stun * (1 - target:GetStatusResistance())
				})
			end
		end

		local trail_pfx = ParticleManager:CreateParticle("particles/neutral_fx/neutral_centaur_khan_war_stomp.vpcf",
			PATTACH_ABSORIGIN, parent)
		ParticleManager:SetParticleControl(trail_pfx, 1, Vector(self.aoe, 0, 0))
		ParticleManager:ReleaseParticleIndex(trail_pfx)

		if IsValidEntity(self.target) and self.target:IsAlive() then
			parent:SetForceAttackTarget(self.target)
			Timers:CreateTimer(0.7, function()
				parent:SetForceAttackTarget(nil)
			end)
		end

	end)

end




modifier_centaur_stun_cd = class({})

function modifier_centaur_stun_cd:IsPurgable() return false end

function modifier_centaur_stun_cd:IsHidden() return false end
