class Player < FloatingObject
  attr_accessor :score, :bullets_remaining
  def initialize(window, player_number)
    super(window)
    @player_number = player_number
    if @player_number == 1
      @image = Gosu::Image.new(window, "media/Starfighter.png", false)
    else
      @image = Gosu::Image.new(window, "media/Starfighter2.png", false)
    end
    reset_velocity
    @image_jet = Gosu::Image.new(window, "media/Starfighter_jet.png", false)
    @image_jet_p2 = Gosu::Image.new(window, "media/Starfighter_jet_2.png", false)
    @beep = Gosu::Sample.new(window, "media/Beep.wav")
    @score = 0
    @score_player_2 = 0
    @bullets = []
    @bullet_sound = Gosu::Sample.new(window, "media/Fire_sound.wav")
    @radius= 8
    @fire_armed = true
    @bullets_remaining = 10
    @store_window = window
  end

  def turn_left(do_it)
    if do_it
      @angle -= 2.5
    end
  end

  def turn_right(do_it)
    if do_it
      @angle += 2.5
    end
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.009)
    @vel_y += Gosu::offset_y(@angle, 0.009)
  end

  def score
    @score
  end

  def clear_score
    @score = 0
  end

  def reset_velocity
    @vel_x = @vel_y = 0.0
    if @player_number != 1
      @angle = 180
    else
      @angle = 0.0
    end
    # @angle = @player_number != 1 ? 180.0 : 0.0g
    # @angle = if @player_number != 1 then 180.0 else 0.0 end
  end

  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu::distance(@x, @y, star.x, star.y) < 10 then
        @score += 10
        @beep.play
        true
      else
        false
      end
    end
  end

  def fire
    # bullet fade out control
    if @bullets_remaining >= 1
      @bullets_remaining -= 1
      @bullet_sound.play
      my_bullet = Bullet.new(@store_window)
      x_offset = Gosu::offset_x(@angle, 16)
      y_offset = Gosu::offset_y(@angle, 16)
      x_vel_offset = Gosu::offset_x(@angle, 1)
      y_vel_offset = Gosu::offset_y(@angle, 1)
      my_bullet.warp(self.x + x_offset, self.y + y_offset)
      my_bullet.warp_vel(self.vel_x + x_vel_offset, self.vel_y + y_vel_offset)
      my_bullet.warp_angle(@angle)
      my_bullet
    else
      nil
    end
  end

  def die
    @vel_x = @vel_y = 0
    clear_score
    @bullets_remaining = 10
  end
end
