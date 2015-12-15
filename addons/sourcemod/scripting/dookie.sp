#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "CS:GO Dookie",
	author = "Tom Delebo",
	description = "Drop a steaming hot turdburger on scrubs!",
	version = "1.0",
	url = "https://github.com/delebota/CS-GO-Dookie-Mod"
};

// Sounds
#define DOOKIE_SOUND             "dookie/dookie.wav"
#define DOOKIE_SOUND_FULL        "sound/dookie/dookie.wav"
#define DOOKIE_SUPER_SOUND       "dookie/superdookie.wav"
#define DOOKIE_SUPER_SOUND_FULL  "sound/dookie/superdookie.wav"

// Models
#define DOOKIE_MODEL      "models/dookie/dookie.mdl"
#define DOOKIE_MODEL_DX80 "models/dookie/dookie.dx80.vtx"
#define DOOKIE_MODEL_DX90 "models/dookie/dookie.dx90.vtx"
#define DOOKIE_MODEL_VTX  "models/dookie/dookie.sw.vtx"
#define DOOKIE_MODEL_VVD  "models/dookie/dookie.vvd"
#define DOOKIE_MODEL_VMT  "materials/models/dookie/dookie.vmt"
#define DOOKIE_MODEL_VTF  "materials/models/dookie/dookie.vtf"

// Dookie Mod stats
new Float:playerBodyOrigins[MAXPLAYERS][3];
new playerDookies[MAXPLAYERS];
new playerHeadshotCount[MAXPLAYERS];

public void OnPluginStart()
{
	// Register our dookie commands
	RegConsoleCmd("!dookie", Command_Dookie);
	RegConsoleCmd("!dookie_help", Command_Dookie_Help);
	
	// Hook events
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	HookEvent("round_start", Event_RoundStart, EventHookMode_Pre);
}

public void OnMapStart() 
{
	// Cache files
	PrecacheModel(DOOKIE_MODEL, true);
	PrecacheSound(DOOKIE_SOUND, true);
	PrecacheSound(DOOKIE_SUPER_SOUND, true);
	
	// Set files for download
    AddFileToDownloadsTable(DOOKIE_MODEL);
    AddFileToDownloadsTable(DOOKIE_MODEL_DX80);
    AddFileToDownloadsTable(DOOKIE_MODEL_DX90);
    AddFileToDownloadsTable(DOOKIE_MODEL_VTX);
    AddFileToDownloadsTable(DOOKIE_MODEL_VVD);
    AddFileToDownloadsTable(DOOKIE_MODEL_VMT);
    AddFileToDownloadsTable(DOOKIE_MODEL_VTF);
    AddFileToDownloadsTable(DOOKIE_SOUND_FULL);
    AddFileToDownloadsTable(DOOKIE_SUPER_SOUND_FULL);
}

public Action Command_Dookie_Help(int client, int args)
{
	PrintToChat(client, " ***** CS:GO Dookie Mod Help ***** ", client);
	PrintToChat(client, "Type !dookie in the console. Bind it for easy access.", client);
	PrintToChat(client, "Kills grant dookies, use them near dead players.", client);
	PrintToChat(client, "Three headshots grants an earth shaking superdookie.", client);
 
	return Plugin_Handled;
}

public Action Command_Dookie(int client, int args)
{
	// Check that player using this is alive
	if (!IsPlayerAlive(client))
	{
		// Not Alive, exit
		return Plugin_Handled;
	}
	
	// Player position
    new Float:clientPos[3];
	GetClientAbsOrigin(client, clientPos);

	// Track closest body
	new closestBodyPlayer;
	new Float:closestBodyDist = 9999.0;
	
	// Find nearest player body
	for (new i = 1; i <= MaxClients; i++) 
	{
		// Check they are in-game, real, and dead
        // TODO if (IsClientInGame(i) && !IsFakeClient(i) && !IsPlayerAlive(i)) 
        if (IsClientInGame(i) && !IsPlayerAlive(i)) 
		{
			// Check if it is closer to the player
			new Float:bodyDist = GetVectorDistance(clientPos, playerBodyOrigins[i]);
			if (bodyDist < closestBodyDist)
			{
				closestBodyDist = bodyDist;
				closestBodyPlayer = i;
			}
        }
    }
	
	// Check if the player is near the body
	if (closestBodyDist <= 100.0)
	{
		// Prepare message
		new String:victimName[32];
		GetClientName(closestBodyPlayer, victimName, sizeof(victimName));
		new String:clientName[32];
		GetClientName(client, clientName, sizeof(clientName));
		new String:msg[128];
	
		if (playerHeadshotCount[client] >= 2)
		{
			// Super dookie
			CreateSuperDookie(client, clientPos)
			EmitSoundToAll(DOOKIE_SUPER_SOUND);
			
			// Decrement headshots, so they can't keep using it
			playerHeadshotCount[client] -= 2;
			
			// Print message
			Format(msg, sizeof(msg), "%s just dropped an earth-shaking dookie on %s's dead body!", clientName, victimName);
			PrintToChatAll(msg);
		}
		else
		{
			// Normal dookie
			CreateDookie(client, clientPos);
			EmitSoundToAll(DOOKIE_SOUND);
		
			// Print message
			Format(msg, sizeof(msg), "%s just took a nasty dookie on %s's dead body.", clientName, victimName);
			PrintToChatAll(msg);
		}
		
	}
	else
	{
		PrintToChat(client, "There are no dead players near you.", client);
	}
 
	return Plugin_Handled;
}

