local jumperhoversgtbl = {"kripalida/jumper/jumperhoverloop_hd.wav"}

hook.Add("EntityEmitSound", "jumperhover", function(t)
	if (t.OriginalSoundName == "jumper/jumperhoverloop.wav") then
 		t.SoundName = table.Random(jumperhoversgtbl)
		return true
	else
 		return
	end
end)
