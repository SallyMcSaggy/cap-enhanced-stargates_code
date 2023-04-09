local iristbl = {"stargate/iris/hit.mp3", "stargate/iris/hit_2.mp3", "stargate/iris/hit_3.mp3", "stargate/iris/hit_4.mp3"}

hook.Add("EntityEmitSound", "iris", function(t)
	if (t.OriginalSoundName == "stargate/iris_hit.mp3") then
 		t.SoundName = table.Random(iristbl)
		return true
	else
 		return
	end
end)
