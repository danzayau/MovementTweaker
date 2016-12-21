/*	misc.sp

	Miscellaneous functions.
*/


#define NORMAL_DUCK_SPEED 8.0


bool IsValidClient(int client) {
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client)) {
		return false;
	}
	return true;
}

void PrecacheModels() {
	PrecachePlayerModels();
}

void PrecachePlayerModels() {
	char playerModelT[256];
	char playerModelCT[256];
	GetConVarString(g_cvPlayerModelT, playerModelT, sizeof(playerModelT));
	GetConVarString(g_cvPlayerModelCT, playerModelCT, sizeof(playerModelCT));
	
	PrecacheModel(playerModelT, true);
	AddFileToDownloadsTable(playerModelT);
	PrecacheModel(playerModelCT, true);
	AddFileToDownloadsTable(playerModelCT);
}

int GetSpectatedPlayer(int client) {
	return GetEntPropEnt(client, Prop_Send, "m_hObserverTarget");
}

void DuckSlowdownTweak(client) {
	if (g_cvResetDuckSpeedOnLanding.IntValue && g_clientJustLanded[client]) {
		SetEntPropFloat(client, Prop_Send, "m_flDuckSpeed", NORMAL_DUCK_SPEED, 0);
	}
}

void UpdatePlayerModel(client) {
	char playerModel[256];
	if (GetClientTeam(client) == CS_TEAM_T) {
		GetConVarString(g_cvPlayerModelT, playerModel, sizeof(playerModel));
		SetEntityModel(client, playerModel);
		
	}
	else if (GetClientTeam(client) == CS_TEAM_CT) {
		GetConVarString(g_cvPlayerModelCT, playerModel, sizeof(playerModel));
		SetEntityModel(client, playerModel);		
	}
} 