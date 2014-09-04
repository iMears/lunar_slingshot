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
    self.caption = "Lunar Slingshot"
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
    @thrusting_p1 = false
    @thrusting_p2 = false
    @explosion_image = Explosion.new Gosu::Image::load_tiles(self, "media/explosion.png", 40, 40, false)
    @player_commands = [false, false, false, false, false, false, false, false]
  end

  def update #changes the state of the variables every iteration 
    if @game_over_time != nil
      if @game_over_time <= Time.now - 2
        @game_over_time = nil
      else
        @explosion_image.update
        @player.score = @player2.score = 0
        @player.warp(100, 240)
        @player2.warp(540, 240)
        @player.reset_velocity
        @player2.reset_velocity
      end
    else
      if button_down?(Gosu::KbS)
        @player_commands[0] = true
      end
      if button_down?(Gosu::KbF)
        @player_commands[1] = true
      end
      if button_down?(Gosu::KbE)
        @player_commands[2] = true
      end
      if button_down?(Gosu::KbD)
        @player_commands[3] = true
      end
      if button_down?(Gosu::KbJ) 
        @player_commands[4] = true
      end
      if button_down?(Gosu::KbL)
        @player_commands[5] = true
      end
      if button_down?(Gosu::KbI)
        @player_commands[6] = true
      end
      if button_down?(Gosu::KbK)
        @player_commands[7] = true
      end

      if @player_commands[0] == true
        @player.turn_left
        @player_commands[0] = false
      end
      if @player_commands[1] == true
        @player.turn_right
        @player_commands[1] = false
      end
      if @player_commands[2] == true
        #@player.fire
        @player_commands[2] = false 
      end

      if @player_commands[4] == true
        @player2.turn_left
        @player_commands[4] = false
      end 
      if @player_commands[5] == true
        @player2.turn_right
        @player_commands[5] = false
      end
      if @player_commands[6] == true
        #@player.fire
        @player_commands[6] = false
      end
      if @player_commands[3] == true
        @player.accelerate
        @thrusting_p1 = true
        start_jet_sound(1)
        @player_commands[3] = false
        puts "ACCELERATING PLAYER 1"
      else
        @thrusting_p1 = false
        stop_jet_sound(1)
      end      
      if @player_commands[7] == true
        @player2.accelerate
        @thrusting_p2 = true
        start_jet_sound(2)
        @player_commands[7] = false
        puts "ACCELERATING PLAYER 2"
      else 
        @thrusting_p2 = false
        stop_jet_sound(2)
      end

      @player.move
      @player2.move
      @player.collect_stars(@stars)
      @player2.collect_stars(@stars)

      if @player.touch_moon || @player2.touch_moon
        stop_jet_sound(1)
        stop_jet_sound(2)     
        @game_over_time = Time.now
      end

      if rand(100) < 4 and @stars.size < 25 then
        @stars.push(Star.new(@star_anim))
      end
    end
  end

  def draw #draws the varibales everytime it its called 
    @background_image.draw(0, 0, ZOrder::Background)
    @moon.draw(306, 225, ZOrder::Moon)
    @stars.each { |star| star.draw }
    @font.draw("Red: #{@player.score}", 10, 10, ZOrder::Player, 1.0, 1.0, 0xffffff00)
    @font.draw("Blue: #{@player2.score}", 565, 10, ZOrder::Player, 1.0, 1.0, 0xffffff00)
    if @game_over_time == nil
      @player.draw(@thrusting_p1, 1)
      @player2.draw(@thrusting_p2, 2)
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

  def start_jet_sound(player)
    if player == 1
      if @jet_sound_instance == nil
        @jet_sound_instance = @jet_sound.play(1, 1, true) #volume, speed, looping
      end
    end
    if player == 2
      if @jet_sound_instance_p2 == nil
        @jet_sound_instance_p2 = @jet_sound.play(1, 1, true) #volume, speed, looping
      end
    end
  end

  def stop_jet_sound(player)
    if player == 1
      if @jet_sound_instance != nil
        @jet_sound_instance.stop
        @jet_sound_instance = nil
      end
    end
    if player == 2
      if @jet_sound_instance_p2 != nil
        @jet_sound_instance_p2.stop
        @jet_sound_instance_p2 = nil
      end
    end
  end
end


window = GameWindow.new
window.show
