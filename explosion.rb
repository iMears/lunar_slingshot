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

  def draw(x, y)
    @images[@image_index].draw(x, y, ZOrder::Background)
  end
end