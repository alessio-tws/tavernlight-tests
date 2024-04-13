void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
	Player* player = g_game.getPlayerByName(recipient);

	// If the player pointer is null, we must allocate memory for a new player object
	bool newPlayer = !player;

	if (newPlayer) {
		player = new Player(nullptr);

		// Here's one memory leak. If the system fails to load the player data, it will exit prematurely and
		// the player object allocated memory isn't deallocated and is not referenced anywhere.

		// We should delete the player object from memory before exiting the function
		if (!IOLoginData::loadPlayerByName(player, recipient)) {
			delete player;
			return;
		}
	}

	Item* item = Item::CreateItem(itemId);

	if (!item) {
		// I'm assuming that if the player object memory was just allocated and is still not saved in whatever method g_game uses for dynamic memory management, we should deallocate it manually
		// since we're exiting before saving the player object.
		if (newPlayer)
			delete player;

		return;
	}

	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

	if (player->isOffline()) {
		IOLoginData::savePlayer(player);
	}
}