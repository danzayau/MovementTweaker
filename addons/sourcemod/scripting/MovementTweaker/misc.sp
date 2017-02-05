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
	GetConVarString(gCV_PlayerModelT, gC_PlayerModelT, sizeof(gC_PlayerModelT));
	GetConVarString(gCV_PlayerModelCT, gC_PlayerModelCT, sizeof(gC_PlayerModelCT));
	
	PrecacheModel(gC_PlayerModelT, true);
	AddFileToDownloadsTable(gC_PlayerModelT);
	PrecacheModel(gC_PlayerModelCT, true);
	AddFileToDownloadsTable(gC_PlayerModelCT);
}

void UpdatePlayerModel(int client) {
	if (GetClientTeam(client) == CS_TEAM_T) {
		SetEntityModel(client, gC_PlayerModelT);
	}
	else if (GetClientTeam(client) == CS_TEAM_CT) {
		SetEntityModel(client, gC_PlayerModelCT);
	}
} 