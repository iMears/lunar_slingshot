class Bullet < FloatingObject
	attr_accessor :expiration, :player_that_shot_me

	def initialize(window)
		super(window)
		@image = Gosu::Image.new(window, "media/bullet.png", false)
		@radius = 1
		@expiration = 1
		@player_that_shot_me = nil
	end	

	def die
    puts "bullet died!"
  end
end