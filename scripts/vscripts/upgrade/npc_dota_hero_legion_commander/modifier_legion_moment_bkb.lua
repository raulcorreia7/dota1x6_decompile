

modifier_legion_moment_bkb = class({})


function modifier_legion_moment_bkb:IsHidden() return true end
function modifier_legion_moment_bkb:IsPurgable() return false end



function modifier_legion_moment_bkb:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true

end


function modifier_legion_moment_bkb:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_moment_bkb:RemoveOnDeath() return false end