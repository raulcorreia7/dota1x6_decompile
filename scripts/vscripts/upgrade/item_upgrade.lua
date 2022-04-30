

item_blue_upgrade = class({})

function item_blue_upgrade:OnSpellStart()
if not IsServer() then return end

local after = false
if self.after_legen == true then
	after = true
end

upgrade:init_upgrade(self:GetCaster(),2,nil,after)
self:SpendCharge()
end

function item_blue_upgrade:OnAbilityPhaseStart()
if not IsServer() then return end
if players[self:GetCaster():GetTeamNumber()].IsChoosing 
 then return false end
return true
end


------------------------------------------------------------


item_gray_upgrade = class({})

function item_gray_upgrade:OnSpellStart()
if not IsServer() then return end

local after = false
if self.after_legen == true then
	after = true
end

upgrade:init_upgrade(self:GetCaster(),1,nil,after)
self:SpendCharge()
end

function item_gray_upgrade:OnAbilityPhaseStart()
if not IsServer() then return end
if players[self:GetCaster():GetTeamNumber()].IsChoosing 
 then return false end
return true
end



-------------------------------------------------------------

item_legendary_upgrade = class({})

function item_legendary_upgrade:OnSpellStart()
if not IsServer() then return end

local after = false
if self.after_legen == true then
	after = true
end

upgrade:init_upgrade(self:GetCaster(),4,nil,after)
self:SpendCharge()
end

function item_legendary_upgrade:OnAbilityPhaseStart()
if not IsServer() then return end
if players[self:GetCaster():GetTeamNumber()].IsChoosing 
 then return false end
return true
end

--------------------------------------------------------------------

item_purple_upgrade = class({})

function item_purple_upgrade:OnSpellStart()
if not IsServer() then return end

local after = false
if self.after_legen == true then
	after = true
end

upgrade:init_upgrade(self:GetCaster(),3,nil,after)
self:SpendCharge()
end

function item_purple_upgrade:OnAbilityPhaseStart()
if not IsServer() then return end
if players[self:GetCaster():GetTeamNumber()].IsChoosing 
 then return false end
return true
end

-------------------------------------------------------------


item_purple_upgrade_shop = class({})

function item_purple_upgrade_shop:OnSpellStart()
if not IsServer() then return end

upgrade:init_upgrade(self:GetCaster(),3,nil,true)
self:SpendCharge()
end

function item_purple_upgrade_shop:OnAbilityPhaseStart()
if not IsServer() then return end
if players[self:GetCaster():GetTeamNumber()].IsChoosing 
 then return false end
return true
end



