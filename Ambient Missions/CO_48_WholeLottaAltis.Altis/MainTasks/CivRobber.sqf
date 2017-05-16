
private ["_Tside","_killer","_nul","_n","_Tide","_locat","_Lna","_header","_desc","_side","_aika"];
_TidE = format ["TaskThiefK%1",NUMM];
NUMM=NUMM+1;
_locat = (getposATL (_this select 0));
_Lna = _locat CALL NEARESTLOCATIONNAME;
if ((_Lna+"T") in TaskBlackList) exitWith {};
TaskBlackList = TaskBlackList + [(_Lna+"T")];
_header = format ["Hunt Thief near %1",_Lna];
_desc =("We have reports of enemy soldier (player) robbing civilians. Search the site and take down the possible thief. It would bring us prestige boost if you happen to take down the right guy before he move away");
_side = side (_this select 0);
_Tside = WEST;
if (_side == WEST) then {_Tside = EAST;};
[
_Tside, // Task owner(s)
_TidE, // Task ID (used when setting task state, destination or description later)
[_desc, _header, _header], // Task description
_locat, // Task destination
"CREATED" // true to set task as current upon creation
] call BIS_fnc_taskCreate;
_aika = time + 700;
_killer = (_this select 0);
waitUntil {sleep 5; _aika < time || {!alive _killer && {_locat distance _killer < 2000}} || {_locat distance _killer > 2000}}; 
if (!alive _killer && {_locat distance _killer < 2000} && {{_x distance _killer < 1000} count ([_Tside] CALL AllPf)}) then {
_nul = [_TidE,"SUCCEEDED"] call BIS_fnc_taskSetState;
[getposATL _killer,_Tside] SPAWN ADDR;
_n = [_Tside,400] SPAWN PrestigeUpdate;
[[400, "Thief Killed",_Tside],"PRESTIGECHANGE",nil,false] spawn BIS_fnc_MP;
} else {
_nul = [_TidE,"FAILED"] call BIS_fnc_taskSetState;
};
sleep 60;
_n = [_TidE] CALL BIS_fnc_deleteTask;
TaskBlackList = TaskBlackList - [(_Lna+"T")];