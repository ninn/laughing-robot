# MIDI SEQUENCER PART
#SEQUENER-TEILE

set_sched_ahead_time! 1

use_debug false

SynthPan = 1




#filter_lfo = get(:_filter_lfo1)
halfbpm = get(:_8thOffbpm)
filteroff = get(:_filterOff)



live_loop :SynthMaster, sync: :Sequencer do
  sync "/cue/SeqUpdate"
  bpmmer = get(:bpm)
  use_bpm bpmmer
  #puts "use_bpm" + bpmmer.to_s
  
  # wow!
  # set :Instrument1OFF , !get(:Instrument1OFF)
  puts "======= FRESH " + get(:InstrumentLEAD)[get(:LEADNr)].to_s + "LEAD ==========="
  ton = get(:userScale)[0]
  # set :SynLEAD, (synth get(:InstrumentLEAD)[get(:LEADNr)],  note: ton,  pan: SynthPan, release: 0, sustain: 1.98, decay: 0.01, attack_level: 1, sustain_level: 1, note_slide: 0.01, amp_slide: 0.01, amp: 0 )
  set :SynLEAD, (synth get(:InstrumentLEAD)[get(:LEADNr)],  note: ton,  pan: SynthPan, release: 0, sustain: 1.98, decay: 0.01, attack_level: 1, sustain_level: 1, note_slide: 0.0, amp_slide: 0.0, amp: 0 )
  
end

live_loop :SynthBASSMaster, sync: :Sequencer do
  sync "/cue/SeqUpdate"
  bpmmer = get(:bpm)
  use_bpm bpmmer
  puts "use_bpm" + bpmmer.to_s
  
  puts "======= FRESH " + get(:InstrumentBASS)[get(:BASSNr)].to_s + " BASS ==========="
  
  ton =  get(:userScale)[0]-12
  
  set :SynBASS, (synth get(:InstrumentBASS)[get(:BASSNr)],  note: ton,  pan: SynthPan, release: 0, sustain: 3.95 , decay: 0.05, attack_level: 1, sustain_level: 1, note_slide: 0.00, amp_slide: 0.00, amp: 0 )
  sleep  3.9
end




live_loop :SynthLEAD ,  sync: :Sequencer  do
  #stop
  sync "/cue/SequencerHit"
  
  use_bpm get(:bpm)
  
  runner = get(:runner)
  ton = get(:ton)
  
  tonsequenz = get(:tonsequenz)
  tonleiter = get(:standard_scale)
  sequenz = get(:sequenz)
  
  lautstaerke = get(:lautstaerke_1) # * 3
  sustain = get(:sustain_L1)
  cutoff_synth = get(:cutoff_L1)
  if cutoff_synth<filteroff then
    lautstaerke = 0
  end
  
  
  
  
  cutoff_kick = get(:cutoff_L3)
  
  if ton!=:NOSOUND  then
    
    
    #time_warp 0 do
    # midi ton , 127 , port:"monologue_sound"
    
    # use_synth
    #puts "LEADer: " +  get(:InstrumentLEAD)[get(:LEADNr)].to_s
    
    
    
    control get(:SynLEAD) , note: ton , pan: SynthPan , amp: lautstaerke , cutoff:cutoff_synth
  else
    control get(:SynLEAD)  , amp: lautstaerke * 0.01 , cutoff:cutoff_synth
  end
  
  
  
end



