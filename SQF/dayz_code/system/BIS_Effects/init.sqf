BIS_Effects_Init = true; //A2 won't overwrite this if var is not nil
/* BIS_Effects_* fixes from Dwarden */
diag_log "Res3tting B!S effects...";
BIS_Effects_EH_Fired=compile preprocessFileLineNumbers "\z\addons\dayz_code\system\BIS_Effects\fired.sqf"; // Allows tanks to use smoke counter measures
BIS_Effects_EH_Killed = compile preprocessFileLineNumbers "\z\addons\dayz_code\system\BIS_Effects\killed.sqf";
BIS_Effects_Rifle = {false};
BIS_Effects_Cannon=compile preprocessFileLineNumbers "\ca\Data\ParticleEffects\SCRIPTS\muzzle\cannon.sqf";
BIS_Effects_HeavyCaliber=compile preprocessFileLineNumbers "\ca\Data\ParticleEffects\SCRIPTS\muzzle\heavycaliber.sqf";
BIS_Effects_HeavySniper=compile preprocessFileLineNumbers "\ca\Data\ParticleEffects\SCRIPTS\muzzle\heavysniper.sqf";
BIS_Effects_Rocket=compile preprocessFileLineNumbers "\ca\Data\ParticleEffects\SCRIPTS\muzzle\rocket.sqf";
BIS_Effects_SmokeShell=compile preprocessFileLineNumbers "\ca\Data\ParticleEffects\SCRIPTS\muzzle\smokeshell.sqf";
BIS_Effects_SmokeLauncher=compile preprocessFileLineNumbers "\ca\Data\ParticleEffects\SCRIPTS\muzzle\smokelauncher.sqf";
BIS_Effects_Flares=compile preprocessFileLineNumbers "\ca\Data\ParticleEffects\SCRIPTS\muzzle\flares.sqf";
BIS_Effects_Burn=compile preprocessFileLineNumbers "\ca\Data\ParticleEffects\SCRIPTS\destruction\burn.sqf";
BIS_Effects_AircraftVapour=compile preprocessFileLineNumbers "\ca\Data\ParticleEffects\SCRIPTS\misc\aircraftvapour.sqf";
BIS_Effects_AirDestruction = compile preprocessFileLineNumbers "\z\addons\dayz_code\system\BIS_Effects\AirDestruction.sqf";
BIS_Effects_AirDestructionStage2 = compile preprocessFileLineNumbers "\z\addons\dayz_code\system\BIS_Effects\AirDestructionStage2.sqf";
BIS_Effects_Secondaries = compile preprocessFileLineNumbers "\z\addons\dayz_code\system\BIS_Effects\secondaries.sqf";
BIS_Effects_globalEvent = {
	BIS_effects_gepv = _this;
	publicVariable "BIS_effects_gepv";
	_this call BIS_Effects_startEvent;
	
};
BIS_Effects_startEvent = {
	private "_KillEject";
	_KillEject = {
		private "_cancel";
		if (((vehicle player) == (_this select 0)) && {(vehicle player) != player} && {player in (crew (_This select 0))}) then {
			_cancel = false;
			{
				if ((isInTraderCity || !canbuild) && {(player distance (_x select 0)) < (_x select 1)}) then {_cancel = true;};
			} count DZE_SafeZonePosArray;
			player action ["getOut", (_this select 0)];
			if (!_cancel && {!((_this select 0) iskindof "car")}) then {
				[player, "explosion"] spawn player_death;
			};
		};
	};
	switch (_this select 0) do {
		case "AirDestruction": {
				[_this select 1] spawn BIS_Effects_AirDestruction;
				[_This select 1] call _KillEject;
		};
		case "AirDestructionStage2": {
				[_this select 1, _this select 2, _this select 3] spawn BIS_Effects_AirDestructionStage2;
		};
		case "Burn": {
				[_this select 1, _this select 2, _this select 3, false, true] spawn BIS_Effects_Burn;
		};
		case "Eject": {
			[_This select 1] call _KillEject;
		};
	};
};
"BIS_effects_gepv" addPublicVariableEventHandler {
	(_this select 1) call BIS_Effects_startEvent;
};