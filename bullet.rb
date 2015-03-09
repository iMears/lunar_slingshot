class Bullet < FloatingObject
	attr_accessor :expiration, :player_that_fired_me

	def initialize(window, player_number)
		super(window)
		@image = Gosu::Image.new(window, "media/bullet.png", false)
		@radius = 1
		@expiration = 1
		@player_that_fired_me = player_number
	end

	def die
    @player_that_fired_me
  end
end