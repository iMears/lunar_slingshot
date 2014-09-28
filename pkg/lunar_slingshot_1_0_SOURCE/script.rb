
require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Gosu Tutorial Game"

  end

end

window = GameWindow.new
  
sample1 = Gosu::Sample.new(window, "media/Explosion.wav") 
sample2 = Gosu::Sample.new(window, "media/Beep.wav")



sample2.play
sample2.play
sample1.play

sleep 10
