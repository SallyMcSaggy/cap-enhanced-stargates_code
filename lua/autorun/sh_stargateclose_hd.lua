local stargateclosetbl = {"junko_enoshima/gate_close_hd_1.mp3", "junko_enoshima/gate_close_hd_2.mp3"}

hook.Add("EntityEmitSound", "stargateclosesg", function(t)
	if (t.OriginalSoundName == "junko_enoshima/gate_close_hd_2.mp3") then
 		t.SoundName = table.Random(stargateclosetbl)
		return true
	else
 		return
	end
end)
