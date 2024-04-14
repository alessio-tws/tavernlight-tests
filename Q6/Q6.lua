--[[

	In order for this effect to work, I had to edit the source code of both the server and the client in the following way:

	For the server, I had to:
		- Create a new field in the `Creature` class to store the custom shader enabled state (with getter and setter)
		- Create a new method `Game::updateCreatureCustomShader(const Creature* creature)` that will send the creature custom shader state to the client
		- Create a new method `Player::sendCreatureCustomShader(const Creature* creature)` that will send a creature custom shader state to the client
		- Create a new method `ProtocolGame::sendShaderStatus(const Creature* creature)` that will send the shader state of a creature to the client using a custom NetworkMessage
		- Create a new static method `LuaScriptInterface::luaCreatureSetShader(lua_State* L)` and bind it so that it can be used in LUA

	For the client, I had to:
		- In the `Creature::draw` method I added the following code to use a custom shader if set:

		if (m_shader) {
			m_shader->bind();
			g_painter->setShaderProgram(m_shader);
		}
		datType->draw(dest, scaleFactor, 0, xPattern, yPattern, zPattern, animationPhase, yPattern == 0 ? lightView : nullptr);
		g_painter->resetShaderProgram();
		
		- In the `ProtocolGame::parseMessage` I added a check to see if the opcode is the newly added message for the custom shader
		- Set the `m_shader` field of the Creature if needed

	After those additions and changes to the source code, I was able to enable a simple shader (red tint) that is replicated to all clients when enabled (see video for Q6)

	Note: I can provide the full modified source code of the engine and client, if needed.
]]--


-- Setting the shader enabled\disabled
local function setCustomShader(creatureId, enabled)
	local creature = Creature(creatureId)	
	creature:setCustomShader(enabled)
end

-- Move a creature by onestep in the desired direction (if walkable)
local function moveCerature(creatureId, dir)
	local creature = Creature(creatureId)
	local newPos = getCreaturePosition(creature)

	if dir == 0 then
		newPos.y = newPos.y - 1
	elseif dir == 1 then
		newPos.x = newPos.x + 1
	elseif dir == 2 then
		newPos.y = newPos.y + 1
	elseif dir == 3 then
		newPos.x = newPos.x - 1
	end	
	creature:setDirection(dir)
	local t = Tile(newPos)
    local walkable = t.isWalkable(t)
    if walkable then
		creature:teleportTo(newPos)
	end
end

function onCastSpell(creature, variant)
	
	-- Enable the shader	
	creature:setCustomShader(true)
	-- Disable the shader after the effect ends
	addEvent(setCustomShader, 3*5*100+100, creature.uid, false)

	-- Move West 3 times
	for i=0, 3 do
		addEvent(moveCerature, i*100, creature.uid, 1)
	end
	-- Move South 3 times
	for i=0, 3 do
		addEvent(moveCerature, 400 + i*100, creature.uid, 2)
	end
	-- Move East 3 times
	for i=0, 3 do
		addEvent(moveCerature, 800 + i*100, creature.uid, 3)
	end
	-- Move North 3 times
	for i=0, 3 do
		addEvent(moveCerature, 1200 + i*100, creature.uid, 0)
	end

	return true
end