public CreateDookie(int client, Float:origin[3])
{
	// Create dookie model
	new entDookieIndex = CreateEntityByName("prop_dynamic");
	if (entDookieIndex != -1 && IsValidEntity(entDookieIndex))
	{
		// Set dookie model values
		DispatchKeyValue(entDookieIndex, "model", DOOKIE_MODEL);
		DispatchKeyValueFloat(entDookieIndex, "solid", 4.0);
		
		// Spawn dookie model
		DispatchSpawn(entDookieIndex);
		TeleportEntity(entDookieIndex, origin, NULL_VECTOR, NULL_VECTOR);
	}
	
	// Add steam sprite
	CreateSteamSprite(origin);
}

public CreateSuperDookie(int client, Float:origin[3])
{
	// Create dookie model and steam
	CreateDookie(client, origin);
	
	// Add shake
	new entShakeIndex = CreateEntityByName("env_shake");
	if (entShakeIndex != -1 && IsValidEntity(entShakeIndex))
	{
		// Set shake values
		DispatchKeyValue(entShakeIndex, "SpawnFlags", "1");
		DispatchKeyValueFloat(entShakeIndex, "Amplitude", 8.0);
		DispatchKeyValueFloat(entShakeIndex, "Radius", 512.0);
		DispatchKeyValueFloat(entShakeIndex, "Duration", 2.0);
		DispatchKeyValueFloat(entShakeIndex, "Frequency", 128.0);
		
		// Spawn shake
		DispatchSpawn(entShakeIndex);
		AcceptEntityInput(entShakeIndex, "StartShake");
		TeleportEntity(entShakeIndex, origin, NULL_VECTOR, NULL_VECTOR);
	}
	
	// Add explosion
	new entExplosionIndex = CreateEntityByName("env_explosion");
	if (entExplosionIndex != -1 && IsValidEntity(entExplosionIndex))
	{
		// Set explosion values
		DispatchKeyValue(entExplosionIndex, "SpawnFlags", "1");
		DispatchKeyValue(entExplosionIndex, "iMagnitude", "1000");
		DispatchKeyValue(entExplosionIndex, "RenderMode", "0");
		
		// Spawn explosion
		DispatchSpawn(entExplosionIndex);
		TeleportEntity(entExplosionIndex, origin, NULL_VECTOR, NULL_VECTOR);
		AcceptEntityInput(entExplosionIndex, "Explode");
	}
}

public CreateSteamSprite(Float:origin[3])
{
	// Add steam sprite
	new entSteamIndex = CreateEntityByName("env_steam");
	if (entSteamIndex != -1 && IsValidEntity(entSteamIndex))
	{
		// Set steam sprite values
		DispatchKeyValue(entSteamIndex, "SpawnFlags", "1");
		DispatchKeyValue(entSteamIndex, "RenderColor", "79 141 57");
		DispatchKeyValue(entSteamIndex, "SpreadSpeed", "1.5");
		DispatchKeyValue(entSteamIndex, "Speed", "3");
		DispatchKeyValue(entSteamIndex, "StartSize", "1");
		DispatchKeyValue(entSteamIndex, "EndSize", "2");
		DispatchKeyValue(entSteamIndex, "Rate", "1");
		DispatchKeyValue(entSteamIndex, "JetLength", "20");
		DispatchKeyValue(entSteamIndex, "RenderAmt", "128");
		DispatchKeyValue(entSteamIndex, "InitialState", "1");
		
		// Spawn steam sprite
		origin[2] += 11.0;
		new Float:angles[3] = {-90.0, 0.0, 0.0};
		DispatchSpawn(entSteamIndex);
		AcceptEntityInput(entSteamIndex, "TurnOn");
		TeleportEntity(entSteamIndex, origin, angles, NULL_VECTOR);
	}
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	// Set death vector
	int victimId = event.GetInt("userid");
	int victim = GetClientOfUserId(victimId);
	GetClientAbsOrigin(victim, playerBodyOrigins[victim]);
	
	// Check if it was a headshot (super dookies come from headshots)
	bool headshot = event.GetBool("headshot");
	if (headshot)
	{
		int attackerId = event.GetInt("attacker");
		int attacker = GetClientOfUserId(attackerId);
		playerHeadshotCount[attacker]++;
	}
	
	return Plugin_Continue;
}

public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	// Clear Dookie Mod stats
	for (new i = 1; i <= MaxClients; i++) 
	{
		// Check they are in-game and real
        // TODO if (IsClientInGame(i) && !IsFakeClient(i)) 
        if (IsClientInGame(i)) 
		{
			// Body position
			playerBodyOrigins[i][0] = 0.0;
			playerBodyOrigins[i][1] = 0.0;
			playerBodyOrigins[i][2] = 0.0;
			
			// Dookies
			playerDookies[i] = 0;
			
			// Headshots
			playerHeadshotCount[i] = 0;
        }
    }
	
	return Plugin_Continue;
}