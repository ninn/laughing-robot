# laughing-robot
Sonic-Pi Sequencer


This is a sequencer I wrote in SonicPi, for the cheapest USB controller I could find on Amazon. The dj4all by dj-tech. It should be quite ok to modify that this program to use another controller, since all messages are midi notes or cc messages.

idea of the programm:

The controller got 8 drum-pads, that I wanted to use as a sequencer of a kind. 

After some initial pain, and hiccups of the controller (some of them are not bugged out), I added a drum-machine (based on  Otto van Zanten 's design, it basicly worked out of the box with some modifications) and 3 synths (lead, bass, arp)  to the mix.

So, the controller controlls what synth are playing, what drums are playing, their voluemes, their melodies.

The heigh of the notes can be entered with the two jog dials.

The loop sequencer can not only go from 1-8, but every path in between - you can get pretty crazy, since the jog dials define the path of the melody. 


I guess I need a video to show what it does.



Have to open the repository, because I am currently forking the this app: Into one for office, where there is no hardware synth available, and a midi version for at home.

known problems: Runs out of space on my pretty powerfull work machine, and get's behind time on my 10 year old macbook at home.
so .. needs some optimizations.





the general idea is this:
(and this is the first time I write that down at all)

There are 6 files in this app, seq1 to seq6. 

They have to be started in that order - kinda - to have all variables initialized for the next file.

seq1 is the configuration file. It initializes the whole program with default values.
with :bpm one of the most important variables.
:seq1-8 are the steps, binary, if they are activated (128) or not (0)
:sound_L_1-8 is the note for each step.
:_pathidea is the way, the sequencer will run (path to follow through the sequencer)
then there are :Instument  s and :InstumentNumbers, which choose which synth for which voice.
then there are some rings and ranges, that I use throughout the program, and some initialisations of other vairiables .

seq2 is the control-handler for the dj controller.
Its basicly two loops that sync to CC and note messages, and translate them to set:variables for use in the program.
the midi-values are in this file too, because using sets and gets for those fixed values just took up needless space. so, they became globals in that file. Most of that file is straight forward, but it kinda gets complicated with the jogdials, that I wanted to rotate to set note-values, and in another mode - define the path the sequencer runs through. yes, there are several modes: LOOP, SAMPLE and CUE (three leds on my controller). In the loop-mode, I can edit the steps, in the cue-mode, i can edit the height of the notes, and in sample mode i direct the flow of the sequence. sounds complicated, and kinda is ... imagine it a bit like pocket operators, which got a similar control with their dials (which is not on purpose... but kinda works similar). The three modes offer random too, which is great fun. The fader controls the random-seed... kinda. So I cont get too wild values after pushing the random button.


seq3 is THE SEQUENCER.
_leds is the midi numbers for the 8 drum pads
:RTBlink is a function, that had me bite all my nails off, several times. Its just too slow ... and tends to crash the program if bpm is heigh enough. Well, it blinks the led. Blinks it OFF-ON if the step is activated, and ON-OFF if the step is deactivated. so, you see the current step running though all 8 available steps, leaving behind the original sequence lit.
:Sequencer is the main heart of the sequencer, it starts all cues for the rest of the files. It uses its own tick and saves it in :runner, for all other loops to use the same tick too. The basic idea is, that every loop, it advances one step in the sequence. But it got modified later on to be a loop of 8 steps to save space, but ... it should not matter: it loops though all its steps with a ring and using the tick as index. Every 2 beats or so, it will call the Update-Functions.

the sequencer works this way:
there is the sequence (e.g. 128,0,128,0, 128,0,128,0)  and the path to travel through that sequence :pathKEYs (e.g. 0,1,2,3,4,5,6,7). So, this plays: first step, quiet on second step, third step, silence on 4th step, fifth step, 6. silent, and 7. step, 8. silent - in that order. Every step got its note-values (not really) stored in :tonsequence, which combines with the chosen scale and the base-note to the full current note ( = :ton). it got complicated fast, but rings were cool with it.

 


The update-Functions :SequenzUpdateDienst and TonUpdater (later: pathupdater)  update the values of the sequence AFTER the sequence got looped around. They decide if its time for some new notes or restore a saved sequence. I had some issues with the random-buttons changing the sequence too fast, which made it ... un-musical in a way. o I opted for additional loops, seperate from the main sequencer. Made it quite a bit smaller.


seq4 is the Synth-player.
It listens to the cues, and plays the notes the sequencer puts out into the :ton (note) variable.

There is a second path / cue / loop for bass. It got its own path, to follow through the sequence, so it can be different. The idea is that it is some octaves down, same rootnotes, but another melody (=path).

the arp is not rully relized, but it basicly takes the current note and arps it... or so. or chords it. It sounds nice for a minute, but not longer ^^. Needs improvement.


seq5 is the drum machine by Otto van Zanten . I adapted it to work with my code, basicly just removed the controlling function and renamed the cues, but that should be it ... it worked very well, never gave me any troubles. Funny thing is: This is exactly how this program started out: a drum sequencer. hen it grew out of it, and imported it back in. I am not really good a arranging drums, and there is no way to edit the drum-rythm from the controller - the rythm stays.


seq6 is the path, the sequencer follows through the sequence. It basicly translates the jog-dial movements into a ring of values, the sequencer can run through. Its dumb, but it was a experiment that worked quite well.




Confused?
ok.






known problems: 
hangs in the blink function. I am used to get timetravel-warnings, with that function, because it gets called several times a beat. I think sending midi to blink buttons is not the best idea.


Runs out of space after a while if bpm is high enough.


very unoptimized. the only optimizations performed were to get the code small enough to fit in the buffers. comments were removed regularely. Not sure which optimizations are really worth it...


not sure / very possible, that there is a huge overhead in cue messages, and too much :sets or :gets that are useless and are performed because other brances of code may need them... like the range/mode/-precalculations in the midi-sync-functions. 






































