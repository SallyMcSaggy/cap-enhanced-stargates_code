local jumperenginesgtbl = {"kripalida/jumper/jumperengineloop_hd.wav"}

hook.Add("EntityEmitSound", "jumperengine", function(t)
	if (t.OriginalSoundName == "jumper/jumperengineloop.wav") then
 		t.SoundName = table.Random(jumperenginesgtbl)
		return true
	else
 		return
	end
end)
