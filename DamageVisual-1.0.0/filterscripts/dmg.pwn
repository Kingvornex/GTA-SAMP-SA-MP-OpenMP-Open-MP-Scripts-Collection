/*
 *
 *   "DamageVisual"
 *  by [RSAH]SeriouS
 *
*/

#include <a_samp>

#define MAX_SERVER_PLAYERS 20

#define FS_NAME "DamageVisual"
#define FS_VERSION "1.0.0"

#define FADE_TIMER_INTERVAL 110

#define COLOR_LEFT 0x30FF50FF
#define COLOR_RIGHT 0xB00000FF

//#define SHOWN_ON_SCOREBOARD

forward dmgTdUpdate();

#if defined SHOWN_ON_SCOREBOARD
new Float:totalDmg[MAX_SERVER_PLAYERS];
#endif

new
 Text:txd[2][MAX_SERVER_PLAYERS],
 
 txdAlpha[2][MAX_SERVER_PLAYERS],
 Float:currentHpLoss[2][MAX_SERVER_PLAYERS][MAX_SERVER_PLAYERS];

new weaponName[][] =
{
    {"Duke"},
	{"Brass Knuckles"},
	{"Golf Club"},
	{"Nite Stick"},
	{"Knife"},
	{"Baseball"},
	{"Shovel"},
	{"Pool Cue"},
	{"Katana"},
	{"Chainsaw"},
	{"Dildo"},
	{"Dildo"},
	{"Dildo"},
	{"Dildo"},
	{"Flowers"},
	{"Cane"},
	{"Grenade"},
	{"Tear Gas"},
	{"Molotov"},
	{"C4"},
	{""},
	{""},
	{"Pistol"},
	{"Silencer"},
	{"Deagle"},
	{"Shotgun"},
	{"SawnOff"},
	{"Spas12"},
	{"Tec9"},
	{"MP5"},
	{"Ak47"},
	{"M4"},
	{"Tec9"},
	{"Rifle"},
	{"Sniper"},
	{"Rocket Launcher"},
	{"HS Rocket Launcher"},
	{"Flamethrower"},
	{"Minigun"},
	{"C4"},
	{"Detonator"},
	{"Spray"},
	{"Fire Extinguisher"},
	{"Camera"},
	{"Nightvision"},
	{"Infrared Vision"},
	{"Parachute"},
	{"Defuseal Kit"}
};

public OnFilterScriptInit()
{
	createTextDraws();
	SetTimer("dmgTdUpdate", FADE_TIMER_INTERVAL, true);
	
	printf("%s, version %s by [RSAH]SeriouS loaded successfully!", FS_NAME, FS_VERSION);

	return 1;
}

public OnGameModeInit()
{
	createTextDraws();
	SetTimer("dmgTdUpdate", FADE_TIMER_INTERVAL, true);

	return 1;
}

public OnFilterScriptExit()
{
	for(new playerid = 0; playerid < MAX_SERVER_PLAYERS; playerid++)
	{
		TextDrawHideForPlayer(playerid, txd[0][playerid]);
		TextDrawHideForPlayer(playerid, txd[1][playerid]);
	}
	
	printf("%s, version %s by [RSAH]SeriouS unloaded successfully!", FS_NAME, FS_VERSION);
	
	return 1;
}

