#if defined Sho_Credits

					!---------------------------------------------------!
					!___________________________________________________!
					!                                   SSSS            !
					!   SSSSS  SS  SS   SSSS    SSSS   SS  SS SS     SS !
					!  SS  SS  SS  SS  SS  SS  SS  SS  SS  SS SS    SS  !
					! SS       SS  SS  SS  SS  SS  SS  SS SS   SS  SS   !
					! SS       SSSSSS  SS  SS  SS  SS  SSSS     SSSS    !
					!  SSSSSS  SS  SS  SS  SS  SS  SS  SS SS     SS     !
					!      SS  SS  SS  SS  SS  SS  SS  SS  SS    SS     !
					! SS  SS   SS  SS  SS  SS  SS  SS  SS  SS   SS      !
					! SSSSS    SS  SS   SSSS    SSSS   SSSSS   SSSS     !
					!___________________________________________________!
	 				!                                                   !
					!---------------------------------------------------!


                                    <-  ShoScripts™  ->
					  		      ______________________
					 		     | * Version - 1.2      |
								 | * Author - ShOoBy	|
								 | * Lines - 184        |
								 | * Time Spent - 4h    |
								 | * Mode - Snowballs   |
								 | * Variables - 5      |
								 | * Objects - 20       |
								 | * Script - Unique!   |
							     ========================
#endif

#include <a_samp>

#define KEY_AIM (128)

new Snow_F[MAX_PLAYERS];
new Obj[MAX_PLAYERS];
new Shoot[MAX_PLAYERS];
new Killer[MAX_PLAYERS];
new Charged[MAX_PLAYERS];

#define FILTERSCRIPT

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	CreateObject(8172,-716.59997559,3800.50000000,8.50000000,0.00000000,0.00000000,90.00000000); //object(vgssairportland07) (1)
	CreateObject(3074,-782.29998779,3785.30004883,8.50000000,0.00000000,270.00000000,269.99948120); //object(d9_runway) (6)
	CreateObject(3074,-782.29998779,3798.89990234,8.50000000,0.00000000,270.00000000,269.99450684); //object(d9_runway) (7)
	CreateObject(3074,-782.29998779,3807.60009766,8.50000000,0.00000000,270.00000000,269.99450684); //object(d9_runway) (8)
	CreateObject(3074,-752.09997559,3807.60009766,8.50000000,0.00000000,270.00000000,269.99450684); //object(d9_runway) (9)
	CreateObject(3074,-722.00000000,3807.50000000,8.50000000,0.00000000,270.00000000,269.99450684); //object(d9_runway) (10)
	CreateObject(3074,-691.79998779,3807.50000000,8.50000000,0.00000000,270.00000000,269.99450684); //object(d9_runway) (11)
	CreateObject(3074,-661.59997559,3807.50000000,8.50000000,0.00000000,270.00000000,269.99450684); //object(d9_runway) (12)
	CreateObject(3074,-753.79998779,3795.19995117,8.60000038,0.00000000,270.00000000,269.99450684); //object(d9_runway) (14)
	CreateObject(3074,-723.59997559,3795.10009766,8.60000038,0.00000000,270.00000000,269.99450684); //object(d9_runway) (15)
	CreateObject(3074,-693.40002441,3794.89990234,8.60000038,0.00000000,270.00000000,269.99450684); //object(d9_runway) (16)
	CreateObject(3074,-664.09997559,3794.69995117,8.60000038,0.00000000,270.00000000,269.99450684); //object(d9_runway) (17)
	CreateObject(3074,-664.29998779,3781.69995117,8.69999981,0.00000000,270.00000000,269.99450684); //object(d9_runway) (18)
	CreateObject(3074,-694.50000000,3781.80004883,8.69999981,0.00000000,270.00000000,269.99450684); //object(d9_runway) (19)
	CreateObject(3074,-724.40002441,3781.89990234,8.69999981,0.00000000,270.00000000,269.99450684); //object(d9_runway) (20)
	CreateObject(3074,-754.40002441,3782.00000000,8.69999981,0.00000000,270.00000000,269.99450684); //object(d9_runway) (21)
	CreateObject(8172,-796.79998779,3800.50000000,-48.00000000,90.00000000,0.00000000,90.00000000); //object(vgssairportland07) (2)
	CreateObject(8172,-650.20001221,3800.50000000,-48.00000000,90.00000000,180.00000000,90.00000000); //object(vgssairportland07) (3)
	CreateObject(8172,-729.09997559,3780.69995117,12.80000019,0.00000000,270.00000000,270.00000000); //object(vgssairportland07) (4)
	CreateObject(8172,-726.20001221,3820.19995117,12.80000019,0.00000000,270.00000000,90.00000000); //object(vgssairportland07) (5)
	return 1;
}

