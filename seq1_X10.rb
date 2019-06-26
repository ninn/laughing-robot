e# RESET! SICHER?!
use_debug false

set :detune_L2, 0.0





######### START-VALUES with first Start
# DER BEAT!!!!!

if get(:bpm) == nil then
  
  set :bpm, 15
  
  
  set :seq1 , 127 # sequenz 1
  set :seq2 , 127
  set :seq3 , 127
  set :seq4 , 127
  set :seq5 , 127 # sequenz 2
  set :seq6 , 127
  set :seq7 , 127
  set :seq8 , 127
  
  
  set :sequenz, (ring get(:seq1),get(:seq2),get(:seq3),get(:seq4),get(:seq5),get(:seq6),get(:seq7),get(:seq8))
  set :save_sequenz, get(:sequenz)
  
  set :sound_L_1, 0
  set :sound_L_2, 1
  set :sound_L_3, 2
  set :sound_L_4, 3
  set :sound_L_5, 4
  set :sound_L_6, 5
  set :sound_L_7, 6
  set :sound_L_8, 7
  
  set :tonsequenz, (ring get(:sound_L_1),get(:sound_L_2),get(:sound_L_3),get(:sound_L_4),get(:sound_L_5),get(:sound_L_6),get(:sound_L_7),get(:sound_L_8))
  set :save_tonsequenz, (ring get(:sound_L_1),get(:sound_L_2),get(:sound_L_3),get(:sound_L_4),get(:sound_L_5),get(:sound_L_6),get(:sound_L_7),get(:sound_L_8))
  
  
  set :_pathidea, (ring "L1","R1")
  set :PathKEYS, (ring 0) # wäah aber cool
  set :PathBASS,(ring 0)
end
# das brauchen wir immer
if true then
  set :Instumente, (ring (ring  :perc_bell,  :perc_bell2), (ring  :perc_snap,  :perc_snap2), (ring  :sn_dub,  :sn_dolf, :sn_zome),)
  # set :InstumenteSynth, (ring (ring  :prophet,:prophet,:prophet), (ring :subpulse,:subpulse,:subpulse), (ring :supersaw, :supersaw,  :supersaw),(ring :tech_saws,:tech_saws,:tech_saws), (ring  :dtri,:tech_saws,  :dtri), (ring  :mod_fm,:mod_fm,:mod_fm))
end

set :direction , 64
set :hiHatInstument, 0


#set :SynthInstument, get(:InstumenteSynth)[0]

if get(:bpm) == nil then
  # noch nie gestarted gewesen. also alle abgeleiteten werte setzen.
  
  #set :SynthInstument, get(:InstumenteSynth)[2]
  
  
  set :bpm, 15 # nicht bpm nennen wenn dann geaendert wird
  
  set :runner, 0  # brauchen wir echt? wird eh immer gesetzt.
  #set :aktion, :save
  set :direction , 64
  
else
  # gest gewe nicht soviel setzen
end


### grauslich
## stop: eh nur metawerte.

set :lautstaerke_1 ,0.8
set :lautstaerke_2 , 0.8

set :fader_DJ , 127  # init with some value for random

set :cutoff_L1 , 110
set :cutoff_L2 , 0
set :cutoff_L3 , 0


set :cutoff_R1 , 110
set :cutoff_R2 , 90
set :cutoff_R3 , 70

#set :mode_mirror, 0
#set :mode_zigzag, 0


set :userNote,30 # verwirrend
set :userScaleType,:major
set :userNumOcts,2

set :sustain_R1, 0.1
set :sustain_R2, 0.1
set :sustain_R3, 0.1


set :InstrumentLEAD, (ring  :prophet,:subpulse,:supersaw, :tech_saws, :dtri, :mod_fm).stretch(22) #- so its 128
set :InstrumentPAD,(ring  ,:tech_saws,:blade, :mod_pulse, :mod_beep, :mod_fm, :prophet ).stretch(22)
set :InstrumentBASS,(ring  :square, :dtri, :pulse,  :prophet, :tb303, :tri).stretch(22)

# KONFIGURATION fix
set :_8thOffbpm , 100
set :_BPMRAMP, (ramp *range(20,300,2.2)) # helm
set :_filterRange , range(59,128,1).mirror
set :_sustRange , range(0.0,1.0,0.008).reverse.mirror
set :_detuneRange , range(-0.5,0.0,0.0075).drop(3) + range(0.0,0.5,0.007)
set :_divRange , range(1,9,1).stretch(16).mirror
set :_wheel,    (ring 1,-1)
#set :_wheelQuarters,    (ring 1,(1,-1),(1,-1,1),(1,-1,1,-1), ...)
set :_filterOff , get(:_filterRange)[5].to_i # wie low

# Konfigura TON
set :_NOTERAMP, (ramp *range(12,83,1).mirror)
set :_SCALES, (ring :major,:major_pentatonic, :diatonic, :minor, :minor_pentatonic)


# das abgeleitete werte
set :Master_Note , get(:_NOTERAMP)[get(:userNote)]
set :userScale, scale(get(:_NOTERAMP)[get(:userNote)], get(:userScaleType), num_octaves: get(:userNumOcts))


# endwerte
# MIDI

set :sustain_L1, 0.15


#set :_filter_lfo1 , range(60,127,0.5).mirror


# Hardware midi buttons
# Use local variables, more space, more performance.


# leds - put local too. but will be used once, no more. but save space

#bluecoolbuttons
set :b_SYNC_R, 3
set :b_CUE_R,  22
set :b_PLAY_R, 1

set :b_SYNC_L, 27
set :b_CUE_L,  26
set :b_PLAY_L, 5

# ACTUAL VALUES OF ROTARY
set :knob_L_Hi,  32
set :knob_L_Med, 0
set :knob_L_Low, 0

set :knob_R_Hi,  0
set :knob_R_Med, 0
set :knob_R_Low, 0

# INTERNAL STUFF

set :DRUM_1_ON, 0 # drumbuttons rechts unten
set :DRUM_2_ON, 0
set :DRUM_3_ON, 0
set :DRUM_4_ON, 0

set :DRUM_5_ON, 0 # drumbuttons rechts unten
set :DRUM_6_ON, 0
set :DRUM_7_ON, 0
set :DRUM_8_ON, 0


set :SHIFT_L_ON, false # drumpads 1
set :SHIFT_R_ON, false

set :LOAD_L_ON, false # drumpads 1
set :LOAD_R_ON, false

