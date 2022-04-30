LinkLuaModifier("modifier_final_duel_start", "modifiers/modifier_final_duel", LUA_MODIFIER_MOTION_NONE)

modifier_final_duel = class({})


function modifier_final_duel:IsHidden() return true end
function modifier_final_duel:IsPurgable() return false end
function modifier_final_duel:RemoveOnDeath() return false end


function modifier_final_duel:GetAuraRadius()
	return 2500
end

function modifier_final_duel:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_final_duel:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_final_duel:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_final_duel:GetModifierAura()
	return "modifier_truesight"
end
function modifier_final_duel:IsAura() return true end


function modifier_final_duel:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BONUS_DAY_VISION,
	MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
	MODIFIER_EVENT_ON_DEATH
}

end

function modifier_final_duel:GetBonusDayVision() return 2500 end

function modifier_final_duel:GetBonusNightVision() return 2500 end

function modifier_final_duel:OnDeath(params)
if not IsServer() then return end
if self:GetCaster() ~= params.unit then return end
if self:GetCaster():IsReincarnating() then return end
	finish_duel()
end




function modifier_final_duel:Check_position(unit)
if unit:HasModifier("modifier_custom_juggernaut_omnislash") then return end
if not unit:IsAlive() then return end

local point = unit:GetAbsOrigin()
local change = false 

if unit:GetAbsOrigin().z < -1000 then 
	point.z = unit.z
	change = true
end 

if unit:GetAbsOrigin().x > unit.x_max then 
	point.x = unit.x_max - 50
	change = true
end

if unit:GetAbsOrigin().x < unit.x_min then 
	point.x = unit.x_min + 50
	change = true
end

if unit:GetAbsOrigin().y > unit.y_max then 
	point.y = unit.y_max - 50
	change = true
end

if unit:GetAbsOrigin().y < unit.y_min then 
	point.y = unit.y_min + 50 
	change = true	
end   

if change == true then 
	unit:SetAbsOrigin(point)
	FindClearSpaceForUnit(unit, point, true)
	unit:EmitSound("Hero_Rattletrap.Power_Cogs_Impact")
	unit:Stop()
	local attack_particle = ParticleManager:CreateParticle("particles/duel_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControlEnt(attack_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(attack_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(attack_particle, 60, Vector(31,82,167))
	ParticleManager:SetParticleControl(attack_particle, 61, Vector(1,0,0))

	 unit:AddNewModifier(nil, nil, "modifier_stunned", {duration = field_stun})


end

end


function modifier_final_duel:InitDuel()
if not IsServer() then return end
self:GetParent():Purge(false, true, false, true, true)
self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
self:GetParent():SetMana(self:GetParent():GetMaxMana())

self:GetParent():EmitSound("Hero_LegionCommander.Duel.Cast.Arcana")
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_final_duel_start", {duration = duel_start})

for _,mod in pairs(self:GetParent():FindAllModifiers()) do

    if (mod.RemoveForDuel and mod.RemoveForDuel == true) or
    	(mod:GetName() == "modifier_item_black_king_bar_custom_active")
    	or (mod:GetName() == "modifier_smoke_of_deceit")
     then 
       mod:Destroy()
    end
end

end




function modifier_final_duel:OnCreated(table)
if not IsServer() then return end

	self:SetStackCount(0)
	self:InitDuel()
	self:StartIntervalThink(0)

end


function modifier_final_duel:OnRefresh(table)
if not IsServer() then return end
	self:InitDuel()
end

function modifier_final_duel:OnIntervalThink()
if not IsServer() then return end
self:Check_position(self:GetParent())

local all_units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, 0, false)

for _,unit in pairs(all_units) do
	if not unit:IsCourier() and unit ~= self:GetParent()  then 
		self:Check_position(unit)
	end
end

end



modifier_final_duel_start = class({})

function modifier_final_duel_start:IsHidden() return false end
function modifier_final_duel_start:IsPurgable() return false end
function modifier_final_duel_start:GetTexture() return "legion_commander_duel" end
function modifier_final_duel_start:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_STUNNED] = true}
 end

function modifier_final_duel_start:OnCreated(table)
if not IsServer() then return end

   Timers:CreateTimer(0.5,function()

		PlayerResource:SetCameraTarget(self:GetParent():GetPlayerID(), nil)
   		local face_x = self:GetCaster():GetForwardVector().x*-75
   		local face_y = self:GetCaster():GetForwardVector().y*-75

		EndAllCooldowns(self:GetParent())
  		self:GetCaster().duel_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_duel_ring.vpcf", PATTACH_ABSORIGIN, self:GetCaster())

  		ParticleManager:SetParticleControl(self:GetCaster().duel_particle, 0, Vector(self:GetCaster():GetAbsOrigin().x + face_x,self:GetCaster():GetAbsOrigin().y  +face_y,self:GetCaster():GetAbsOrigin().z))
  	end)

self.t = -1
self.timer = duel_start*2 
self:StartIntervalThink(0.5)
self:OnIntervalThink()
end


function modifier_final_duel_start:OnDestroy()
if not IsServer() then return end
self:GetParent():Stop()
self:GetParent():EmitSound("Hero_LegionCommander.PressTheAttack")

if self:GetCaster().duel_particle then 
  ParticleManager:DestroyParticle(self:GetCaster().duel_particle, false)
end


end





function modifier_final_duel_start:OnIntervalThink()
if not IsServer() then return end
  self.t = self.t + 1
  local caster = self:GetParent()

        local number = (self.timer-self.t)/2 
        local int = 0
        int = number
       if number % 1 ~= 0 then int = number - 0.5  end

        local digits = math.floor(math.log10(number)) + 2

        local decimal = number % 1

        if decimal == 0.5 then
            decimal = 8
        else 
            decimal = 1
        end

local particleName = "particles/duel_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end
