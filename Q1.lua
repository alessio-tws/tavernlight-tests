-- [Q1]
-- Issue:   The releaseStorage function was scheduled to run after 1 seconds from the logout of the player.
--          This means that the player object was already garbage collected\invalid. This would result in an obvious problem

-- Fix:     To fix the issue, I changed the code so that the releaseStorage function is called during the logout process,
--          where the player object is still valid for cleanup purposes. 
--          Also, I added a check in the releaseStorage function. Although the passed player should always be valid,
--          we don't want nasty unforeseen errors.

-- Notes:   I set the storage value at index 1000 to 1 on Login, so that this method can actually be tested
local function releaseStorage(player)
    -- Good practice is to always check that references are valid
    if player then
        print("Releasing value for " .. player:getName() .. ".")
        player:setStorageValue(1000, -1)
    else
        print("Invalid player")
    end
end

function onLogout(player)
    if player:getStorageValue(1000) == 1 then
        -- addEvent will schedule the releaseStorage function to be called 1 second after the log out
        -- this means that the player will already be invalid.
        -- To avoid this, we instead call the function directly during the logout process
        --addEvent(releaseStorage, 1000, player.uid)
        releaseStorage(player)
    end
    return true
end