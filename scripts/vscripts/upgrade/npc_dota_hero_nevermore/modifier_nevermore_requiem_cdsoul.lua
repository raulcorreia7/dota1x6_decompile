

modifier_nevermore_requiem_cdsoul = class({})


function modifier_nevermore_requiem_cdsoul:IsHidden() return true end
function modifier_nevermore_requiem_cdsoul:IsPurgable() return false end



function modifier_nevermore_requiem_cdsoul:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_nevermore_requiem_cdsoul:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_requiem_cdsoul:RemoveOnDeath() return false end