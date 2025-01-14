#include <a_samp>

#if defined MAX_PLAYERS
	#undef MAX_PLAYERS
	#define MAX_PLAYERS 50 //Change 50 to the max slots your server has.
#endif

enum pInfo
{
	Float:lHP,
	bool:Wounded,
	SecondTick
}
new PlayerInfo[MAX_PLAYERS][pInfo];
new Text:BloodScreen;

forward HealthCheck();

public OnFilterScriptInit()
{
	print("\n [     Wounds System by Krx17 Loaded     ]");

	LoadBloodScreen();
	SetupPlayerVariables();
	SetTimer("HealthCheck", 1000, 1);
	return 1;
}

public OnFilterScriptExit()
{
	UnloadBloodScreen();
	return 1;
}

public OnPlayerConnect(playerid)
{
	ResetPlayerVariable(playerid);
}

stock LoadBloodScreen()
{
	BloodScreen = TextDrawCreate(0.0, 1.0, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
	TextDrawBackgroundColor(BloodScreen, 0x000000FF);
	TextDrawFont(BloodScreen, 1);
	TextDrawLetterSize(BloodScreen, 1.24, 5.0);
	TextDrawColor(BloodScreen, 0xFFFFFFFF);
	TextDrawSetOutline(BloodScreen, 0);
	TextDrawSetProportional(BloodScreen, true);
	TextDrawSetShadow(BloodScreen, 1);
	TextDrawUseBox(BloodScreen, true);
	TextDrawBoxColor(BloodScreen, 0xFF000044);
	TextDrawTextSize(BloodScreen, 642.0, 0.0);
}

stock UnloadBloodScreen()
{
	TextDrawDestroy(BloodScreen);
}

stock SetupPlayerVariables()
{
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && !IsPlayerNPC(i))
	{
	    GetPlayerHealth(i, PlayerInfo[i][lHP]);
	}
}

stock ResetPlayerVariable(playerid)
{
	PlayerInfo[playerid][lHP] = 100;
	PlayerInfo[playerid][Wounded] = false;
	PlayerInfo[playerid][SecondTick] = 0;
}

stock OnPlayerHurt(playerid, Float:damage, Float:newHP)
{
	if(newHP > 0)
	{
	    if(damage > 10 && PlayerInfo[playerid][Wounded] == false)
	    {
	        PlayerInfo[playerid][Wounded] = true;
	        SendClientMessage(playerid, 0xFF0000AA, ">> Wounded!");
			PlayerInfo[playerid][SecondTick] = 0;
			CallRemoteFunction("OnPlayerWoundUpdate", "ii", playerid, 1);
	    }
	}
}

public HealthCheck()
{
	new Float:HP;
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && !IsPlayerNPC(i))
	{
		GetPlayerHealth(i, HP);
		if(PlayerInfo[i][lHP] > HP)
		{
		    OnPlayerHurt(i, PlayerInfo[i][lHP]-HP, HP);
		}
		if(PlayerInfo[i][Wounded] == true)
		{
		    PlayerInfo[i][SecondTick]++;
		    if(PlayerInfo[i][SecondTick] % 10 == 0)
		    {
		        if(PlayerInfo[i][SecondTick] >= 40)
				{
			        PlayerInfo[i][Wounded] = false;
					PlayerInfo[i][SecondTick] = 0;
		        	TextDrawHideForPlayer(i, BloodScreen);
					CallRemoteFunction("OnPlayerWoundUpdate", "ii", i, 0);
					SendClientMessage(i, 0x00FF00AA, ">> Wounds healed");
		        	continue;
		        }
		        TextDrawShowForPlayer(i, BloodScreen);
		        SetPlayerHealth(i, HP-3);
		    }
		    else if(PlayerInfo[i][SecondTick] % 11 == 0)
		    {
		        TextDrawHideForPlayer(i, BloodScreen);
		    }
		}
		PlayerInfo[i][lHP] = HP;
	}
}

