LinkLuaModifier("modifier_rogue_passive", "abilities/npc_rogue_passive.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rogue_debuff", "abilities/npc_rogue_passive.lua", LUA_MODIFIER_MOTION_NONE)

npc_rogue_passive = class({})


function npc_rogue_passive:GetIntrinsicModifierName() return "modifier_rogue_passive" end
 
modifier_rogue_passive = class({})

function modifier_rogue_passive:IsHidden() return true end

function modifier_rogue_passive:DeclareFunctions() return {

    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_ATTACK_RECORD,
    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS

} end

function modifier_rogue_passive:OnCreated(table)

       self.anim = nil
      self.proc = false
end

function modifier_rogue_passive:CheckState()
    local state = {}
    if self.proc then
        state = {[MODIFIER_STATE_CANNOT_MISS] = true}
    end
    return state 
end



function modifier_rogue_passive:OnAttackRecord( param )

   if self:GetParent() == param.attacker and  not param.target:IsMagicImmune() then
        self.anim = nil
    if self.proc then 
        self.proc = false
    end 

        if RollPseudoRandomPercentage(self:GetAbility():GetSpecialValueFor("chance"),1,self:GetParent())  then 
            self.anim = "slasher_offhand"
            self.proc = true
        end
    end


end

function modifier_rogue_passive:GetActivityTranslationModifiers() return self.anim end

function modifier_rogue_passive:OnAttackLanded( param )
    if self:GetParent() == param.attacker and  not param.target:IsMagicImmune() then
        if self.proc then 
            local duration = self:GetAbility():GetSpecialValueFor("duration")
            self:GetParent():EmitSound("DOTA_Item.SilverEdge.Target")
            param.target:AddNewModifier(param.attacker, self:GetAbility(), "modifier_rogue_debuff", { duration = duration*(1 - param.target:GetStatusResistance()) })
        end
    end

end



modifier_rogue_debuff = class ({})

function modifier_rogue_debuff:IsHidden() return false end

function modifier_rogue_debuff:IsPurgable() return true end

function modifier_rogue_debuff:CheckState() return { [MODIFIER_STATE_PASSIVES_DISABLED] = true } end


function modifier_rogue_debuff:GetTexture() return "pangolier_heartpiercer" end




