/*	api.sp

	API for other plugins.
*/


/*======  Forwards  ======*/

Handle gH_Forward_OnPlayerPerfectBunnyhopMT;

void CreateGlobalForwards() {
	gH_Forward_OnPlayerPerfectBunnyhopMT = CreateGlobalForward("OnPlayerPerfectBunnyhopMT", ET_Event, Param_Cell);
}

void Call_OnPlayerPerfectBunnyhopMT(int client) {
	Call_StartForward(gH_Forward_OnPlayerPerfectBunnyhopMT);
	Call_PushCell(client);
	Call_Finish();
}



/*======  Natives  ======*/

void CreateNatives() {
	CreateNative("MT_GetHitPerf", Native_GetHitPerf);
}

public int Native_GetHitPerf(Handle plugin, int numParams) {
	return view_as<int>(gB_HitPerf[GetNativeCell(1)]);
} 