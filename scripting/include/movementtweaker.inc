/* 	Movement Tweaker API Include File
	
	Author: DanZay
*/


/*	Double-include prevention	*/
#if defined _movementtweaker_included_
#endinput
#endif
#define _movementtweaker_included_


// Forwards

/**
 * Called when the player hits a movement tweaker perfect b-hop.
 *
 * @param client			Client entity index.
 * @noreturn
 */
forward void OnPlayerPerfectBunnyhopMT(int client);


// Natives

/**
 * Gets the whether or not the player's latest jump was a movement tweaker perfect b-hop.
 *
 * @param client			Client entity index.
 * @return					whether or not the player's latest jump was a perfect b-hop.
 */
native bool MT_GetHitPerf(int client);