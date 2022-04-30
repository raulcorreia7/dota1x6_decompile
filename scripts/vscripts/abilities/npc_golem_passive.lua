LinkLuaModifier("modifier_golem_passive", "abilities/npc_golem_passive.lua", LUA_MODIFIER_MOTION_NONE)

npc_golem_passive = class({})


function npc_golem_passive:GetIntrinsicModifierName() return "modifier_golem_passive" end
 
modifier_golem_passive = class ({})

function modifier_golem_passive:IsHidden() return true end

function modifier_golem_passive:DeclareFunctions() return {

    MODIFIER_EVENT_ON_DEATH,
    MODIFIER_EVENT_ON_ATTACK_LANDED

} end

function modifier_golem_passive:OnAttackLanded( param )
    if not IsServer() then end 
    if self:GetParent() == param.attacker  then
    local chance = self:GetAbility():GetSpecialValueFor("chance")
        local random = RollPseudoRandomPercentage(chance,1,self:GetParent())
        if random and not param.target:IsBuilding() then 
            local duration = self:GetAbility():GetSpecialValueFor("duration")
            param.target:AddNewModifier(param.attacker, self:GetAbility(), "modifier_stunned", { duration = duration*(1 - param.target:GetStatusResistance()) })
            param.target:EmitSound("Hero_Tiny.CraggyExterior")
            param.target:EmitSound("Hero_Tiny.CraggyExterior.Stun")
        end
    end

end

function modifier_golem_passive:OnDeath( param )
    if not IsServer() then end 
      
    if param.unit == self:GetParent() then
        local golems = {"npc_golem_small","npc_golem_medium","npc_golem_large"}
        local new_golem = nil

            for i = 2,4 do
                if golems[i] == self:GetParent():GetUnitName() then
                    for j = 1,2 do
                        new_golem = CreateUnitByName(golems[i-1], self:GetParent():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_CUSTOM_5)
                        new_golem.mkb = self:GetParent().mkb
                        new_golem.owner = self:GetParent().owner
                        new_golem:AddNewModifier(new_golem, nil, "modifier_waveupgrade", {})
                        new_golem.givegold = self:GetParent().givegold
                        new_golem.host = self:GetParent().host
                        new_golem.ally = nil
                        new_golem.summoned = true
                        if new_golem.givegold then 
                            local gold = new_golem:GetMinimumGoldBounty()
                              new_golem:SetMinimumGoldBounty(gold*GoldComeback)
                              new_golem:SetMaximumGoldBounty(gold*GoldComeback)
                        end
                     end
                break
                end
            end  
      
    end
end

