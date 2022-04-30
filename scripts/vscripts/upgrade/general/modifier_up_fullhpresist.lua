
LinkLuaModifier("modifier_up_fullhpresist_buff", "upgrade/general/modifier_up_fullhpresist", LUA_MODIFIER_MOTION_NONE)


modifier_up_fullhpresist = class({})


function modifier_up_fullhpresist:IsHidden() return true end
function modifier_up_fullhpresist:IsPurgable() return false end

function modifier_up_fullhpresist:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
   self:StartIntervalThink(FrameTime())
end
function modifier_up_fullhpresist:RemoveOnDeath() return false end



function modifier_up_fullhpresist:OnIntervalThink()
if not IsServer() then return end 
	if self:GetParent():GetHealth() / self:GetParent():GetMaxHealth() >= 0.95 then 
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_up_fullhpresist_buff", {})
	else
		local mod = self:GetParent():FindModifierByName("modifier_up_fullhpresist_buff")
		if mod then mod:Destroy() end 
	end

end

modifier_up_fullhpresist_buff = class({})


function modifier_up_fullhpresist_buff:IsHidden() return false end
function modifier_up_fullhpresist_buff:IsPurgable() return false end

function modifier_up_fullhpresist_buff:GetTexture() return "item_aeon_disk" end

function modifier_up_fullhpresist_buff:DeclareFunctions()
    return {

        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING

    } end


function modifier_up_fullhpresist_buff:GetEffectName() return "particles/fullhp_resist2.vpcf" end




function modifier_up_fullhpresist_buff:GetModifierStatusResistanceStacking() 
return 60   
 end 
