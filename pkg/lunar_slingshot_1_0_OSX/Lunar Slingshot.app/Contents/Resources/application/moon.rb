class Moon < FloatingObject
	def initialize(window)
		super(window)
		@image = Gosu::Image.new(window, "media/moon.png", false)
		@radius = 9
		@x = 320
		@y = 240
	end	

	def die
		25.times {puts "The moon has died!!!!!"}
	end
end