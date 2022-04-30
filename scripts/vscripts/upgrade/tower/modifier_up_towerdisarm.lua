
LinkLuaModifier("modifier_up_towerdisarm_disarm", "upgrade/tower/modifier_up_towerdisarm", LUA_MODIFIER_MOTION_NONE)




modifier_up_towerdisarm = class({})

function modifier_up_towerdisarm:IsHidden() return false end
function modifier_up_towerdisarm:IsPurgable() return true end

function modifier_up_towerdisarm:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
  
    }

 end

function modifier_up_towerdisarm:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_up_towerdisarm:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end


function modifier_up_towerdisarm:OnAttackLanded( params )
if not IsServer() then return end
if self:GetParent() == params.attacker then
    if RollPseudoRandomPercentage(20, 18, self:GetParent()) then
        params.target:AddNewModifier(self:GetParent(), nil, "modifier_up_towerdisarm_disarm", {duration = 3})
    end
end

end

modifier_up_towerdisarm_disarm = class({})

function modifier_up_towerdisarm_disarm:IsHidden() return false end
function modifier_up_towerdisarm_disarm:IsPurgable() return true  end
function modifier_up_towerdisarm_disarm:GetTexture() return "item_heavens_halberd" end

function modifier_up_towerdisarm_disarm:CheckState() return {[MODIFIER_STATE_DISARMED] = true } end

function modifier_up_towerdisarm_disarm:GetEffectName() return "particles/generic_gameplay/generic_disarm.vpcf" end


function modifier_up_towerdisarm_disarm:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end