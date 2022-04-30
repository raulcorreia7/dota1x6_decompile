

modifier_juggernaut_bladefury_silence = class({})


function modifier_juggernaut_bladefury_silence:IsHidden() return true end
function modifier_juggernaut_bladefury_silence:IsPurgable() return false end



function modifier_juggernaut_bladefury_silence:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end




function modifier_juggernaut_bladefury_silence:RemoveOnDeath() return false end