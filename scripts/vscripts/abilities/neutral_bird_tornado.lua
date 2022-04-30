LinkLuaModifier("modifier_neutral_cast", "modifiers/modifier_neutral_cast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bird_tornado", "abilities/neutral_bird_tornado", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bird_tornado_cd", "abilities/neutral_bird_tornado", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tornado_kill", "abilities/neutral_bird_tornado", LUA_MODIFIER_MOTION_NONE)




neutral_bird_tornado = class({})

function neutral_bird_tornado:GetIntrinsicModifierName() return "modifier_bird_tornado" end





modifier_bird_tornado = class({})

function modifier_bird_tornado:IsPurgable() return false end

function modifier_bird_tornado:IsHidden() return true end

function modifier_bird_tornado:OnCreated(table)
    if not IsServer() then
        return
    end
	local ability = self:GetAbility()
	if not IsValidEntity(ability) then return end
    self.cd = self:GetAbility():GetSpecialValueFor("cd")
    self.health = self:GetAbility():GetSpecialValueFor("health")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.target = nil
    self.timer = nil
    self:StartIntervalThink(FrameTime())
end


function modifier_bird_tornado:OnIntervalThink()
    if not IsServer() then
        return
    end

	local parent = self:GetParent()
	if not IsValidEntity(parent) then return end

    if parent:IsSilenced() or parent:IsStunned() or not parent:IsAlive() then
        if self.timer ~= nil then
            Timers:RemoveTimer(self.timer)
            self.timer = nil
            parent:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
            parent:RemoveModifierByName("modifier_neutral_cast")
        end
        return
    end

	self.target = parent:GetAttackTarget()

	if parent:IsSilenced() or not IsValidEntity(self.target) then return end
	if parent:HasModifier("modifier_bird_tornado_cd") then return end
	if parent:HasModifier("modifier_neutral_cast") then return end
	if self.target:IsMagicImmune() then return end
	if parent:GetMana() < self:GetAbility():GetManaCost(1) then return end

	parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1)
	parent:AddNewModifier(parent, self:GetAbility(), "modifier_neutral_cast", {})


	self.timer = Timers:CreateTimer(0.4, function()


	--print(IsValidEntity(self.target), self.target:IsAlive())


		if not IsValidEntity(parent) or not parent:IsAlive() then return end
		parent:RemoveModifierByName("modifier_neutral_cast")



	--	if not IsValidEntity(self.target) or not self.target:IsAlive() then return end
		if parent:GetMana() < self:GetAbility():GetManaCost(1) then return end




		parent:EmitSound("n_creep_Wildkin.SummonTornado")
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_bird_tornado_cd", {
			duration = self.cd
		})
		parent:SpendMana(self:GetAbility():GetManaCost(1), self:GetAbility())

		local tornado = CreateUnitByName("npc_dota_enraged_wildkin_tornado", self:GetParent():GetAbsOrigin() + 100*self:GetParent():GetForwardVector(), true,
			nil, nil, DOTA_TEAM_NEUTRALS)
		tornado:SetOwner(parent)
		tornado:AddNewModifier(parent, self:GetAbility(), "modifier_tornado_kill", {
			duration = self.duration
		})
		local ab = tornado:FindAbilityByName("neutral_tornado_damage")
		ab:SetLevel(1)

		self.timer = nil
		Timers:CreateTimer(0.7, function()
			if not IsValidEntity(parent) or not parent:IsAlive() then return end
			parent:SetForceAttackTarget(nil)
		end)

	end)
end





modifier_bird_tornado_cd = class({})

function modifier_bird_tornado_cd:IsPurgable() return false end

function modifier_bird_tornado_cd:IsHidden() return false end



modifier_tornado_kill = class({})

function modifier_tornado_kill:IsHidden() return true end
function modifier_tornado_kill:IsPurgable() return false end
function modifier_tornado_kill:IsDebuff() return true end

function modifier_tornado_kill:OnDestroy()
if not IsServer() then return end
    self:GetParent():Destroy()
end
