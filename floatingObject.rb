class FloatingObject
  attr_accessor :x, :y, :vel_x, :vel_y, :angle, :radius
  def initialize(window)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @centerX = 320
    @centerY = 240
  end

  def warp(x, y)
    @x, @y = x, y
    self
  end

  def warp_vel(x, y)
    @vel_x, @vel_y = x, y
    self
  end

  def warp_angle(angle)
    @angle = angle
    self
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
    #fprintf("Vel_x,y:%5.2f,%5.2f\n", @vel_x,@vel_y)
  end

  def gforce # force of gravity = k/d^2
    @g_distance = Gosu::distance(@x, @y, @centerX, @centerY)
   # puts "@g_distance: #{@g_distance}"
    if (@g_distance == 0)
      @g_distance = 1.0
    end
    g_force = 70.0 / (@g_distance * @g_distance)
    #printf("dist:%5.2f, force:%7.5f\n", @g_distance, g_force)
    gravity_accel_x = g_force * 1 * -(@x - @centerX)/@g_distance
    gravity_accel_y = g_force * 1 * -(@y - @centerY)/@g_distance
    @vel_x += gravity_accel_x * 1
    @vel_y += gravity_accel_y * 1
  end

  def draw(thrusting, player)
    @image.draw_rot(@x, @y, 4, @angle)
    if thrusting == true && player == 1
      @image_jet.draw_rot(@x, @y, 1, @angle)
    elsif thrusting == true &&  player == 2
      @image_jet_p2.draw_rot(@x, @y, 1, @angle)
    else
      #nothing
    end
  end

  # def touch_moon
  #   if @g_distance < 19.5
  #     puts "true"
  #     @ explosion.play
  #     @vel_x = @vel_y = 0
  #     clear_score
  #     return true
  #   else
  #     puts "false"
  #     puts "@x:#{@x} @y:#{@y}"
  #     return false
  #   end
  # end

  def touches?(object)
    if object == nil
      return false
    end
    distance = Gosu::distance(@x, @y, object.x, object.y)
    touch_distance = @radius + object.radius
    if distance <= touch_distance 
      true
    else
      false
    end
  end
end
