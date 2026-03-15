state("CONSTANCE") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "Constance";	

	string[] tears = {
		"whyanemptyline",
		"Foundry",
		"Vaults",
		"Academy",
		"Carnival"
	};
	
	string[] abilities = {
		"whyanemptyline",
		"Brush",
		"Dash",
		"Stab",
		"Wall Dive",
		"Slice",
		"Bomb Clone",
		"Pogo",
		"Double Jump"
	};
	
	string[] keyItems = {
		"whyanemptyline",
		"Frida Mask"
	};
	
	//string[] misc = {
	//	"Transition (Any)"
	//};
	
	settings.Add("tears", true, "Split when obtaining a tear.");
	for (int i = 1; i < tears.Length; i++) {
		settings.Add("tear" + i, true, tears[i], "tears");
	}
	
	settings.Add("abilities", true, "Split when obtaining an ability.");
	for (int i = 1; i < abilities.Length; i++) {
		settings.Add("ability" + i, true, abilities[i], "abilities");
	}
	
	settings.Add("keyItems", true, "Split when obtaining a key item.");
	for (int i = 1; i < keyItems.Length; i++) {
		settings.Add("keyitem" + i, true, keyItems[i], "keyItems");
	}
	
	//settings.Add("misc", false, "Split on other events.");
	//for (int i = 1; i < misc.Length; i++) {
	//	settings.Add("misc" + i, false, misc[i], "misc");
	//}
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>) (mono => {
		var crm = mono["Constance.Core", "ConRuntimeMetrics"];
		vars.Helper["speedrunTime"] = mono.Make<long>(crm, "SpeedrunTime");
		vars.Helper["gameStarted"] = mono.Make<int>(crm, "_gameStarted");
		vars.Helper["unlocks"] = mono.Make<long>(crm, "Unlocks");
		//vars.Helper["currentLevel] = mono.Make<string>(crm, "CurrentLevel"); // What is the correct way to get this?
		
		var ctt = mono["Constance.Core", "ConTimeTicker"];
        vars.Helper["speedrunCompleted"] = mono.Make<bool>(ctt, "_speedrunCompleted");
		
        return true;
    });
}

start
{
	return current.gameStarted == 1 && old.gameStarted != 1;
}

split
{
	var unlocked = current.unlocks ^ old.unlocks;
	
	return
		(settings["ability2"] && unlocked == 0x0001) | // Dash			1
		(settings["ability3"] && unlocked == 0x0002) | // Stab			2
		(settings["ability1"] && unlocked == 0x0004) | // Brush			4
		(settings["ability5"] && unlocked == 0x0008) | // Slice			8
		(settings["ability4"] && unlocked == 0x0010) | // Wall Dive		16
		(settings["ability7"] && unlocked == 0x0020) | // Double Jump	32
		(settings["ability7"] && unlocked == 0x0040) | // Pogo			64
		(settings["ability6"] && unlocked == 0x0080) | // Bomb Clone	128
		(settings["keyitem1"] && unlocked == 0x0400) | // Frida Mask	1024
		(settings["tear1"]    && unlocked == 0x1000) | // Tear Foundry	4096
		(settings["tear3"]    && unlocked == 0x2000) | // Tear Academy	8192
		(settings["tear2"]    && unlocked == 0x4000) | // Tear Vaults	16384
		(settings["tear4"]    && unlocked == 0x8000) | // Tear Carnival	32768
		//settings["Transition (Any)"] && current.currentLevel != old.currentLevel |
		current.speedrunCompleted;

	//return current.speedrunCompleted;
}

gameTime
{
	return TimeSpan.FromMilliseconds(current.speedrunTime);
}

isLoading
{
	return true;
}