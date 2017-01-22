/*	misc.sp

	Miscellaneous, non-specific functions.
*/


void SetupMovementMethodmaps() {
	for (int client = 1; client <= MaxClients; client++) {
		g_MovementPlayer[client] = new MovementPlayer(client);
	}
}

void PrecacheModels() {
	PrecachePlayerModels();
}

void PrecachePlayerModels() {
	char playerModelT[256];
	char playerModelCT[256];
	GetConVarString(gCV_PlayerModelT, playerModelT, sizeof(playerModelT));
	GetConVarString(gCV_PlayerModelCT, playerModelCT, sizeof(playerModelCT));
	
	PrecacheModel(playerModelT, true);
	AddFileToDownloadsTable(playerModelT);
	PrecacheModel(playerModelCT, true);
	AddFileToDownloadsTable(playerModelCT);
}

void UpdatePlayerModel(int client) {
	char playerModel[256];
	if (GetClientTeam(client) == CS_TEAM_T) {
		GetConVarString(gCV_PlayerModelT, playerModel, sizeof(playerModel));
		SetEntityModel(client, playerModel);
	}
	else if (GetClientTeam(client) == CS_TEAM_CT) {
		GetConVarString(gCV_PlayerModelCT, playerModel, sizeof(playerModel));
		SetEntityModel(client, playerModel);
	}
} 