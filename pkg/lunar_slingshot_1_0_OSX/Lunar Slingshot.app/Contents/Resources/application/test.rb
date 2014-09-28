# use the commands for left
      if @keyboard_controls_left[0] == true
        @players[0].turn_left
        @keyboard_controls_left[0] = false
      end
      if @keyboard_controls_left[1] == true
        @players[0].turn_right
        @keyboard_controls_left[1] = false
      end
      if @keyboard_controls_left[2] == true
        @bullets[0] = @players[0].fire
        @keyboard_controls_left[2] = false 
      end
      if @keyboard_controls_left[3] == true
        @players[0].accelerate
        @thrusting_p1 = true
        start_jet_sound(1)
        @keyboard_controls_left[3] = false
      else
        @thrusting_p1 = false
        stop_jet_sound(1)
      end      

      player_index = 0
      2.times do
        @players[player_index].move
        @players[player_index].collect_stars(@stars)
        if @bullets[player_index] != nil 
          @bullets[player_index].move
        end

        if @players[player_index].touches?(@moon)
          stop_jet_sound(1)
          stop_jet_sound(2)     
          @players[0].die
          @players[1].die
          @game_over_time = Time.now
        end
        player_index += 1
      end
      if rand(100) < 4 and @stars.size < 25 then
        @stars.push(Star.new(@star_anim))
      end
    end
  end

  def draw #draws the varibales everytime it its called 
    @background_image.draw(0, 0, ZOrder::Background)
    @moon.draw(false, 3)
    @stars.each { |star| star.draw }
    @font.draw("Red: #{@players[0].score}", 10, 10, ZOrder::Player, 1.0, 1.0, 0xffffff00)
    @font.draw_rel("Blue: #{@players[1].score}", 630, 10, ZOrder::Player, 1.0, 0, 1.0, 1.0, 0xffffff00)
    @font.draw_rel("Frame: #{@update_count}", 330, 10, ZOrder::Player, 1.0, 0, 1.0, 1.0, 0xffffff00)
    #calculate FPS using time!!
    if @bullets[0] != nil
      @bullets[0].draw(false, 3)
    end
    if @bullets[1] != nil
      @bullets[1].draw(false, 3)
    end

    if @game_over_time == nil
      @players[0].draw(@thrusting_p1, 1)
      @players[1].draw(@thrusting_p2, 2)
    end

    if @game_over_time != nil
      @explosion_image.draw
      @font.draw("GAME OVER", 258, 140, ZOrder::Player,1.0, 1.0, 0xffffffff)
    end
  end
