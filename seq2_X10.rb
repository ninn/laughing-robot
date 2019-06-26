use_random_seed 1

use_debug false

### midi-parameter
midi_port = "dj_tech_dj_for_all"
midi_connection_note = "/midi/dj_tech_dj_for_all/*/*/note_on"
midi_connection_cc = "/midi/dj_tech_dj_for_all/*/*/control_change"
midi_channel = 1

# glob
set :_JOGFACTOR, 3 # just here. local.



# f config
_jogfactor = get(:_JOGFACTOR)
_bpmramp = get(:_BPMRAMP)
_noteramp = get(:_NOTERAMP)
_filterrange = get(:_filterRange)
_sustrange = get(:_sustRange)
_detunerange = get(:_detuneRange)
_divrange = get(:_divRange)
_SCALES =  get(:_SCALES)
_wheel = get(:_wheel)

DRUM_1=25
DRUM_2=21
DRUM_3=17
DRUM_4=13

DRUM_5=14
DRUM_6=10
DRUM_7=6
DRUM_8=2

KNOB_MAIN_CCW=49
KNOB_MAIN_CW=48
KNOB_MAIN=16

BUTTON_LOAD_R=12
BUTTON_LOAD_L=20

# JOG
JOG_R_CCW=53
JOG_R_CW=52
JOG_R_STOP=54

JOG_L_CCW=56
JOG_L_CW=55
JOG_L_STOP=57

## F0r Note
# Rotary
KNOB_MASTER = 42

KNOB_L_HI = 36
KNOB_L_MED = 38
KNOB_L_LOW = 40

KNOB_R_HI = 37
KNOB_R_MED = 39
KNOB_R_LOW = 41

# clicks
KNOB_L_HI_click = 80
KNOB_L_MED_click = 82
KNOB_L_LOW_click = 84

KNOB_R_HI_click = 81
KNOB_R_MED_click = 83
KNOB_R_LOW_click = 85

BUTTON_PFL_L = 24
BUTTON_PFL_R = 8

FADER_A = 33
FADER_B = 34
FADER_DJ = 35

SHIFT_L = 28
SHIFT_R = 4

# nice buttons
LED_SYNC_L = 27
LED_SYNC_R = 3
LED_CUE_L = 26
LED_CUE_R = 22
LED_PLAY_L = 5
LED_PLAY_R = 1

# nice buttons
BUTTON_SYNC_L = 27
BUTTON_SYNC_R = 3
BUTTON_CUE_L = 26
BUTTON_CUE_R = 22
BUTTON_PLAY_L = 5
BUTTON_PLAY_R = 1

# round buttons big
LED_SEARCH = 19
LED_SCRATCH = 15
LED_EFFECT = 11

BUTTON_CENTER1 = 19
BUTTON_CENTER2 = 15
BUTTON_CENTER3 = 11


SWITCH_SAMPLE_L = 65
SWITCH_CUE_L = 67
SWITCH_LOOP_L = 66

SWITCH_SAMPLE_R = 69
SWITCH_CUE_R = 70
SWITCH_LOOP_R = 71

### abge

#counters for dials
shift_L_count = 0
shift_R_count = 0

jog_L_count = 0
jog_R_count = 0

knob_main_count = 24   # note richtig startet.
knob_main_pushcount = 0

#load_L_count = 0
# load_R_count = 0

PLF_A_count = 0
PLF_B_count = 0

buttondown = 127


SYNC_L_count = 0
CUE_L_count = 0
PLAY_L_count = 0

define :SetMainNote do  |value|
  knob_main_count += value
  set :Master_Note, _noteramp[knob_main_count]
  puts "MASTER-Note: " +  note_info(_noteramp[knob_main_count]).to_s
  cue :TonUpdate
end

define :SETSEQ do   |seq|
  set seq, 127-get(seq)
  cue :SeqUpdate
end


define :AddDist do  |setter,distancer|
  set setter, get(setter) +distancer
  cue :TonUpdate
end


