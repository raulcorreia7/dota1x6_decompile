LinkLuaModifier( "modifier_skeleton_king_mortal_strike_custom", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_armor", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_stun_stack", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_legendary", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_legendary_stack", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_cd", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_stack", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_stack_count", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_scepter", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_bkb", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )

skeleton_king_mortal_strike_custom = class({})

skeleton_king_mortal_strike_custom.scepter_duration = 7

skeleton_king_mortal_strike_custom.cd_init = 0
skeleton_king_mortal_strike_custom.cd_inc = 0.5

skeleton_king_mortal_strike_custom.cleave_init = 0
skeleton_king_mortal_strike_custom.cleave_inc = 0.2

skeleton_king_mortal_strike_custom.armor_init = -1
skeleton_king_mortal_strike_custom.armor_inc = -2

skeleton_king_mortal_strike_custom.stun_stack = 10
skeleton_king_mortal_strike_custom.stun_max = 3
skeleton_king_mortal_strike_custom.stun_duration = 1.2

skeleton_king_mortal_strike_custom.legendary_duration = 5
skeleton_king_mortal_strike_custom.legendary_speed = 80
skeleton_king_mortal_strike_custom.legendary_max = 5
skeleton_king_mortal_strike_custom.legendary_damage = 70
skeleton_king_mortal_strike_custom.legendary_cd = 20
skeleton_king_mortal_strike_custom.legendary_stack_duration = 10

skeleton_king_mortal_strike_custom.stack_duration = 3
skeleton_king_mortal_strike_custom.stack_init = 0.1
skeleton_king_mortal_strike_custom.stack_inc = 0.1

skeleton_king_mortal_strike_custom.bkb_duration = 2.5
skeleton_king_mortal_strike_custom.bkb_health = 85
skeleton_king_mortal_strike_custom.bkb_speed = 80



function skeleton_king_mortal_strike_custom:GetIntrinsicModifierName()
	return "modifier_skeleton_king_mortal_strike_custom"
end

function  skeleton_king_mortal_strike_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_skeleton_strike_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function skeleton_king_mortal_strike_custom:OnSpellStart()
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_skeleton_strike_legendary") then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_mortal_strike_legendary", {duration = self.legendary_duration})

end


function skeleton_king_mortal_strike_custom:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_skeleton_strike_legendary") then 
    return self.legendary_cd
end

local upgrade_cooldown = 0  
if self:GetCaster():HasModifier("modifier_skeleton_strike_1") then 
    upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_strike_1")
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end

modifier_skeleton_king_mortal_strike_custom = class({})

function modifier_skeleton_king_mortal_strike_custom:IsHidden() return true end
function modifier_skeleton_king_mortal_strike_custom:IsPurgable() return false end

function modifier_skeleton_king_mortal_strike_custom:GetCritDamage() 
local crit = self:GetAbility():GetSpecialValueFor("crit_mult")
if self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_legendary_stack") then 
    crit = crit + self:GetAbility().legendary_damage*self:GetParent():GetUpgradeStack("modifier_skeleton_king_mortal_strike_legendary_stack")
end

    return crit
end

function modifier_skeleton_king_mortal_strike_custom:OnCreated(table)
    self.record = nil
end

function modifier_skeleton_king_mortal_strike_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
        MODIFIER_EVENT_ON_ATTACK_CANCELLED,
        MODIFIER_EVENT_ON_ATTACK_FAIL,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end


function modifier_skeleton_king_mortal_strike_custom:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_skeleton_strike_4") then return end
if self:GetParent() ~= params.attacker then return end
if params.inflictor ~= nil then return end
if self.record == nil then return end
if params.unit:IsBuilding() then return end
if params.original_damage < 0 then return end

local damage = self:GetAbility().stack_init + self:GetAbility().stack_inc*self:GetParent():GetUpgradeStack("modifier_skeleton_strike_4")
damage = math.floor(damage*params.original_damage)
params.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_stack", {stack = damage, duration = self:GetAbility().stack_duration})

end

function modifier_skeleton_king_mortal_strike_custom:GetModifierPreAttack_CriticalStrike( params )
local crit = self:GetAbility():GetSpecialValueFor("crit_mult")

if self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_legendary_stack") then 
    crit = crit + self:GetAbility().legendary_damage*self:GetParent():GetUpgradeStack("modifier_skeleton_king_mortal_strike_legendary_stack")
end

self.bkb = false
self.record = nil
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_legendary") then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_cd") and not self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_scepter")
 then return end

