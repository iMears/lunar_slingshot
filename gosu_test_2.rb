require 'gosu'
require './player'
require './star'

module ZOrder
  Background, Stars, Player, UI = *0..3
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Gosu Tutorial Game"
    @jet_sound = Gosu::Sample.new(self, "media/jet_sound.wav")
    @background_image = Gosu::Image.new(self, "media/Space.png", true)
    @sun = Gosu::Image.new(self, "media/Sun.png", false)
    @player = Player.new(self)
    @player.warp(100, 240)
    @star_anim = Gosu::Image::load_tiles(self, "media/Star.png", 3, 3, false)
    @stars = []
    @stars << (Star.new(@star_anim))
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @thrusting = false
  end

  def update #changes the state of the variables every iteration 
    if @game_over_time != nil
      if @game_over_time <= Time.now - 2
        @game_over_time = nil
      end

    else
      if button_down?(Gosu::KbLeft) or button_down?(Gosu::GpLeft) then
        @player.turn_left
      end
      if button_down?(Gosu::KbRight) or button_down?(Gosu::GpRight) then
        @player.turn_right
      end
      if button_down?(Gosu::KbUp) or button_down?(Gosu::GpButton0) then
        @player.accelerate
        @thrusting = true
        start_jet_sound
      else
        @thrusting = false
        stop_jet_sound
      end

      @player.move
      @player.collect_stars(@stars)

      if @player.touch_sun
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
    @sun.draw(295, 215, ZOrder::UI)
    @player.draw(@thrusting)
    @stars.each { |star| star.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
    if @game_over_time != nil
      @font.draw("GAME OVER", 265, 140, ZOrder::UI,1.0, 1.0, 0xffffffff)
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
