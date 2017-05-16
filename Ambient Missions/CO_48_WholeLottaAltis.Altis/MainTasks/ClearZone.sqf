
_ranZ = VEHZONES call RETURNRANDOM;
while {getmarkercolor _ranZ != "ColorRed" || {surfaceisWater (getmarkerpos _ranZ)}} do {sleep 1;_ranZ = VEHZONES call RETURNRANDOM;};
_locat = getmarkerpos _ranZ;

_Tid = format ["TaskOff%1",NUMM];

NUMM=NUMM+1;
_Lna = _locat CALL NEARESTLOCATIONNAME;
_header = format ["Clear CSAT Movement near %1",_Lna];
_desc =("CSAT have recently more and more vehicles appearing to patrol over this marker area. I want all red zones cleared from that 2km radius area in 60 minutes.");
[
WEST, // Task owner(s)
_Tid, // Task ID (used when setting task state, destination or description later)
[_desc, _header, _header], // Task description
_locat, // Task destination
"CREATED" // true to set task as current upon creation
] call BIS_fnc_taskCreate;

_mar = format ["TTmar%1",NUMM];
NUMM=NUMM+1;
_marker = createMarker [_mar,_locat];
_marker setMarkerShape "ELLIPSE";
_marker setMarkerSize [2000, 2000];
_marker setMarkerColor "ColorRed";
_marker setMarkerBrush "BORDER";

_st = [_locat, 1200,"(1 - trees) * (1 - sea) * (1 - houses)"] CALL FUNKTIO_POS;
_star = (_st select 0) select 0;
_classs = ARMEDVEHICLES select 1;
_classs = [_classs call RETURNRANDOM,_classs call RETURNRANDOM];
_n = [_star, "ColorRed",_classs] CALL AddVehicleZone;
_st = [_locat, 1200,"(1 - trees) * (1 - sea) * (1 - houses)"] CALL FUNKTIO_POS;
_star = (_st select 0) select 0;
_classs = ARMEDVEHICLES select 1;
_classs = [_classs call RETURNRANDOM,_classs call RETURNRANDOM];
_n = [_star, "ColorRed",_classs] CALL AddVehicleZone;
_st = [_locat, 1200,"(1 - trees) * (1 - sea) * (1 - houses)"] CALL FUNKTIO_POS;
_star = (_st select 0) select 0;
_classs = ARMEDVEHICLES select 1;
_classs = [_classs call RETURNRANDOM,_classs call RETURNRANDOM];
_n = [_star, "ColorRed",_classs] CALL AddVehicleZone;

_mark = [];
{if (getmarkerpos _x distance _locat < 2000) then {_mark = _mark + [_x];};} foreach VEHZONES;
_aika = (60*60) + time;
waitUntil {sleep 10; _aika < time || {{_x in AllMapMarkers && {getmarkercolor _x == "ColorRed"} && {getmarkerpos _x distance _locat < 2000} && {!surfaceisWater (getmarkerpos _x)}} count _mark == 0}};
if (_aika < time) then {
_nul = [_Tid,"FAILED"] call BIS_fnc_taskSetState;
} else {
_nul = [_Tid,"SUCCEEDED"] call BIS_fnc_taskSetState;
[_locat,WEST] SPAWN ADDR;
_n = [WEST,1000] SPAWN PrestigeUpdate;
[[1000, "Enemy Zone Cleared",WEST],"PRESTIGECHANGE",nil,false] spawn BIS_fnc_MP;
};
sleep 60;
_n = [_Tid] CALL BIS_fnc_deleteTask;
deletemarker _marker;
