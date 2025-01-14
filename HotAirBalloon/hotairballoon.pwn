//---------------------------------------------------------//
//FilterScript------Hot-Air-Balloon------By-adri1----------//
//                                                         //
//		    ----> New objects of cessil <----              //
//                 adri223@hotmail.es                      //
//                                                         //
/////////////////////////////////////////////////////////////

#include <a_samp>
new Balloon;
new Fire,Fire1;
new TimerBalloon;
forward MoveBalloon(playerid);
#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	//Main
	Balloon = CreateObject(19335, 836.08, -2000.51, 13.60,   0.00, 0.00, 0.00);
	//Fires
	Fire = CreateObject(18692, 0,0,0,   0.00, 0.00, 0.00);
	Fire1 = CreateObject(18692, 0,0,0,   0.00, 0.00, 0.00);
	//Strings
	CreateObject(19087, 834.98, -1999.36, 13.88,   27.00, 31.00, 5.00);
	CreateObject(19087, 837.26, -1999.36, 13.88,   27.00, -31.00, 5.00);
	CreateObject(19087, 837.28, -2001.70, 13.88,   -27.00, -31.00, 5.00);
	CreateObject(19087, 834.90, -2001.70, 13.88,   -27.00, 31.00, 5.00);
	//Others
	CreateObject(1448, 833.81, -1998.54, 12.00,   0.00, 0.00, 0.00);
	CreateObject(1448, 838.36, -1998.36, 12.00,   0.00, 0.00, 0.00);
	CreateObject(1448, 838.34, -2002.53, 12.00,   0.00, 0.00, 0.00);
	CreateObject(1448, 833.84, -2002.77, 12.00,   0.00, 0.00, 0.00);
	CreateObject(1468, 836.25, -2003.40, 13.20,   0.00, 0.00, 0.00);
	CreateObject(1468, 839.03, -2000.36, 13.20,   0.00, 0.00, 90.00);
	CreateObject(1468, 833.14, -2000.68, 13.20,   0.00, 0.00, -90.00);
	CreateObject(3361, 836.17, -1994.27, 12.40,   0.00, 0.00, 90.00);
	return 1;
}
#else

main()
{
	print("\n----------------------------------");
	print("		Hot-Air-Balloon by adri1");
	print("----------------------------------\n");
}

#endif
public OnPlayerConnect(playerid)
{
	AttachObjectToObject(Fire, Balloon, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 1);
    AttachObjectToObject(Fire1, Balloon, 0.0, 0.0, 4.0, 0.0, 0.0, 0.0, 1);
    return 1;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/launch", cmdtext, true, 10) == 0)
	{
		TimerBalloon = SetTimer("MoveBalloon",1,1);
		return 1;
	}
	if (strcmp("/return", cmdtext, true, 10) == 0)
	{
	    KillTimer(TimerBalloon);
		DestroyObject(Balloon);
		DestroyObject(Fire);
		DestroyObject(Fire1);
		Balloon = CreateObject(19335, 836.08, -2000.51, 13.60,   0.00, 0.00, 0.00);
		Fire = CreateObject(18692, 0,0,0,   0.00, 0.00, 0.00);
		Fire1 = CreateObject(18692, 0,0,0,   0.00, 0.00, 0.00);
		AttachObjectToObject(Fire, Balloon, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 1);
	    AttachObjectToObject(Fire1, Balloon, 0.0, 0.0, 4.0, 0.0, 0.0, 0.0, 1);
		return 1;
	}
	if (strcmp("/tele", cmdtext, true, 10) == 0)
	{
	    SetPlayerPos(playerid,834.964,-2040.216,12.867);
	    return 1;
	}
	return 0;
}
public MoveBalloon(playerid)
{
	new Float:X,Float:Y,Float:Z;
	GetObjectPos(Balloon,X,Y,Z);
	if(X == 836.08 && Y == -2000.51 && Z == 13.60)//1
	{
		MoveObject(Balloon,836.08, -2000.51, 30.0000,3.0);
	}
	if(X == 836.08 && Y == -2000.51 && Z == 30.0000)//1
	{
		MoveObject(Balloon,1532.9523, -2151.1907, 340.0000,3.0);
	}
	if(X == 1532.9523 && Y == -2151.1907 && Z == 340.0000)//1
	{
		MoveObject(Balloon,1096.7158, -1808.5215, 80.0000,10.0);
	}
	if(X == 1096.7158 && Y == -1808.5215 && Z == 80.0000)//1
	{
		MoveObject(Balloon,836.08, -2000.51, 13.60,5.0);
		KillTimer(TimerBalloon);
	}
	return 1;
}
//---------------------------------------------------------//
//FilterScript------Hot-Air-Balloon------By-adri1----------//
//                                                         //
//		    ----> New objects of cessil <----              //
//                 adri223@hotmail.es                      //
//                                                         //
/////////////////////////////////////////////////////////////
