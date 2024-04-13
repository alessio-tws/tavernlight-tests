-- [Q2]
-- Issue:   To get all the guild names, we should iterate over the result of the query, otherwise only the first result
--          will be logged. Also the query should be freed after use.

-- Fix:     I loop over the result of the query and print the guild names

-- Notes:   In my environment the `guilds` table didn't have a `max_members` column. This might be due to version differences
--          or custom scheme of the DB. I manually added the `max_members` column for testing purpose.
--          Also it's the first time I use this framework\game and I'm not quite sure how one creates a guild, so I inserted some
--          rows in the guilds table manually
function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members

    local selectGuildQuery = string.format("SELECT * FROM guilds WHERE max_members < %d;", memberCount)
    local resultId = db.storeQuery(selectGuildQuery)

    -- We check that there are valid results
    if resultId == false then
        print("No guilds with fewer than " .. memberCount .. " maximum members")
    else
        -- We iterate through all the results and print the name column
        repeat
            local guildName = result.getString(resultId, "name")
            print("GuildName: " .. guildName)
        until not result.next(resultId)        
    end

    result.free(resultId)
end