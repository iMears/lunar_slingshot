require 'gosu'
require './player'
require './star'
require './explosion'


module ZOrder
  Background, Moon, Stars, Player, UI = *0..3
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Lunar Slingshot!"
    @jet_sound = Gosu::Sample.new(self, "media/jet_sound.wav")
    @background_image = Gosu::Image.new(self, "media/Space.png", true)
    @moon = Gosu::Image.new(self, "media/moon.png", false)
    @player = Player.new(self, 1)
    @player2 = Player.new(self, 2)
    @player.warp(100, 240)
    @player2.warp(540, 240)
    @star_anim = Gosu::Image::load_tiles(self, "media/Star.png", 3, 3, false)
    @stars = []
    @stars << (Star.new(@star_anim))
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @thrusting = false
    @explosion_image = Explosion.new Gosu::Image::load_tiles(self, "media/explosion.png", 40, 40, false)
  end

  def update #changes the state of the variables every iteration 
    if @game_over_time != nil
      if @game_over_time <= Time.now - 2
        @game_over_time = nil
      else
        @explosion_image.update
       # @image_index = 0
      end
    else
      if button_down?(Gosu::KbS)
        @player.turn_left
      end
      if button_down?(Gosu::KbF)
        @player.turn_right
      end
      if button_down?(Gosu::KbW)
        #@player.fire
      end
      if button_down?(Gosu::KbD)
        @player.accelerate
        @thrusting = true
        start_jet_sound
      else
        @thrusting = false
        stop_jet_sound
      end
      if button_down?(Gosu::KbJ) 
        @player2.turn_left
      end
      if button_down?(Gosu::KbL)
        @player2.turn_right
      end
      if button_down?(Gosu::KbI)
        #@player2.fire
      end
      if button_down?(Gosu::KbK)
        @player2.accelerate
        @thrusting = true
        start_jet_sound
      else
        @thrusing = false
        stop_jet_sound
      end

      @player.move
      @player2.move
      @player.collect_stars(@stars)
      @player2.collect_stars(@stars)

      if @player.touch_moon || @player2.touch_moon
        stop_jet_sound     
        @game_over_time = Time.now
      end

      if rand(100) < 4 and @stars.size < 25 then
        @stars.push(Star.new(@star_anim))
      end
    end
  end

  def draw #draws the varibales everytime it its called 
    @background_image.draw(0, 0, ZOrder::Background)
    @moon.draw(305, 225, ZOrder::Moon)
    @stars.each { |star| star.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::Player, 1.0, 1.0, 0xffffff00)
    if @game_over_time == nil
      @player.draw(@thrusting)
      @player2.draw(@thrusting)
    end

    if @game_over_time != nil

      @explosion_image.draw
      @font.draw("GAME OVER", 258, 140, ZOrder::Player,1.0, 1.0, 0xffffffff)
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

  def start_jet_sound
    if @jet_sound_instance == nil
      @jet_sound_instance = @jet_sound.play(1, 1, true) #volume, speed, looping
    end
  end

  def stop_jet_sound
    if @jet_sound_instance != nil
      @jet_sound_instance.stop
      @jet_sound_instance = nil
    end
  end
end


window = GameWindow.new
window.show
