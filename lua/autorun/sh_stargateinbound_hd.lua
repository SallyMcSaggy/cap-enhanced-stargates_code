local stargatesgincomingtbl = {"stargate/sg1/chevron_incoming.mp3", "stargate/sg1/chevron_incoming_2.mp3", "stargate/sg1/chevron_incoming_3.mp3", "stargate/sg1/chevron_incoming_4.mp3", "stargate/sg1/chevron_incoming_5.mp3", "stargate/sg1/chevron_incoming_6.mp3", "stargate/sg1/chevron_incoming_7.mp3"}

hook.Add("EntityEmitSound", "stargateincomingsg", function(t)
	if (t.OriginalSoundName == "stargate/chevron_incoming.mp3") then
 		t.SoundName = table.Random(stargatesgincomingtbl)
		return true
	else
 		return
	end
end)