live_loop :DJKarlRealtime do
  use_real_time
  n,v = sync  midi_connection_cc
  n,v = get  midi_connection_cc
  
  
  v100 = (v.to_f/127).round(2)
  vRange =_filterrange[v]
  vSust =_sustrange[v]
  vde =_detunerange[v]
  vdiv = _divrange[v]
  
  SHIFTR = get(:SHIFT_R_ON)
  SHIFTL = get(:SHIFT_L_ON)
  
  LOADR = get(:LOAD_R_ON)
  LOADL = get(:LOAD_L_ON)
  
  case n
  when KNOB_MASTER
    set :bpm,  _bpmramp[v].round()
    puts "MasterSpeed: " +get(:bpm).to_s + "bpm"
    
  when KNOB_L_HI
    puts "-L1-CUTOFF: " + vRange.to_s
    set :knob_L_Hi, v
    (set :cutoff_L1 , vRange) if !SHIFTL && !LOADL
    (set :sustain_L1, vSust) if SHIFTL && !LOADL
    (set :LEADNr, v) if LOADL
    
  when KNOB_L_MED
    set :knob_L_Med, v
    
    (puts "L2-cuttoff: " + vRange.to_s ;set :cutoff_L2 ,vRange) if !SHIFTL && !SHIFTR && !LOADL
    (puts "L2-sustain: " + vSust.to_s ;set :sustain_L2, vSust) if SHIFTL && !LOADL
    (set :detune_L2, vde) if SHIFTR && !LOADL
    (set :PADNr, v) if LOADL
    
  when KNOB_L_LOW
    set :knob_L_Low, v
    (set :cutoff_L3 , vRange) if !SHIFTL && !SHIFTR && !LOADL
    (set :sustain_L3, vSust) if SHIFTL && !LOADL
    (puts "L3-sust: " + vdiv.to_s; set :div_L3, vdiv) if SHIFTR && !LOADL
    (set :BASSNr, v) if LOADL
    
  when KNOB_R_HI
    set :knob_R_Hi, v # changes with cutoff, no use!
    puts "MasterR1-CUTOFF: " + vRange.to_s
    (set :cutoff_R1 , vRange) if !SHIFTL
    (set :sustain_R1, v) if SHIFTL # not usy v
  when KNOB_R_MED
    set :knob_R_Med, v
    # puts "R2-CUTOFF: " + vRange.to_s;
    (set :cutoff_R2 , vRange) if !SHIFTL
    (set :sustain_R2, v) if SHIFTL
  when KNOB_R_LOW
    set :knob_R_Low, v
    puts "R3-sust " + vSust.to_s
    (set :cutoff_R3 , vRange) if !SHIFTL
    (set :sustain_R3, v) if SHIFTL
    
  when FADER_A  # dotn set pure midi values in set - not needed
    puts "MasterVolume-1: " + v100.to_s
    set :midilautstaerke_1 , v
    set :lautstaerke_1 , v100
  when FADER_B
    puts "MasterVolume-2: " + v100.to_s
    set :lautstaerke_2 , v100
  when FADER_DJ
    set :fader_DJ, v
    set :faderRandom, v
    puts "MasterFader: " + v.to_s
    set :direction , v
    cue :UpdatePath
    
  end
  
end

