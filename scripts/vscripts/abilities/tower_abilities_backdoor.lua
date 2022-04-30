LinkLuaModifier( "modifier_tower_backdoor_timer", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_vision", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aura_backdoor", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor_buff", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_backdoor_buff_aura", "abilities/tower_abilities_backdoor.lua", LUA_MODIFIER_MOTION_NONE )


tower_aura_backdoor = class({})

function tower_aura_backdoor:GetIntrinsicModifierName() return "modifier_aura_backdoor" end



modifier_aura_backdoor = class({})


function modifier_aura_backdoor:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


modifier_aura_backdoor.items = 
{
	["item_blink"] = true,
	["item_swift_blink"] = true,
	["item_arcane_blink"] = true,
	["item_overwhelming_blink"] = true,
}


function modifier_aura_backdoor:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end

local target = params.unit

if not target then return end

if not target:IsHero() then return end


target:AddNewModifier(self:GetParent(), nil, "modifier_tower_vision", {duration = 5})


for i = 0, 8 do
	local current_item = target:GetItemInSlot(i)
	

	if current_item then	
		if self.items[current_item:GetName()] then 
			local cd = current_item:GetCooldownTimeRemaining()

			if cd < 5 then 
				current_item:StartCooldown(3)
			end
		end
	end
end



end


function modifier_aura_backdoor:IsHidden() return true end

function modifier_aura_backdoor:IsPurgable() return false end

function modifier_aura_backdoor:IsAura() return true end

function modifier_aura_backdoor:GetAuraDuration() return 1 end

function modifier_aura_backdoor:GetAuraRadius() return 1000 end

function modifier_aura_backdoor:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_aura_backdoor:GetAuraSearchType() return DOTA_UNIT_TARGET_BUILDING
 end

function modifier_aura_backdoor:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_aura_backdoor:GetModifierAura() return "modifier_backdoor" end

modifier_backdoor = class({})
function modifier_backdoor:IsHidden() return true end
function modifier_backdoor:IsPurgable() return false end

function modifier_backdoor:OnCreated(table)
if not IsServer() then return end

self.state = 0


self:StartIntervalThink(0.2)
end

function modifier_backdoor:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster() then return end
if not self:GetParent() then return end

local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE  + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)

if #enemies > 0 then 

	if self.state == 0 then 
		self.state = 1
   		self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_tower_backdoor_timer", {duration = 3})
   	end 

   	if self.state == 1 and not self:GetParent():HasModifier("modifier_tower_backdoor_timer") then 
   		self.state = 2
   	end

else 
	self.state = 0

	if self:GetParent():HasModifier("modifier_tower_backdoor_timer") then 
		self:GetParent():RemoveModifierByName("modifier_tower_backdoor_timer")
	end
end



if #enemies >= 2 and not self:GetCaster():HasModifier("modifier_backdoor_buff") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_backdoor_buff", {})
end



if #enemies < 2 and self:GetCaster():HasModifier("modifier_backdoor_buff") then 
	self:GetCaster():RemoveModifierByName("modifier_backdoor_buff")
end


end






function modifier_backdoor:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end
function modifier_backdoor:GetModifierIncomingDamage_Percentage(params) 
if not IsServer() then return end
local tower = towers[self:GetParent():GetTeamNumber()]

if not tower then return end

if (tower:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Length2D() > 900  or not params.attacker:IsAlive() then return
	-100
end

if params.attacker:IsInvulnerable() or params.attacker:IsOutOfGame() then 
	return -100
end

local attacker = params.attacker

if self.state ~= 2 and attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then 
	return -100
end

if attacker.owner ~= nil and attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then 

	if (tower:GetAbsOrigin() - attacker.owner:GetAbsOrigin()):Length2D() > 900 or not attacker.owner:IsAlive() then 
		return -100
	end

end


return 0 
end



function modifier_backdoor:OnTakeDamage(params) 
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end


local tower = towers[self:GetParent():GetTeamNumber()]

if not tower then return end
local back = false

if params.attacker:IsInvulnerable() or params.attacker:IsOutOfGame() then 
	back = true
end

if (tower:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Length2D() > 900 or not params.attacker:IsAlive() then 
	back = true 
end



local attacker = params.attacker
if attacker.owner ~= nil and attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5  then 

	if (tower:GetAbsOrigin() - attacker.owner:GetAbsOrigin()):Length2D() > 900 or not attacker.owner:IsAlive() then 
		back = true
	end

end
	
if self.state ~= 2 and attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then 
	back = true
end

if back == true then
	self:GetParent():EmitSound("Huskar.Disarm_Str")
	self.effect_cast = ParticleManager:CreateParticle("particles/items_fx/backdoor_protection.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 200, 0, 0) )
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
end

end











modifier_tower_backdoor_timer = class({})
function modifier_tower_backdoor_timer:IsHidden() return true end
function modifier_tower_backdoor_timer:IsPurgable() return false end

function modifier_tower_backdoor_timer:OnCreated(table)
if not IsServer() then return end
  self.t = -1
  self.timer = 3*2 
  self:StartIntervalThink(0.5)
  self:OnIntervalThink()
end


function modifier_tower_backdoor_timer:OnIntervalThink()
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

local particleName = "particles/huskar_timer.vpcf"

if self:GetCaster():GetUnitName() == "npc_towerdire" then 
	particleName = "particles/lina_timer.vpcf"
end

local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end




modifier_tower_vision = class({})
function modifier_tower_vision:IsHidden() return false end
function modifier_tower_vision:IsPurgable() return false end

function modifier_tower_vision:GetTexture() return "buffs/odds_fow" end

function modifier_tower_vision:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0.2)
end



function modifier_tower_vision:OnIntervalThink()
if not IsServer() then return end
local player = players[self:GetCaster():GetTeamNumber()]

if not player then 
	self:Destroy()
	return
end


AddFOWViewer(player:GetTeamNumber(), self:GetParent():GetAbsOrigin(), 50, 0.2, true)

end




modifier_backdoor_buff = class({})
function modifier_backdoor_buff:IsHidden() return true end
function modifier_backdoor_buff:IsPurgable() return false end

function modifier_backdoor_buff:IsAura() return true end

function modifier_backdoor_buff:GetAuraDuration() return 1 end

function modifier_backdoor_buff:GetAuraRadius() return 1000 end

function modifier_backdoor_buff:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_backdoor_buff:GetAuraSearchType() return DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_HERO
 end

function modifier_backdoor_buff:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
 end

function modifier_backdoor_buff:GetModifierAura() return "modifier_backdoor_buff_aura" end






modifier_backdoor_buff_aura = class({})
function modifier_backdoor_buff_aura:IsHidden() return true end
function modifier_backdoor_buff_aura:IsPurgable() return false end

function modifier_backdoor_buff_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_backdoor_buff_aura:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/items_fx/glyph.vpcf" , PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, Vector(150,1,1))
self:AddParticle(self.particle, false, false, -1, false, false)

end





function modifier_backdoor_buff_aura:GetModifierIncomingDamage_Percentage()
return -200
end


