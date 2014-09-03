class Explosion
  attr_accessor :images, :image_index

  def initialize(images)
    @images = images
    @image_index = 0
    @counter = 0
    images = images.first if images.is_a? Array
  end

  def update
    @counter += 1
    if @counter >= 1 and @image_index < 10
      @image_index += 1
      @counter = 0
    else 
      @image_index = 0    
    end
  end 

  def draw
    puts "DRAWING THE EXPLOSION"
    puts "@image_index: #{@image_index}"
    #if @image_index >= 0 && @image_index <= 10
    @images[@image_index].draw(296, 216, ZOrder::Player)
    #end
  end
end