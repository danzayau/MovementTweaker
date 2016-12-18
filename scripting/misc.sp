/*	misc.sp

	Miscellaneous functions.
*/

bool IsValidClient(int client) {
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client)) {
		return false;
	}
	return true;
}

int GetSpectatedPlayer(int client) {
	return GetEntPropEnt(client, Prop_Send, "m_hObserverTarget");
} 