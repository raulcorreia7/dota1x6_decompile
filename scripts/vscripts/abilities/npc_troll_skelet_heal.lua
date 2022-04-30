LinkLuaModifier("modifier_troll_heal", "abilities/npc_troll_skelet_heal.lua", LUA_MODIFIER_MOTION_NONE)


npc_troll_skelet_heal = class({})


function npc_troll_skelet_heal:GetIntrinsicModifierName() return "modifier_troll_heal" end


modifier_troll_heal = class({})

function modifier_troll_heal:IsHidden() return true end

function modifier_troll_heal:IsPurgable() return false end


function modifier_troll_heal:OnCreated(table)
    self.vampiric = self:GetAbility():GetSpecialValueFor("vampiric")
end

function modifier_troll_heal:DoScript()

if self:GetParent():GetOwner() ~= nil then
    self:GetParent():GetOwner():Heal(self:GetParent():GetOwner():GetMaxHealth()*(self.vampiric / 100), self:GetParent())
    local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent():GetOwner() )
    ParticleManager:ReleaseParticleIndex( particle )
end
  

end