public OnPlayerConnect(playerid)
{
	#if defined SHOWN_ON_SCOREBOARD
	totalDmg[playerid] = 0.0;
	#endif
	
	for(new i = 0; i < MAX_SERVER_PLAYERS; i++)
	{
		TextDrawHideForPlayer(playerid, txd[0][i]);
		TextDrawHideForPlayer(playerid, txd[1][i]);
	}
	
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	txdAlpha[0][playerid] = 0;
	txdAlpha[1][playerid] = 0;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
{
	#if defined SHOWN_ON_SCOREBOARD
	totalDmg[issuerid] += amount;
	SetPlayerScore(issuerid, floatround(totalDmg[issuerid]));
	#endif
	
	currentHpLoss[0][issuerid][playerid] += amount;
	currentHpLoss[1][playerid][issuerid] += amount;
	
	new
	 nick[MAX_PLAYER_NAME],
	 buffer[128];
	
	GetPlayerName(playerid, nick, MAX_PLAYER_NAME);
	
	format(buffer, 128, "%s~n~-%i (%s)", nick, floatround(currentHpLoss[0][issuerid][playerid]), weaponName[weaponid]);
	TextDrawSetString(txd[0][issuerid], buffer);
	
	GetPlayerName(issuerid, nick, MAX_PLAYER_NAME);
	
	format(buffer, 128, "%s~n~-%i (%s)", nick, floatround(currentHpLoss[1][playerid][issuerid]), weaponName[weaponid]);
	TextDrawSetString(txd[1][playerid], buffer);
	
	txdAlpha[0][issuerid] = 0xFF;
	txdAlpha[1][playerid] = 0xFF;

	return 1;
}

public dmgTdUpdate()
{
	for(new playerid = 0; playerid < MAX_SERVER_PLAYERS; playerid++)
	{
		if(!IsPlayerConnected(playerid)) continue;
		
		if(txdAlpha[0][playerid] > 0)
		{
			TextDrawColor(txd[0][playerid], setAlpha(COLOR_LEFT, txdAlpha[0][playerid]));
			TextDrawBackgroundColor(txd[0][playerid], setAlpha(0x000000FF, txdAlpha[0][playerid] / 0x6));
			
			TextDrawShowForPlayer(playerid, txd[0][playerid]);
			
			txdAlpha[0][playerid] -= 0x6;
		}
		else if(txdAlpha[0][playerid] < 0)
		{
			TextDrawHideForPlayer(playerid, txd[0][playerid]);
			txdAlpha[0][playerid] = 0;
			
			for(new a = 0; a < MAX_SERVER_PLAYERS; a++)
				currentHpLoss[0][playerid][a] = 0.0;
		}
		
		if(txdAlpha[1][playerid] > 0)
		{
			TextDrawColor(txd[1][playerid], setAlpha(COLOR_RIGHT, txdAlpha[1][playerid]));
			TextDrawBackgroundColor(txd[1][playerid], setAlpha(0x000000FF, txdAlpha[1][playerid] / 0x6));
			
			TextDrawShowForPlayer(playerid, txd[1][playerid]);
			
			txdAlpha[1][playerid] -= 0x6;
		}
		else if(txdAlpha[1][playerid] < 0)
		{
			TextDrawHideForPlayer(playerid, txd[1][playerid]);
			txdAlpha[1][playerid] = 0;
			
			for(new a = 0; playerid < MAX_SERVER_PLAYERS; a++)
				currentHpLoss[1][playerid][a] = 0.0;
		}
	}
}

setAlpha(color, a)
{
	return (((color >> 24) & 0xFF) << 24 | ((color >> 16) & 0xFF) << 16 | ((color >> 8) & 0xFF) << 8 | floatround((float(color & 0xFF) / 255) * a));
}

createTextDraws()
{
	for(new playerid = 0; playerid < MAX_SERVER_PLAYERS; playerid++)
	{
		txd[0][playerid] = TextDrawCreate(200.0, 370.0, " ");
		TextDrawLetterSize(txd[0][playerid], 0.24, 1.1);
		TextDrawColor(txd[0][playerid], COLOR_LEFT);
		TextDrawFont(txd[0][playerid], 1);
		TextDrawSetShadow(txd[0][playerid], 0);
		TextDrawAlignment(txd[0][playerid], 2);
		TextDrawSetOutline(txd[0][playerid], 1);
		TextDrawBackgroundColor(txd[0][playerid], 0x0000000F);
		
		txd[1][playerid] = TextDrawCreate(440.0, 370.0, " ");
		TextDrawLetterSize(txd[1][playerid], 0.24, 1.1);
		TextDrawColor(txd[1][playerid], COLOR_RIGHT);
		TextDrawFont(txd[1][playerid], 1);
		TextDrawSetShadow(txd[1][playerid], 0);
		TextDrawAlignment(txd[1][playerid], 2);
		TextDrawSetOutline(txd[1][playerid], 1);
		TextDrawBackgroundColor(txd[1][playerid], 0x0000000F);
	}
}