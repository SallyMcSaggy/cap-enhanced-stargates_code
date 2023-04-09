local irisatopentbl = {"stargate/shield/open.mp3"}

hook.Add("EntityEmitSound", "irisatopen", function(t)
	if (t.OriginalSoundName == "stargate/iris_atlantis_open.mp3") then
 		t.SoundName = table.Random(irisatopentbl)
		return true
	else
 		return
	end
end)
