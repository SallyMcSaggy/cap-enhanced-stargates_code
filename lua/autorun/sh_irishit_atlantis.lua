local irisattbl = {"stargate/shield/hit.mp3", "stargate/shield/hit_2.mp3"}

hook.Add("EntityEmitSound", "irisat", function(t)
	if (t.OriginalSoundName == "stargate/iris_atlantis_hit.mp3") then
 		t.SoundName = table.Random(irisattbl)
		return true
	else
 		return
	end
end)
