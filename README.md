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