#Anything under 100 bpm, I generally use 8th notes. Anything faster, I use quarters.
live_loop :SynthARP, sync: :Sequencer  do
  
  #stop
  sync "/cue/SeqDrum"
  
  
  bpmer = get(:bpm)
  use_bpm = bpmer
  
  runner = get(:runner) # ???
  tonsequenz = get(:tonsequenz)  # ???
  tonleiter = get(:standard_scale)
  sequenz = get(:sequenz)
  
  #puts "HEY"
  
  #sustain = get(:sustain_L2) / 3
  sustain = 0.1
  
  
  
  #  use_bpm get(:bpm)
  #  detune = 0.1
  if get(:ton) != :NOSOUND then
    ton = get(:ton) +12
  else
    ton = get(:userScale)[0]+12
    
  end
  
  
  mixer = 1 #2
  
  
  lautstaerke = get(:lautstaerke_1) * mixer
  cutoff_synth = get(:cutoff_L2)
  detune = get(:detune_L2)
  #if one_in) then
  if cutoff_synth<filteroff then
    lautstaerke = 0
  else
    if ton!=:NOSOUND  then
      #  midi ton , filter_lfo[tick]  , port:"HELM" , channel: 10
      #midi ton , 127 , port:"monologue_sound"
      
      use_synth  get(:InstrumentPAD)[get(:PADNr)]
      
      if bpmer > 50
        chooser = :chordi
      else
        chooser = :chordi # :arpi
      end
      
      case chooser
      when :playi
        play  note: ton, pan: SynthPan, release:  sustain, amp: lautstaerke , cutoff:cutoff_synth
        
      when :chordi
        play chord(ton, :major),  pan: SynthPan , release:  sustain*4, amp: lautstaerke , cutoff:cutoff_synth
        #puts "CHORDS: " +   get(:InstrumentPAD)[get(:PADNr)].to_s
      when :arpi
        play_pattern_timed  chord(ton, :major).stretch(2),  0.125 /4  , pan: SynthPan , release: sustain, amp: lautstaerke , cutoff:cutoff_synth
        puts "arpi: " +   chord(ton, :major).shuffle.to_s
      end
      
    end
    
  end
  #end
end



live_loop :SynthBASS ,  sync: :Sequencer  do
  #stop
  sync "/cue/seqBASS"
  
  
  bpmer = get(:bpm)
  use_bpm  bpmer
  runner = get(:runner)
  
  ton = get(:tonBASS) -12
  if ton != :NOSOUND then
    ton = ton -12
  end
  
  tonOrig = get(:ton)
  if tonOrig != :NOSOUND then
    tonOrig = tonOrig -12
  end
  
  tonMaster = get(:userScale)[0]-12
  
  
  mixer = 1
  
  sustain =  0.3 #for arpi
  lautstaerke = get(:lautstaerke_1) * mixer
  
  cutoff_synth = get(:cutoff_L3)
  div = get(:div_L3)
  div = 1
  
  #if one_in(3) then
  if cutoff_synth<filteroff then
    lautstaerke = 0
  else
    if ton != :NOSOUND then
      
      cutoff_synth = get(:cutoff_L3)
      
      if bpmer > 70
        chooser = :playi
      else
        chooser = :playi # :chordi
      end
      
      case chooser
      when :playi
        # puts "BASS: " +   get(:InstrumentBASS)[get(:BASSNr)].to_s + ": " + chord(ton, :major).shuffle.count.to_s
        
        control get(:SynBASS) , note: ton , amp: lautstaerke ,cutoff:cutoff_synth
        
        if bpmer < 70
          sleep 0.1
          control get(:SynBASS) , note: tonMaster , amp: lautstaerke ,cutoff:cutoff_synth
        else
          sleep 0.1
          # puts "hey!"
          control get(:SynBASS) , note: tonMaster , amp: lautstaerke ,cutoff:cutoff_synth
          
        end
      when :chordi
        puts "BASS: " +   get(:InstrumentBASS)[get(:BASSNr)].to_s + ": " + chord(ton, :major).shuffle.count.to_s
        
        #play chord(ton, :major),  pan:1 , release:  sustain*4, amp: lautstaerke , cutoff:cutoff_synth
        
      when :arpi
        play_pattern_timed  chord(ton, :major),  0.125 / 3, pan: SynthPan , release:  sustain, amp: lautstaerke , cutoff:cutoff_synth
        
      end
    else
      control get(:SynBASS) , note: tonMaster , amp: lautstaerke ,cutoff:cutoff_synth
      
    end
    
    
    
  end
  sleep 0.3  # *
  #end
end