if self:GetAbility():IsFullyCastable() or self:GetParent():HasModifier("modifier_skeleton_strike_legendary") or self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_scepter") then
    self:GetParent():RemoveGesture(ACT_DOTA_ATTACK_EVENT)
    self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT, self:GetParent():GetAttackSpeed())
    self.record = params.record

    if self:GetCaster():HasModifier("modifier_skeleton_strike_3") then 
        params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_armor", {})
    end

    if self:GetParent():HasModifier("modifier_skeleton_strike_6") and params.target:GetHealthPercent() >= self:GetAbility().bkb_health then 
        self.bkb = true
    end 

    return crit
end
 
return 0
end

function modifier_skeleton_king_mortal_strike_custom:GetModifierProcAttack_Feedback( params )
if not IsServer() then return end
if self.record and self.record == params.record then

    if self:GetParent():HasModifier("modifier_skeleton_strike_5") then 
        params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_stun_stack", {duration = self:GetAbility().stun_stack})
    end

    if self.bkb == true then 
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_bkb", {duration = self:GetAbility().bkb_duration})
    end

    if self:GetParent():HasModifier("modifier_skeleton_strike_2") then 
        DoCleaveAttack(self:GetParent(), params.target, nil, params.damage*(self:GetAbility().cleave_init + self:GetAbility().cleave_inc*self:GetParent():GetUpgradeStack("modifier_skeleton_strike_2")), 150, 360, 650, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf")
    end

    if self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_legendary_stack") then 
        self:GetParent():RemoveModifierByName("modifier_skeleton_king_mortal_strike_legendary_stack")
    end

    self:GetParent():EmitSound("Hero_SkeletonKing.CriticalStrike")
 	

    local cd = self:GetAbility():GetSpecialValueFor("cd")

    if self:GetCaster():HasModifier("modifier_skeleton_strike_1") then 
         cd = cd - (self:GetAbility().cd_init + self:GetAbility().cd_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_strike_1"))
    end
    cd = cd*self:GetParent():GetCooldownReduction()

    if not self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_scepter") then 

        if self:GetParent():HasModifier("modifier_skeleton_strike_legendary") then 
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_cd", {duration = cd})
        else
            self:GetAbility():UseResources(false, false, true)
        end
    else 
        local mod = self:GetParent():FindModifierByName("modifier_skeleton_king_mortal_strike_scepter")
        if mod then 
            mod:DecrementStackCount()
            if mod:GetStackCount() == 0 then 
                mod:Destroy()
            end
        end
    end


end
end

function modifier_skeleton_king_mortal_strike_custom:OnAttackCancelled( params )
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end


    if params.target:HasModifier("modifier_skeleton_king_mortal_strike_armor") then 
        params.target:RemoveModifierByName("modifier_skeleton_king_mortal_strike_armor")
    end

 	self.record = nil
	self:GetParent():RemoveGesture(ACT_DOTA_ATTACK_EVENT)
end


function modifier_skeleton_king_mortal_strike_custom:OnAttackFail(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end

    if params.target:HasModifier("modifier_skeleton_king_mortal_strike_armor") then 
        params.target:RemoveModifierByName("modifier_skeleton_king_mortal_strike_armor")
    end

end




modifier_skeleton_king_mortal_strike_armor = class({})
function modifier_skeleton_king_mortal_strike_armor:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_armor:IsPurgable() return false end


function modifier_skeleton_king_mortal_strike_armor:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_EVENT_ON_TAKEDAMAGE
}
end



function modifier_skeleton_king_mortal_strike_armor:GetModifierPhysicalArmorBonus()
return self:GetAbility().armor_init + self:GetAbility().armor_inc*self:GetCaster():GetUpgradeStack("modifier_skeleton_strike_3")
end

function modifier_skeleton_king_mortal_strike_armor:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetCaster() then return end
if params.inflictor ~= nil then return end

self:Destroy()
end

modifier_skeleton_king_mortal_strike_stun_stack = class({})
function modifier_skeleton_king_mortal_strike_stun_stack:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_stun_stack:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_stun_stack:GetTexture() return "buffs/mortal_bash" end
function modifier_skeleton_king_mortal_strike_stun_stack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_skeleton_king_mortal_strike_stun_stack:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().stun_max then 
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bashed", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().stun_duration})
    self:GetParent():EmitSound("BB.Goo_stun")  
    self:Destroy()
end

end



function modifier_skeleton_king_mortal_strike_stun_stack:OnStackCountChanged(iStackCount)
    if not IsServer() then return end

    if not self.pfx then
        self.pfx = ParticleManager:CreateParticle("particles/qop_fear_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
        self:AddParticle(self.pfx,false, false, -1, false, false)
    end

    ParticleManager:SetParticleControl(self.pfx, 1, Vector(0, self:GetStackCount(), 0))
end



function modifier_skeleton_king_mortal_strike_stun_stack:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_skeleton_king_mortal_strike_stun_stack:OnTooltip()
return self:GetAbility().stun_max
end

modifier_skeleton_king_mortal_strike_legendary = class({})
function modifier_skeleton_king_mortal_strike_legendary:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_legendary:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_legendary:GetEffectName() return "particles/lc_attack_buf.vpcf" end
function modifier_skeleton_king_mortal_strike_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_beserkers_call.vpcf" end
function modifier_skeleton_king_mortal_strike_legendary:StatusEffectPriority() return 10 end

function modifier_skeleton_king_mortal_strike_legendary:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_skeleton_king_mortal_strike_legendary:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:GetParent():EmitSound("WK.crit_buf")
    self.effect_cast = ParticleManager:CreateParticle( "particles/wk_crit_buf.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, self:GetParent():GetAbsOrigin() )

    self:AddParticle(self.effect_cast,false, false, -1, false, false)
end


function modifier_skeleton_king_mortal_strike_legendary:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().legendary_speed
end

function modifier_skeleton_king_mortal_strike_legendary:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

self:GetParent():EmitSound("WK.crit_hit")
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_mortal_strike_legendary_stack", {duration = self:GetAbility().legendary_stack_duration})

end

modifier_skeleton_king_mortal_strike_legendary_stack = class({})
function modifier_skeleton_king_mortal_strike_legendary_stack:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_legendary_stack:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_legendary_stack:GetTexture() return "buffs/strike_legen_count" end


function modifier_skeleton_king_mortal_strike_legendary_stack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_skeleton_king_mortal_strike_legendary_stack:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().legendary_max then 
    local mod = self:GetParent():FindModifierByName("modifier_skeleton_king_mortal_strike_legendary")
    if mod then 
        mod:Destroy()
    end
end

end


function modifier_skeleton_king_mortal_strike_legendary_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

    local particle_cast = "particles/wk_stack.vpcf"

    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

    self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end



function modifier_skeleton_king_mortal_strike_legendary_stack:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP
}

end

function modifier_skeleton_king_mortal_strike_legendary_stack:OnTooltip()
local crit = self:GetAbility():GetSpecialValueFor("crit_mult")
if self:GetParent():HasModifier("modifier_skeleton_king_mortal_strike_legendary_stack") then 
    crit = crit + self:GetAbility().legendary_damage*self:GetParent():GetUpgradeStack("modifier_skeleton_king_mortal_strike_legendary_stack")
end

return crit
end



modifier_skeleton_king_mortal_strike_cd = class({})
function modifier_skeleton_king_mortal_strike_cd:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_cd:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_cd:IsDebuff() return true end


modifier_skeleton_king_mortal_strike_stack = class({})
function modifier_skeleton_king_mortal_strike_stack:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_stack:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_stack:GetTexture() return "buffs/strike_stack" end

function modifier_skeleton_king_mortal_strike_stack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_skeleton_king_mortal_strike_stack:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.damage = table.stack

end

function modifier_skeleton_king_mortal_strike_stack:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/strike_wk_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetParent():EmitSound("WK.Strike_damage")
    local damage = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage =  self.damage,
        damage_type = DAMAGE_TYPE_PURE,
        ability = self:GetAbility()
    }
    ApplyDamage( damage )
end

modifier_skeleton_king_mortal_strike_stack_count = class({})
function modifier_skeleton_king_mortal_strike_stack_count:GetTexture() return "buffs/strike_stack" end

function modifier_skeleton_king_mortal_strike_stack_count:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_stack_count:IsPurgable() return false end

function modifier_skeleton_king_mortal_strike_stack_count:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(0)
end

function modifier_skeleton_king_mortal_strike_stack_count:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end
function modifier_skeleton_king_mortal_strike_stack_count:GetModifierPreAttack_BonusDamage()
return self:GetStackCount()
end


modifier_skeleton_king_mortal_strike_scepter = class({})
function modifier_skeleton_king_mortal_strike_scepter:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_scepter:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_scepter:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(table.stack)
end


modifier_skeleton_king_mortal_strike_bkb = class({})
function modifier_skeleton_king_mortal_strike_bkb:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_bkb:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_bkb:GetTexture() return "buffs/strike_bkb" end

function modifier_skeleton_king_mortal_strike_bkb:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_skeleton_king_mortal_strike_bkb:CheckState()
return
{
    [MODIFIER_STATE_MAGIC_IMMUNE] = true
}
end

function modifier_skeleton_king_mortal_strike_bkb:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end
function modifier_skeleton_king_mortal_strike_bkb:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().bkb_speed
end