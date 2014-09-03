class Fire
	attr_reader :x, :y

	def initialize
     @bullet = Gosu::Image::load_tiles(self, "media/Star.png", 3, 3, false)
	end

  def draw
  end

  def fire!
  end

end