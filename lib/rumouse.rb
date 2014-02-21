class RuMouse
  def press x, y, button = 1
    raise NotImplementedError
  end

  def release x, y, button = 1
    raise NotImplementedError
  end
  
  def click x, y, button = 1, n = 1
    n.times do 
      press x, y, button
      release x, y, button
    end
  end

  def move x, y
    raise NotImplementedError
  end

  def position
    raise NotImplementedError
  end

  def screen_size
    raise NotImplementedError
  end
end

require './rumouse/darwin'

mouse = RuMouse.new
mouse.move 0, 0
mouse.click 10, 10
