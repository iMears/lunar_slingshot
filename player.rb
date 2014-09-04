class Player
  def initialize(window, player_number)
    if player_number == 1
      @image = Gosu::Image.new(window, "media/Starfighter.png", false)
    else
      @image = Gosu::Image.new(window, "media/Starfighter2.png", false)
      @angle = 180
    end
    @image_jet = Gosu::Image.new(window, "media/Starfighter_jet.png", false)
    @beep = Gosu::Sample.new(window, "media/Beep.wav")
    @explosion = Gosu::Sample.new(window, "media/Explosion.wav")
    @woosh_sound = Gosu::Sample.new(window, "media/woosh_sound.wav")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @centerX = 320
    @centerY = 240
    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 2.5
  end

  def turn_right
    @angle += 2.5
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.009)
    @vel_y += Gosu::offset_y(@angle, 0.009)
  end

  def move
    gforce

    @x += @vel_x
    @y += @vel_y
    @x %= 640 
    @y %= 480

    @vel_x *= 0.99995
    @vel_y *= 0.99995

    if @vel_x >= 5
      @vel_x = 5
    elsif @vel_x <= -5
      @vel_x = -5
    end

    if @vel_y >= 5
      @vel_y = 5
    elsif @vel_y <= -5
      @vel_y = -5
    end
    printf("Vel_x,y:%5.2f,%5.2f\n", @vel_x,@vel_y)
    #puts "x: #{@vel_x}, y: #{@vel_y}"
  end

  def gforce
      # force of gravity = k/d^2
    @g_distance = Gosu::distance(@x, @y, @centerX, @centerY)
    puts "@g_distance: #{@g_distance}"
    if (@g_distance == 0)
      @g_distance = 1.0
    end
    g_force = 100.0 / (@g_distance * @g_distance)
    printf("dist:%5.2f, force:%7.5f\n", @g_distance, g_force)
    gravity_accel_x = g_force * 1 * -(@x - @centerX)/@g_distance
    gravity_accel_y = g_force * 1 * -(@y - @centerY)/@g_distance
    @vel_x += gravity_accel_x * 1
    @vel_y += gravity_accel_y * 1
  end


  def draw(thrusting)
    @image.draw_rot(@x, @y, 1, @angle)
    if thrusting
      @image_jet.draw_rot(@x, @y, 1, @angle)
    end
  end

  def score
    @score
  end

  def touch_moon
    if @g_distance < 19.5
      puts "true"
      @explosion.play
      @x = 100
      @y = 100
      @vel_x = @vel_y = 0
      @score = 0
      return true
    else
      puts "false"
      puts "@x:#{@x} @y:#{@y}"
      return false
    end
  end

  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu::distance(@x, @y, star.x, star.y) < 15 then
        @score += 10
        @beep.play
        true
      else
        false
      end
    end
  end
end
