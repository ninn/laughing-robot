
stretcher = 2


pathL =  (ring 0,1,2,3)
pathR = (ring 4,5,6,7)

live_loop :PathUpdateDienst,  sync: :Sequencer do
  
  #sync "/cue/SeqUpdate",
  sync "/cue/PathUpdate"
  puts "====== Updating PATH ====="
  
  
  fader = get(:direction)
  #  ideas = get(:_pathidea)
  ideas = get(:_pathidea)
  
  
  p = (ring )
  
  ideas.each do |id|
    #puts "einzelidea" + id.to_s
    
    case id.to_s
    when "L1"
      p = p + pathL
    when "L-1"
      p = p + pathL.reverse
    when "L2"
      p = p + pathL.mirror
    when "L-2"
      p = p + pathL.reverse.mirror
    when "L3"
      p = p + pathL.mirror + pathL
    when "L-3"
      p = p + pathL.reverse + pathL.mirror
    when "L4"
      p = p + pathL.mirror.repeat(2)
    when "L-4"
      p = p + pathL.reverse.mirror.repeat(2)
      
    when "R1"
      p = p + pathR
    when "R-1"
      p = p + pathR.reverse
    when "R2"
      p = p + pathR.mirror
    when "R-2"
      p = p + pathR.reverse.mirror
    when "R3"
      p = p + pathR.mirror + pathR
    when "R-3"
      p = p + pathR.reverse + pathR.mirror
    when "R4"
      p = p + pathR.mirror.repeat(2)
    when "R-4"
      p = p + pathR.reverse.mirror.repeat(2)
      
    end
  end
  
  
  set :PathKEYS, p
  
  # PFL sucht aus zwischen fugue und doppel
  # set :PathBASS, p.stretch(stretcher *4 )
  #set :PathBASS, p.stretch(stretcher *4 )
  
  set :PathBASS,(ring 0,0,0,0, 0,1,3,0).stretch(4) # , 0,4,0,4, 0,4,0,4, 0,3,0,3, 0,3,0,3, 0,4,0,4, 0,4,0,4)
  set :PathBASS,(ring 0,0,0,0, 0,1,3,0, 0,4,0,4, 0,4,0,4, 0,3,0,3, 0,3,0,3, 0,4,0,4, 0,4,0,4)
  
  # set :PathBASS,(ring 0,1,2)
end



