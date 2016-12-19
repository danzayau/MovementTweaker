/*	convars.sp
	
	Implements convars for server control over features of the plugin.
*/


// ConVars
ConVar g_cvAccelerateUseWeaponSpeed;
ConVar g_cvPrestrafe;
ConVar g_cvUniversalWeaponSpeed;
ConVar g_cvBhopTweaker;
ConVar g_cvSpeedPanel;


void RegisterConVars() {
	// Existing ConVars
	g_cvAccelerateUseWeaponSpeed = FindConVar("sv_accelerate_use_weapon_speed");
	
	// Custom ConVars
	g_cvPrestrafe = CreateConVar("mt_prestrafe", "1", "Sets whether prestrafe is enabled.");
	g_cvUniversalWeaponSpeed = CreateConVar("mt_universal_weapon_speed", "1", "Sets whether all weapons should have the same speed.");
	g_cvBhopTweaker = CreateConVar("mt_bhop_tweak", "1", "Sets whether running speed should be knife running speed regardless of held weapon.");
	g_cvSpeedPanel = CreateConVar("mt_speed_panel", "1", "Sets whether or not the centre speed information panel for players is enabled.");
	
	// ConVar Hooks
	HookConVarChange(g_cvUniversalWeaponSpeed, UniversalWeaponSpeedChanged);
}

public void UniversalWeaponSpeedChanged(Handle convar, const char[] oldValue, const char[] newValue) {
	UpdateAccelerateUseWeaponSpeed();
}

void UpdateAccelerateUseWeaponSpeed() {
	if (GetConVarInt(g_cvUniversalWeaponSpeed)) {
		SetConVarInt(g_cvAccelerateUseWeaponSpeed, 0);
	}
	else {
		SetConVarInt(g_cvAccelerateUseWeaponSpeed, 1);
	}
} 