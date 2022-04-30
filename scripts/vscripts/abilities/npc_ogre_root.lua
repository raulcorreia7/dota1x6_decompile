LinkLuaModifier("modifier_ogre_root", "abilities/npc_ogre_root", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ogre_unit", "abilities/npc_ogre_root", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ogre_root_cd", "abilities/npc_ogre_root", LUA_MODIFIER_MOTION_NONE)

npc_ogre_root = class({})

function npc_ogre_root:OnSpellStart()

    if not IsServer() then
        return
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ogre_root_cd", {duration = self:GetCooldownTimeRemaining()})

    if self:GetCursorTarget():TriggerSpellAbsorb( self ) then return end   

    
    self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_ogre_root", {})

end

modifier_ogre_root = class ({})

function modifier_ogre_root:IsPurgable() return true end

function modifier_ogre_root:OnCreated(table)
if not IsServer() then
        return
    end
    local point = self:GetParent():GetAbsOrigin()
    self:GetParent():EmitSound("Hero_Crystal.frostbite")
     self.unit = CreateUnitByName("npc_dota_frostbite_s", point, false, self:GetCaster(), nil, DOTA_TEAM_CUSTOM_5)
    
    self.unit:AddNewModifier(self.unit, self:GetAbility(), "modifier_ogre_unit", {target = self:GetParent():entindex()})


end

function modifier_ogre_root:CheckState() return {[MODIFIER_STATE_ROOTED] = true} end



     function modifier_ogre_root:GetEffectName() return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf" end

     function modifier_ogre_root:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

modifier_ogre_unit = class ({})


function modifier_ogre_unit:IsPurgable() return false end
function modifier_ogre_unit:IsHidden() return true end



function modifier_ogre_unit:OnCreated(table)
    if not IsServer() then
        return
    end

    self.hits = self:GetAbility():GetSpecialValueFor("hits")
    self.target = EntIndexToHScript(table.target)
    self:StartIntervalThink(FrameTime())

end

function modifier_ogre_unit:OnIntervalThink()
    if self.target then
        if self.target:IsAlive() and self.target:HasModifier("modifier_ogre_root") then

            self:GetParent():SetAbsOrigin(self.target:GetAbsOrigin() + self.target:GetForwardVector()*64)

        else
            self:GetParent():Destroy()
        end
    end
end

function modifier_ogre_unit:DeclareFunctions()
    return {
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
MODIFIER_EVENT_ON_ATTACK_LANDED


    } end


    function modifier_ogre_unit:GetAbsoluteNoDamageMagical() return 1 end

     function modifier_ogre_unit:GetAbsoluteNoDamagePhysical() return 1 end

     function modifier_ogre_unit:GetAbsoluteNoDamagePure() return 1 end

function modifier_ogre_unit:OnAttackLanded( param )
 if not IsServer() then
        return
    end

    if self:GetParent() == param.target then
         self.hits = self.hits - 1
        self:GetParent():SetHealth(self.hits)
        if self.hits <= 0 then
            if self.target:HasModifier("modifier_ogre_root") then self.target:RemoveModifierByName("modifier_ogre_root") end
            self:GetParent():Kill(nil, param.attacker)
        end
    end
end

modifier_ogre_root_cd = class({})

function modifier_ogre_root_cd:IsHidden() return false end
function modifier_ogre_root_cd:IsPurgable() return false end