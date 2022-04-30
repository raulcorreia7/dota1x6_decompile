
LinkLuaModifier("modifier_satyr_root_passive", "abilities/npc_satyr_root.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satyr_root_debuff", "abilities/npc_satyr_root.lua", LUA_MODIFIER_MOTION_NONE)

npc_satyr_root = class({})


function npc_satyr_root:GetIntrinsicModifierName() return "modifier_satyr_root_passive" end
 
modifier_satyr_root_passive = class ({})

function modifier_satyr_root_passive:IsHidden() return true end


function modifier_satyr_root_passive:DoScript(target)
    if not IsServer() then end 
    if not target:IsMagicImmune() then
    local chance = self:GetAbility():GetSpecialValueFor("chance")
        local random = RollPseudoRandomPercentage(chance,1,self:GetParent())
        if random  then 
            target:EmitSound("n_creep_Spawnlord.Freeze")
            local duration = self:GetAbility():GetSpecialValueFor("duration")
            target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_satyr_root_debuff", { duration = duration*(1 - target:GetStatusResistance()) })
        end
    end

end



modifier_satyr_root_debuff = class ({})

function modifier_satyr_root_debuff:IsHidden() return false end

function modifier_satyr_root_debuff:IsPurgable() return true end

function modifier_satyr_root_debuff:CheckState() return { [MODIFIER_STATE_ROOTED] = true } end

function modifier_satyr_root_debuff:OnCreated(table)
    local interval = 0.5
    self:StartIntervalThink(interval)
end

function modifier_satyr_root_debuff:OnIntervalThink()
    if not IsServer() then return end
    local tik = 0
    local total = self:GetAbility():GetSpecialValueFor("damage")
    local duration = self:GetAbility():GetSpecialValueFor("duration")
    local interval = 0.5
    tik = total / (duration / interval) 
    ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = tik, damage_type = DAMAGE_TYPE_MAGICAL})


end


function modifier_satyr_root_debuff:GetEffectName() return "particles/neutral_fx/prowler_shaman_shamanistic_ward.vpcf" end

function modifier_satyr_root_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