live_loop :DJNoraNote do
  use_real_time
  n,v = sync midi_connection_note
  n,v = get midi_connection_note
  
  
  modeLOOP = (get(:mode)==:mode_LOOP)
  modeTON = (get(:mode)==:mode_TON)
  modeSAMPLE = get(:mode)==:mode_SAMPLE
  
  bd = (v==127)
  
  bdLOOP = bd && modeLOOP
  bdTONE = bd && modeTON
  bdSAMPLE = bd && modeSAMPLE
  
  
  case n
  when KNOB_MAIN_CW
    SetMainNote +1
  when KNOB_MAIN_CCW
    SetMainNote -1
  when KNOB_MAIN
    # SetMainNote 0
    if bd then
      knob_main_pushcount  += 1;
      set :userScaleType, _SCALES[knob_main_pushcount]
      puts "SELECTED Scale type: " + _SCALES[knob_main_pushcount].to_s
      
      cue :TonUpdate
    end
    
  when BUTTON_PFL_L
    # (PLF_A_count += 1 ; set :SynthInstument , get(:InstumenteSynth)[PLF_A_count]; set :BASSNr, PLF_A_count) if bd
    # puts "M-PLF-A:  " +  get(:InstumenteSynth)[PLF_A_count].to_s  # not needed
  when BUTTON_PFL_R
    (PLF_B_count += 1 ; set :hiHatInstument , PLF_B_count ;  ) if bd
    # puts "M-PLF-B: " +  get(:Instumente)[PLF_B_count].to_s  # not needed
    
    
  when BUTTON_SYNC_L
    #(SYNC_L_count += 1 ; set :LEADNr, SYNC_L_count) if bd
  when BUTTON_CUE_L
    #(CUE_L_count += 1 ; set :PADNr, CUE_L_count) if bd
  when BUTTON_PLAY_L
    #(PLAY_L_count += 1 ; set :BASSNr, PLAY_L_count) if bd
    
  when DRUM_1
    set :DRUM_1_ON, v # speichern da gedrueckt
    SETSEQ :seq1  if bdLOOP
    (puts "TRIGGERSTEP" ; TRIGGER 1 , v ) if modeSample
    #(play :C3 ) if modeSample
    
  when DRUM_2
    set :DRUM_2_ON, v
    TRIGGER 2 , v  if modeSAMPLE
    SETSEQ :seq2  if bdLOOP
  when DRUM_3
    set :DRUM_3_ON, v
    TRIGGER 3 , v  if modeSAMPLE
    SETSEQ :seq3  if bdLOOP
  when DRUM_4
    set :DRUM_4_ON, v
    TRIGGER 4 , v  if modeSAMPLE
    SETSEQ :seq4  if bdLOOP
  when DRUM_5
    TRIGGER 5 , v  if modeSAMPLE
    set :DRUM_5_ON, v
    SETSEQ :seq5  if bdLOOP
  when DRUM_6
    TRIGGER 6 , v  if modeSAMPLE
    set :DRUM_6_ON, v
    SETSEQ :seq6  if bdLOOP
  when DRUM_7
    TRIGGER 7 , v  if modeSAMPLE
    set :DRUM_7_ON, v
    SETSEQ :seq7  if bdLOOP
  when DRUM_8
    TRIGGER 8 , v  if modeSAMPLE
    set :DRUM_8_ON, v
    SETSEQ :seq8  if bdLOOP
    
  when JOG_L_CW
    jog_L_count += 1
  when JOG_L_CCW
    jog_L_count -= 1
  when JOG_L_STOP # quasi
    if bd then
      jog_L_count = -0.5 # fair start +/-
    else
      distance = (jog_L_count / _jogfactor).to_i
      #puts "JOG-Relativ: " + distance.to_s
      quater = (distance.to_f / 12.0).to_i
      if modeSAMPLE and quater !=0 then
        
        set :_pathidea, get(:_pathidea).add("L"+ quater.to_i.to_s)
        puts "** L quater: " +quater.to_s + " to " + get(:_pathidea).to_s  #
      end
      if modeTON then
        # puts " add distance to note ============"
        (AddDist :sound_L_1, distance) if get(:DRUM_1_ON)>0
        (AddDist :sound_L_2, distance) if get(:DRUM_2_ON)>0
        (AddDist :sound_L_3, distance) if get(:DRUM_3_ON)>0
        (AddDist :sound_L_4, distance) if get(:DRUM_4_ON)>0
        (AddDist :sound_L_5, distance) if get(:DRUM_5_ON)>0
        (AddDist :sound_L_6, distance) if get(:DRUM_6_ON)>0
        (AddDist :sound_L_7, distance) if get(:DRUM_7_ON)>0
        (AddDist :sound_L_8, distance) if get(:DRUM_8_ON)>0
      end
      jog_L_count = 0   # REALLY NEEDED?! set back
    end
  when JOG_R_CW
    jog_R_count += 1
  when JOG_R_CCW
    jog_R_count -= 1
  when JOG_R_STOP
    if bd then
      jog_R_count = -0.5
    else
      distance = (jog_R_count / _jogfactor).to_i
      quater = (distance.to_f / 12.0).to_i
      if modeSAMPLE and quater !=0 then
        set :_pathidea, get(:_pathidea).add("R" +quater.to_i.to_s)
        puts "** R quater: " +quater.to_s + " to " + get(:_pathidea).to_s  #
      end
      jog_R_count = 0
    end
    
  when SHIFT_L
    set :SHIFT_L_ON, bd
  when SHIFT_R
    set :SHIFT_R_ON, bd
  when BUTTON_LOAD_R
    set :LOAD_R_ON, bd
  when BUTTON_LOAD_L
    set :LOAD_L_ON, bd
    
  when SWITCH_SAMPLE_L
    set :mode,  :mode_SAMPLE
  when SWITCH_CUE_L
    set :mode, :mode_TON
  when SWITCH_LOOP_L
    set :mode, :mode_LOOP
    
  when SWITCH_SAMPLE_R
  when SWITCH_CUE_R
  when SWITCH_LOOP_R
    
    
  when BUTTON_CENTER2
    (set :aktionTON, :shuffle; cue :TonUpdate) if bdTONE
    (set :aktionSEQ, :shuffle; cue :SeqUpdate) if bdLOOP
    (set :_pathidea, (ring "L1","R1")) if bdSAMPLE
  when BUTTON_CENTER1 # save
    (set :aktionTON, :save; cue :TonUpdate) if bdTONE
    (set :aktionSEQ, :save; cue :SeqUpdate ) if bdLOOP
    (set :_pathidea_saved, get(:_pathidea)) if bdSAMPLE
  when BUTTON_CENTER3 # recall
    (set :aktionTON, :restore; cue :TonUpdate) if bdTONE
    (set :aktionSEQ, :restore; cue :SeqUpdate) if bdLOOP
    (set :_pathidea, get(:_pathidea_saved)) if bdSAMPLE
  end
end
