/*	convars.sp
	
	Implements convars for server control over features of the plugin.
*/


// ConVars
ConVar g_cvAccelerateUseWeaponSpeed;
ConVar g_cvPrestrafe;
ConVar g_cvUniversalWeaponSpeed;
ConVar g_cvBhopTweaker;
ConVar g_cvBhopGracePeriod;
ConVar g_cvResetDuckSpeedOnLanding;
ConVar g_cvNerfPerfectCrouchjump;
ConVar g_cvSuppressLandingAnimation;
ConVar g_cvPlayerModelT;
ConVar g_cvPlayerModelCT;
ConVar g_cvSpeedPanel;


void RegisterConVars() {
	// Existing ConVars
	g_cvAccelerateUseWeaponSpeed = FindConVar("sv_accelerate_use_weapon_speed");
	
	// Custom ConVars
	g_cvPrestrafe = CreateConVar("mt_prestrafe", "1", "Sets whether prestrafe is enabled.");
	g_cvUniversalWeaponSpeed = CreateConVar("mt_universal_weapon_speed", "1", "Sets whether all weapons should have the same speed.");
	g_cvBhopTweaker = CreateConVar("mt_bhop_tweak", "1", "Sets whether running speed should be knife running speed regardless of held weapon.");
	g_cvBhopGracePeriod = CreateConVar("mt_bhop_grace_period", "0.01", "Amount of time in seconds after landing where jumping counts as a perfect bunnyhop.");
	g_cvResetDuckSpeedOnLanding = CreateConVar("mt_reset_duck_speed_on_landing", "1", "Sets whether to disable the slowdown encountered when spamming duck.");
	g_cvNerfPerfectCrouchjump = CreateConVar("mt_nerf_perfect_crouchjump", "1", "Sets whether to penalise perfect crouch jumps so that they are like normal jumps.");
	g_cvSuppressLandingAnimation = CreateConVar("mt_suppress_landing_animation", "1", "Sets whether to change player models on spawn to suppress the landing animations.");
	g_cvPlayerModelT = CreateConVar("mt_player_model_t", "models/player/tm_leet_varianta.mdl", "The model to change Terrorists to.");
	g_cvPlayerModelCT = CreateConVar("mt_player_model_ct", "models/player/ctm_idf_variantc.mdl", "The model to change Counter-Terrorists to.");
	g_cvSpeedPanel = CreateConVar("mt_speed_panel", "1", "Sets whether or not the centre speed information panel for players is enabled.");
	
	// ConVar Hooks
	HookConVarChange(g_cvUniversalWeaponSpeed, UniversalWeaponSpeedChanged);
	HookConVarChange(g_cvSuppressLandingAnimation, PlayerModelChanged);
	HookConVarChange(g_cvPlayerModelT, PlayerModelChanged);
	HookConVarChange(g_cvPlayerModelCT, PlayerModelChanged);	
}

public void UniversalWeaponSpeedChanged(Handle convar, const char[] oldValue, const char[] newValue) {
	UpdateAccelerateUseWeaponSpeed();
}

void UpdateAccelerateUseWeaponSpeed() {
	if (g_cvUniversalWeaponSpeed.IntValue) {
		SetConVarInt(g_cvAccelerateUseWeaponSpeed, 0);
	}
	else {
		SetConVarInt(g_cvAccelerateUseWeaponSpeed, 1);
	}
}

public void PlayerModelChanged(Handle convar, const char[] oldValue, const char[] newValue) {
	// Update player models based on what team they are on
	if (g_cvSuppressLandingAnimation.IntValue) {
		PrecachePlayerModels();		
		for (int client = 1; client <= MaxClients; client++) {
			if (IsValidClient(client)) {
				UpdatePlayerModel(client);
			}
		}
	}
} 