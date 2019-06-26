#          expanded from
#          Inside by Otto van Zanten
#


kickInstruments = (ring (ring :bd_haus), (ring :bd_klub))
kickInstrument = kickInstruments[0]


snareInstruments = (ring (ring :drum_snare_hard))
snareInstrument = snareInstruments[0]


hihatInstruments = (ring (ring  :perc_bell, :perc_bell2), (ring  :perc_snap, :perc_snap2), (ring  :misc_crow, :perc_snap2))
hihatInstruments = hihatInstruments + (ring  (ring :mehackit_robot2, :mehackit_robot4), (ring :elec_blip, :elec_blip2),(ring :elec_plip, :elec_blup),(ring :elec_ping, :elec_beep))
hihatInstruments = hihatInstruments + (ring (ring :glitch_robot1, :glitch_robot2),(ring  :elec_pop, :elec_bong), (ring :elec_triangle, :elec_snare),  (ring :drum_cowbell, :elec_bell), (ring :drum_cymbal_soft, :drum_cymbal_hard))
# (ring :glitch_bass_g, :glitch_perc1),
# (ring :perc_impact1, :perc_impact2), (ring :vinyl_scratch, :vinyl_backspin), (ring :perc_swoosh, :perc_till),
hihatInstrument = hihatInstruments[0]

DrumPan = 1

# BPM
# 8th notes         |1   2   3   4   5   6   7   8  |1   2   3   4   5   6   7   8  |
kick_rhythm  = (ring 1,0,0,0)
kick_rhythm  = (ring 1,0,0,0,1,0,0,0,1,0,1,0,1,0,0,0,1,0,0,0,1,0,1,1,0,0,1,1,1,0,0,0)          # Kick Sequencer
snare_rhythm = (ring 0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0)          # Snare Sequencer
hh_rhythm    = (ring 1,0,1,0,1,0,1,0,1,0,1,1,1,0,2,0,1,0,1,0,1,0,1,1,1,0,1,1,1,0,2,0)          # HiHats (1=closed, 2=open)

#snare_rhythm = (ring 0)          # Snare Sequencer
#hh_rhythm    = (ring 0)          # HiHats (1=closed, 2=open)




ringing = ring( (spread 2, 5),
                (spread 3, 4),
                (spread 3, 5),
                (spread 3, 7),
                (spread 3, 8),
                (spread 4, 7),
                (spread 4, 9),
                (spread 4, 11),
                (spread 5, 6),
                (spread 5, 7),
                (spread 5, 8),
                (spread 5, 9),
                (spread 5, 11),
                (spread 5, 12),
                (spread 5, 16),
                (spread 7, 8),
                (spread 7, 12),
                (spread 7, 16),
                (spread 9, 16),
                (spread 11, 24),
                (spread 13, 24))

live_loop :SequencerRobertDrumKickSlave, sync: :Sequencer  do
  
  sync :SeqDrum
  # stop
  kickInstrument = kickInstruments[0] # .reverse
  snareInstrument = snareInstruments[0] # .reverse
  hihatInstrument = hihatInstruments[get(:hiHatInstument)]#.reverse
  
  # spreaderring = (ring 1,2,3,4,5,6,7,7,9,9,11,11,11,11,11,11).stretch(8)
  # spreader1 = spreaderring[get(:sustain_R1).to_i]
  # spreader2 = spreaderring[get(:sustain_R2).to_i]
  # #spreader3 = spreaderring[get(:sustain_R3).to_i]
  #sample kickInstrument[0], pan: -1, amp: 1
  
  
  #puts "spreader": + spreader1.to_s + " ring: " + spreaderring.to_s
  #kick_spread = (spread spreader1,11)
  #snare_spread = (spread spreader2,9)
  
  runner = tick
  
  mixer = get(:lautstaerke_2)
  lautramp = ramp(0,0.25,0.5,0.75,1,1,1,1).stretch(16)
  
  
  lautstarke1 = lautramp[get(:knob_R_Hi)] * mixer # :cutoff_R1
  
  if lautstarke1 > 0 then
    cutoff1 =  get(:cutoff_R1)
    if (kick_rhythm[runner] == 1)  then
      sample kickInstrument[0], pan: DrumPan, amp: lautstarke1, cutoff: cutoff1
    end
  end
  
  
  
  lautstarke2 = lautramp[get(:knob_R_Med)] * mixer
  if lautstarke2 > 0 then
    
    cutoff2 =  get(:cutoff_R2)
    if snare_rhythm[runner] == 1 then
      sample snareInstrument[0], pan: DrumPan, amp: lautstarke2, cutoff: cutoff2
    end
  end
  
  
  
  lautstarke3 = lautramp[get(:knob_R_Low)] * mixer
  if lautstarke3 > 0 then
    cutoff3 =  get(:cutoff_R3)
    #puts "hihat:" + hihatInstrument[0].to_s
    if hh_rhythm[look] == 1 then
      sample hihatInstrument[0], pan: DrumPan, amp: lautstarke3 * rrand(0.4,1) , cutoff: cutoff3
    elsif hh_rhythm[look] == 2
      sample hihatInstrument[1], pan: DrumPan,  amp: lautstarke3 , cutoff: cutoff3
    end
    
  end
  
  
end


live_loop :MultiBeat, sync: :Sequencer  do
  
  sync :SequencerHit
  stop
  kickInstrument = kickInstruments[0] # .reverse
  snareInstrument = snareInstruments[0] # .reverse
  hihatInstrument1 = hihatInstrument[0]#.reverse
  hihatInstrument2 = hihatInstrument[1]#.reverse
  
  use_random_seed get(:fader_DJ).to_i
  8.times do
    c = rrand(70, 130)
    
    n = (scale :e1, :minor_pentatonic).take(3).choose
    #  synth :tb303, note: n, release: 0.1, cutoff: c if rand < 0.9
    
    sample snareInstrument if one_in(6)
    sample hihatInstrument1 if one_in(2)
    sample hihatInstrument2 if one_in(3)
    
    sample kickInstrument, amp: 1.5 if one_in(4)
    sleep 0.250
  end
end


live_loop :DrumKickSlave, sync: :Sequencer  do
  sync :SeqDrumKick
  
  
end

live_loop :DrumSnareSlave, sync: :Sequencer  do
  sync :SeqDrumSnare
  
  
end

live_loop :DrumHatSlave, sync: :Sequencer  do
  sync :SeqDrumHat
  
  
end