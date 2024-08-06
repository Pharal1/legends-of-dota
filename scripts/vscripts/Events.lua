if GameMode == nil then
	GameMode = class({})
end



function blinkKD(blink_item)
    if (blink_item:GetCooldownTimeRemaining() <= 3) then
        blink_item:EndCooldown()
        blink_item:StartCooldown(3.0)
    end
end

function GameMode:OnEntityHurt(data)
    local attaked = EntIndexToHScript(data.entindex_killed)
    if (EntIndexToHScript(data.entindex_attacker):GetPlayerOwnerID() > -1) then
        if (attaked:GetPlayerOwnerID() > -1) then
            if (attaked:FindItemInInventory('item_blink') ~= nil) then
                local blink_item = attaked:FindItemInInventory('item_blink')
                blinkKD(blink_item)
            elseif (attaked:FindItemInInventory('item_arcane_blink') ~= nil) then
                local blink_item = attaked:FindItemInInventory('item_arcane_blink')
                blinkKD(blink_item)
            elseif (attaked:FindItemInInventory('item_owerwhelming_blink') ~= nil) then
                local blink_item = attaked:FindItemInInventory('item_owerwhelming_blink')
                blinkKD(blink_item)
            elseif (attaked:FindItemInInventory('item_swift_blink') ~= nil) then
                local blink_item = attaked:FindItemInInventory('item_swift_blink')
                blinkKD(blink_item)
            end
        end
    end
end