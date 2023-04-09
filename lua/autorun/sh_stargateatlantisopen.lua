local sgatlopbl = {"junko_enoshima/sga_hd/open_atlantis_hd.mp3", "stargate/atlantis/open.mp3"}

hook.Add("EntityEmitSound", "sgatlopsg", function(t)
	if (t.OriginalSoundName == "stargate/atlantis/open.mp3") then
 		t.SoundName = table.Random(sgatlopbl)
		return true
	else
 		return
	end
end)
