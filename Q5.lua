-- The area of the effect
local CUSTOM_EFFECT_AREA = {
	{0, 0, 1, 1, 1, 0, 0},
	{0, 0, 1, 1, 1, 0, 0},
	{1, 1, 1, 1, 1, 1, 1},
	{1, 1, 1, 3, 1, 1, 1},
	{1, 1, 1, 1, 1, 1, 1},
	{0, 0, 1, 1, 1, 0, 0},
	{0, 0, 1, 1, 1, 0, 0}
}

-- Function to send a single effect to the player position plus an offset
local function sendEffecWithOffset(player, offsetX, offsetY)
    local newPos = getCreaturePosition(player)
    newPos.x = newPos.x + offsetX
    newPos.y = newPos.y + offsetY

    newPos:sendMagicEffect(43)
end

-- Loop over the area of effect and send all the effects
local function doEffect(creature)
	for k, v in pairs(CUSTOM_EFFECT_AREA) do
		for j, z in pairs(v) do
			if z == 1 then
				local delay =  (10 + math.random(40,110))*(k+j)
				addEvent(sendEffecWithOffset, delay, creature, k-4, j-4)
			end
		end
	end
end

function onCastSpell(creature, variant)	
	-- Repeat the effect with a delay to keep it alive
	for i=0,4 do
		addEvent(doEffect, i * 850, creature.uid)
	end
	return true
end