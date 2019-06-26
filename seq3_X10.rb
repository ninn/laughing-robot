# sequencer
# NO SYNTH

use_debug false
### midi-parameter
midi_port = "dj_tech_dj_for_all"
midi_connection_note = "/midi/dj_tech_dj_for_all/*/*/note_on"
midi_connection_cc = "/midi/dj_tech_dj_for_all/*/*/control_change"
midi_channel = 1



# midi leds local.
_leds = (ring 25,21,17,13,14,10,6,2)

_SCALES =  get(:_SCALES)
_NUMOCTS =  get(:userNumOcts)

define :RanTon do  |setter|
  #puts (get(:fader_DJ).to_f / 128.0).round(2).to_s
  set setter, (rand_i( ( get(:userScale).length ) * (get(:faderRandom).to_f / 128.0).round(2)).to_i )
end

define :RanSeq do  |setter|
  set setter, rrand_i(0,1)*127
end


define :RTLed do  |led,bstate|
  if bstate == true then
    midi_note_on  led, 127 , port: midi_port , channel: midi_channel
  else
    midi_note_on  led, 0 , port: midi_port , channel: midi_channel
  end
end

define :RTBlink do  |button,state|
  in_thread do
    if (state>0) then
      midi_note_on button, 127,  port: midi_port , channel: midi_channel
    else
      midi_note_on button, 0 , port: midi_port , channel: midi_channel
    end
    
    sleep rt(0.02) # 0.02 visibe
    
    if (state>0) then
      midi_note_on button, 0 , port: midi_port , channel: midi_channel
    else
      midi_note_on button, 127, port: midi_port , channel: midi_channel
    end
    
  end
end


#live_loop :SequencerHEART do
#
#  bpmmer = get(:bpm).to_i
#  use_bpm bpmmer
#
#  cue :SeqCLOCK, tick
#  sleep 0.25
#end


# THE MAIN HEART
live_loop :Sequencer do #,  sync: :SequencerHEART  do
  
  #  n = sync :SeqCLOCK
  
  
  bpmmer = get(:bpm).to_i
  use_bpm bpmmer
  
  # get :runner, get( :SeqCLOCK )
  
  sequenz = get(:sequenz)       # braucht man beides
  tonsequenz = get(:tonsequenz) # braucht nur sequencer
  pfadKEYS = get(:PathKEYS)
  pfadBASS = get(:PathBASS)
  
  #in_thread do
  
  
  8.times do
    set :runner, tick
    
    runner = look
    
    step = pfadKEYS[runner].to_i
    set :step, step
    
    
    
    
    # puts "(" +runner.to_s + ") : Schritt " + step.to_s + ", Ton: " + tonsequenz[step].to_s
    
    if sequenz[pfadKEYS[runner]]>0 then
      #puts "TREFFER, ton " + tonsequenz[step].to_s  + " auf step " + step.to_s
      set :ton, get(:userScale)[tonsequenz[pfadKEYS[runner]]]
      
      
      # if get(:TRIGDRUM)[1].to_i > 0 then
      #   puts get(:TRIGDRUM)[0].to_s + ": " + get(:TRIGDRUM)[1].to_s + " > 0 then"
      #   set :ton, get(:userScale)[tonsequenz[get(:TRIGDRUM)[0]]]
      # end
      
      
      
    else
      # no sound
      set :ton, :NOSOUND
    end
    
    
    # if sequenz[pfadBASS[runner]]>0 then
    set :tonBASS, get(:userScale)[tonsequenz[pfadBASS[runner]]]
    cue :seqBASS
    #  else
    # no sound
    # set :tonBASS, :NOSOUND
    # cue :seqBASS
    #  end
    
    
    cue :SequencerHit
    cue :SeqDrum
    sleep 0.1250
    (cue :SeqDrum ; cue :seqBASS) if bpmmer < 90 #magic
    sleep 0.1250
    
  end
  #end
  
  #sleep 2
  cue :SeqUpdate
  cue :TonUpdate
  cue :PathUpdate
