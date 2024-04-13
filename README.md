# Alessio Saggio - Application

## Q1-Q3

From Q1 to Q3, even though it wasn't stated, I still used OT Forgotten Server and OTClient to test the code.

### Q1

Issue:
> The releaseStorage function was scheduled to run after 1 seconds from the logout of the player.  
> This means that the player object was already garbage collected\invalid. This would result in an obvious null error

How I solved it:
> To fix the issue, I changed the code so that the releaseStorage function is called during the logout process, where the player object is still valid for cleanup purposes. 
> 
> Also, I added a check in the releaseStorage function. Although the passed player should always be valid, we don't want nasty unforeseen errors.

**Note:** During testing,  I set the storage value at index 1000 to 1 on Login, so that this logic could actually be tested

### Q2

Issue:
> To get all the guild names, we should iterate over the result of the query, otherwise only the first result will be logged.
> 
>  Also the query should be freed after use.

How I solved it:
> I loop over the result of the query and print the guild names

**Note:** In my environment the `guilds` table didn't have a `max_members` column. This might be due to version differences or custom scheme of the DB. I manually added the `max_members` column for testing purpose. Also it's the first time I use this framework\game and I'm not quite sure how one creates a guild, so I inserted some rows in the guilds table manually.

### Q3

Issue:
> There wasn't a check in place for the party object. If the player doesn't have a party, this would result in a nil reference value. The name of the method was obviously confusing and non descriptive.

How I solved it:
> Added a check for a valid party. Also given that this function seems to remove a specific player (by name) from another player's party, it was renamed to `removeMemberFromParty`

**Note:** I'm not sure if this is intended to work with the built-in party system or a custom one, but I wasn't able to actually test this by creating a party manually

## Q4

Q4 asked to fix the memory leak(s) issue(s) in the code.
For this, I had to make some assumptions, and some might be wrong. I still tried to explain the assumptions I made and why in the comments.

## Q5

<video src='q5.mp4' width='280'>

For Q5, I created a custom logic to send the effects to the client using a 2D array for the effect area.
I then iterate through the bidimensional array and send the effects where the value of the index [x][y] == 1.
