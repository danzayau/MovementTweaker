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

int GetSpectatedPlayer(int client) {
	return GetEntPropEnt(client, Prop_Send, "m_hObserverTarget");
}

void DuckSlowdownTweak(client) {
	if (g_cvResetDuckSpeedOnLanding.IntValue && g_clientJustLanded[client]) {
		SetEntPropFloat(client, Prop_Send, "m_flDuckSpeed", NORMAL_DUCK_SPEED, 0);
	}
} 