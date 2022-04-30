
modifier_juggernaut_omnislash_heal = class({})


function modifier_juggernaut_omnislash_heal:IsHidden() return true end
function modifier_juggernaut_omnislash_heal:IsPurgable() return false end



function modifier_juggernaut_omnislash_heal:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_juggernaut_omnislash_heal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_juggernaut_omnislash_heal:RemoveOnDeath() return false end