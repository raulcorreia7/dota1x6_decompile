

modifier_terror_illusion_duration = class({})


function modifier_terror_illusion_duration:IsHidden() return true end
function modifier_terror_illusion_duration:IsPurgable() return false end



function modifier_terror_illusion_duration:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_terror_illusion_duration:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_illusion_duration:RemoveOnDeath() return false end