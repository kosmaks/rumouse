require 'rbconfig'

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

os = RbConfig::CONFIG['host_os']

case os
when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
  require 'rumouse/win32.rb'
when /darwin|mac os/
  require 'rumouse/darwin.rb'
when /linux|bsd/
  require 'rumouse/x11.rb'
end
