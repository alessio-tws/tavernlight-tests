-- [Q3]

-- Issue:   There wasn't a check in place for the party object. If the player doesn't have a party, this would result in a nil reference value.
--          The name of the method was obviously confusing and non descriptive.

-- Fix:     Added a check for a valid party. Also given that this function seems to remove a specific player (by name) from another player's party, it was renamed to `removeMemberFromParty`

-- Notes:   I'm not sure if this is intended to work with the built-in party system or a custom one, but I wasn't able to actually test this by creating a party manually
function removeMemberFromParty(playerId, memberName)
    player = Player(playerId)
    local party = player:getParty()
    if party then
        for k,v in pairs(party:getMembers()) do
            if v == Player(memberName) then
                party:removeMember(Player(memberName))
            end
        end
    else
        print("This player doesn't have a party")
    end
end