end




live_loop :Visu ,  sync: :Sequencer  do
  sync "/cue/SequencerHit"
  
  STEP = get(:step)
  sequenz = get(:sequenz)       # braucht man beides
  
  # puts "groesser 0? " +  sequenz[STEP].to_s + " - blinke: " + sequenz[STEP].to_s + " auf led" +  _leds[STEP].to_s
  if sequenz[STEP] > 0 then
    RTBlink _leds[STEP], 0
  else
    RTBlink _leds[STEP], 127
  end
  
end


live_loop :SequenzUpdateDienst, sync: :Sequencer do
  sync "/cue/SeqUpdate"
  
  puts "====== Updating Sequence ====="
  
  aktionSEQ = get(:aktionSEQ)
  if aktionSEQ!= :none then
    case aktionSEQ
    when :save
      set :save_sequenz,  get(:sequenz)
      puts "saved SEQ sequence: " +  get(:save_sequenz).to_s
    when :shuffle
      puts "Random note sequenz served"
      RanSeq :seq1
      RanSeq :seq2
      RanSeq :seq3
      RanSeq :seq4
      RanSeq :seq5
      RanSeq :seq6
      RanSeq :seq7
      RanSeq :seq8
      
    when :restore
      oldSequenz = get(:save_sequenz)
      set :sequenz, oldSequenz
      
      set :seq1, oldSequenz[0]
      set :seq2, oldSequenz[1]
      set :seq3, oldSequenz[2]
      set :seq4, oldSequenz[3]
      set :seq5, oldSequenz[4]
      set :seq6, oldSequenz[5]
      set :seq7, oldSequenz[6]
      set :seq8, oldSequenz[7]
    end
    set :aktionSEQ, :none
  end
  
  
  set :sequenz, (ring get(:seq1),get(:seq2),get(:seq3),get(:seq4),get(:seq5),get(:seq6),get(:seq7),get(:seq8))
  
  
end


live_loop :TONUpdater , sync: :Sequencer  do
  sync "/cue/TonUpdate" #,   "/cue/SeqUpdate"
  puts "================== TON UPDATE! ==============="
  
  # ? immer ?
  set :userScale, scale(get(:Master_Note), get(:userScaleType), num_octaves: _NUMOCTS)
  
  aktionTON = get(:aktionTON)
  if aktionTON= :none then
    
    case get(:aktionTON)
    when :save
      set :save_tonsequenz,  get(:tonsequenz)
      puts "saved note-sequence: " +  get(:save_tonsequenz).to_s
      set :aktionTON, :none
      
    when :shuffle
      puts "SERVED Random note sequenz served"
      
      RanTon :sound_L_1
      RanTon :sound_L_2
      RanTon :sound_L_3
      RanTon :sound_L_4
      RanTon :sound_L_5
      RanTon :sound_L_6
      RanTon :sound_L_7
      RanTon :sound_L_8
      
    when :restore
      savedTS = get(:save_tonsequenz)
      set :tonsequenz,  savedTS
      puts "restored sequence: " +  savedTS.to_s
      set :sound_L_1, savedTS[0]
      set :sound_L_2, savedTS[1]
      set :sound_L_3, savedTS[2]
      set :sound_L_4, savedTS[3]
      set :sound_L_5, savedTS[4]
      set :sound_L_6, savedTS[5]
      set :sound_L_7, savedTS[6]
      set :sound_L_8, savedTS[7]
    end
    set :aktionTON, :none
    
  end
  
  set :tonsequenz, (ring get(:sound_L_1),get(:sound_L_2),get(:sound_L_3),get(:sound_L_4),get(:sound_L_5),get(:sound_L_6),get(:sound_L_7),get(:sound_L_8))
  #puts get(:tonsequenz).to_s
  
end
