/*	convars.sp
	
	ConVars for server control over features of the plugin.
*/


ConVar gCV_AccelerateUseWeaponSpeed;
ConVar gCV_Prestrafe;
ConVar gCV_UniversalWeaponSpeed;
ConVar gCV_PerfSpeedTweak;
ConVar gCV_PerfTimingTweak;
ConVar gCV_PerfTicks;
ConVar gCV_ResetDuckSpeedOnLanding;
ConVar gCV_JumpHeightTweak;
ConVar gCV_SuppressLandingAnimation;
ConVar gCV_PlayerModelT;
ConVar gCV_PlayerModelCT;

void RegisterConVars() {
	// Existing ConVars
	gCV_AccelerateUseWeaponSpeed = FindConVar("sv_accelerate_use_weapon_speed");
	
	// Custom ConVars
	gCV_Prestrafe = CreateConVar("mt_prestrafe", "1", "Sets whether prestrafe is enabled.");
	gCV_UniversalWeaponSpeed = CreateConVar("mt_universal_weapon_speed", "1", "Sets whether all weapons should have the same speed.");
	gCV_PerfSpeedTweak = CreateConVar("mt_perf_speed_tweak", "1", "Sets whether to adjust the speed rewarded when hitting a perfect b-hop.");
	gCV_PerfTimingTweak = CreateConVar("mt_perf_timing_tweak", "1", "Sets whether to adjust the number of ticks after landing that jumping is considered a perfect b-hop.");
	gCV_PerfTicks = CreateConVar("mt_perf_ticks", "2", "Number of ticks after landing where jumping counts as a perfect bunnyhop.");
	gCV_ResetDuckSpeedOnLanding = CreateConVar("mt_reset_duck_speed_on_landing", "1", "Sets whether to disable the slowdown encountered when spamming duck.");
	gCV_JumpHeightTweak = CreateConVar("mt_jump_height_tweak", "1", "Sets whether jump height rewarded from perfect bunnyhops and perfect crouchjumps is removed.");
	gCV_SuppressLandingAnimation = CreateConVar("mt_suppress_landing_animation", "1", "Sets whether to change player models on spawn to suppress the landing animations.");
	gCV_PlayerModelT = CreateConVar("mt_player_model_t", "models/player/tm_leet_varianta.mdl", "The model to change Terrorists to (applies after map change).");
	gCV_PlayerModelCT = CreateConVar("mt_player_model_ct", "models/player/ctm_idf_variantc.mdl", "The model to change Counter-Terrorists to (applies after map change).");
	
	// ConVar Hooks
	HookConVarChange(gCV_UniversalWeaponSpeed, UniversalWeaponSpeedChanged);
}

public void UniversalWeaponSpeedChanged(Handle convar, const char[] oldValue, const char[] newValue) {
	UpdateAccelerateUseWeaponSpeed();
}

void UpdateAccelerateUseWeaponSpeed() {
	if (gCV_UniversalWeaponSpeed.IntValue) {
		SetConVarInt(gCV_AccelerateUseWeaponSpeed, 0);
	}
	else {
		SetConVarInt(gCV_AccelerateUseWeaponSpeed, 1);
	}
} 