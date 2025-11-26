state("CONSTANCE") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "Constance";	
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>) (mono => {
		var crm = mono["Constance.Core", "ConRuntimeMetrics"];
		vars.Helper["speedrunTime"] = mono.Make<long>(crm, "SpeedrunTime");
		vars.Helper["gameStarted"] = mono.Make<int>(crm, "_gameStarted");
		//vars.Helper["unlocks"] = mono.Make<int>(crm, "Unlocks");
		
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
	return current.speedrunCompleted;
}

gameTime
{
	return TimeSpan.FromMilliseconds(current.speedrunTime);
}

isLoading
{
	return true;
}