

modifier_nevermore_souls_attack = class({})


function modifier_nevermore_souls_attack:IsHidden() return true end
function modifier_nevermore_souls_attack:IsPurgable() return false end



function modifier_nevermore_souls_attack:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_nevermore_souls_attack:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_souls_attack:RemoveOnDeath() return false end