#else

main()
{
	print("\n     ShoScripts © 2006 - 2011        ");
	print("       SnowBalls Fight Minigame        ");
	print("              by ShOoBy ™            \n");
}

#endif

public OnPlayerConnect(playerid)
{
	Snow_F[playerid] = 0;
	Killer[playerid] = 501;
	Charged[playerid] = 0;
	Shoot[playerid] = 0;
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(Snow_F[playerid] == 1) return Snow_F[playerid] = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
    DestroyObject(Obj[playerid]);
    if(Killer[playerid] != 501) {
	Shoot[Killer[playerid]] = 0;
	Killer[playerid] = 501;
    }
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/snow", cmdtext, true, 10) == 0)
	{
	if(Snow_F[playerid] == 0) {
	Snow_F[playerid] = 1;
	Charged[playerid] = 0;
	Shoot[playerid] = 0;
	SetPlayerPos(playerid,-708.40002441,3796.19995117,9.69999981);
	new res22[500], iName[128];
	GetPlayerName(playerid,iName,sizeof(iName));
	format(res22,sizeof(res22),"{0088FF}Hey {FF0000}%s{0088FF}!\nYou've just started playing {15FF00}SnowBall Fight{0088FF} minigame.\nIn this minigame , your goal is to hit as many players,\nas you can , without being hit by them.\nTo throw an snowball press : {FF7B0F}AIM Key\n{FFFF0F}Good Luck! ",iName);
	ShowPlayerDialog(playerid,9944,DIALOG_STYLE_MSGBOX,"{FF0000}SnowBalls {FFFF00}Fight",res22,"Ok","");
	}
	else if(Snow_F[playerid] == 1) {
	Snow_F[playerid] = 0;
	SpawnPlayer(playerid);
	}
	return 1;
	}
	return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(Snow_F[playerid] == 1) {
	if(Shoot[playerid] == 0) {
	if(newkeys & KEY_AIM) {
	if(Charged[playerid] == 1) return CheckSnow(playerid);
	else if(Charged[playerid] == 0) return ApplyAnimation( playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0 ), Charged[playerid] = 1;
	}
	}
	}
	return 1;
}

forward CheckSnow(playerid);
public CheckSnow(playerid)
{
	Shoot[playerid] = 0;
	for(new i = 0; i < 30; i++) {
	new Float:X, Float:Y;
	GetXYInFrontOfPlayer(playerid,X,Y,i);
    for(new z = 0; z < MAX_PLAYERS;  z++) {
	if(z != playerid && Shoot[playerid] == 0 && Killer[z] == 501) {
	if(IsPlayerInRangeOfPoint(z,1.0,X,Y,9.69999981)) {
	Shoot[playerid] = 1;
	new Float:pX,Float:pY,Float:pZ,Float:tX,Float:tY,Float:tZ;
	GetPlayerPos(playerid,pX,pY,pZ);
	GetPlayerPos(z,tX,tY,tZ);
	Obj[z] = CreateObject(2709,pX,pY,pZ+0.5,0.0,0.0,0.0,30);
	MoveObject(Obj[z],tX,tY,tZ-0.9,25.0);
	SetPlayerHealth(z,0);
	Killer[z] = playerid;
	GameTextForPlayer(playerid,"~R~Target ~y~Shoot~B~!~N~~G~+ 500 ~p~Cash",1000,3);
	GivePlayerMoney(playerid,500);
	Charged[playerid] = 0;
    ApplyAnimation(playerid,"GRENADE","WEAPON_throw",4.1,0,1,1,0,1000,1);
	}
	}
	}
	}
	if(Shoot[playerid] == 0) GameTextForPlayer(playerid,"~R~NO ~G~Targets~B~!",1000,1);
	return 1;
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid))
    {
      GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}
