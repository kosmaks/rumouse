require 'ffi'

module X11
  extend FFI::Library
  ffi_lib 'X11'
  attach_function :XOpenDisplay, [ :char ], :pointer
  attach_function :XWarpPointer, [ :pointer, :ulong, :ulong, :int, :int, :uint, :uint, :int, :int ], :int
  attach_function :XFlush, [:pointer], :int
  attach_function :XCloseDisplay, [:pointer], :int
  attach_function :XDefaultRootWindow, [ :pointer ], :ulong
  attach_function :XQueryPointer, [:pointer, :ulong, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :bool
  attach_function :XWidthOfScreen, [:pointer], :int
  attach_function :XHeightOfScreen, [:pointer], :int
  attach_function :XDefaultScreenOfDisplay, [:pointer], :pointer
end

module Xtst
  extend FFI::Library
  ffi_lib 'Xtst'
  attach_function :XTestFakeButtonEvent, [:pointer, :uint, :bool, :int], :int
end


class RuMouse
  def press x, y, button = 1
    display = X11.XOpenDisplay(0)
    root = X11.XDefaultRootWindow(display)

    move x,y
    Xtst::XTestFakeButtonEvent(display, button, true, 0)

    X11.XFlush(display)
    X11.XCloseDisplay(display)
  end

  def release x, y, button = 1
    display = X11.XOpenDisplay(0)
    root = X11.XDefaultRootWindow(display)

    move x,y
    Xtst::XTestFakeButtonEvent(display, button, false, 0)

    X11.XFlush(display)
    X11.XCloseDisplay(display)
  end
  
  def click x, y, button = 1, n = 1
    n.times do 
      press x, y, button
      release x, y, button
    end
  end

  def move x, y
    display = X11.XOpenDisplay(0)
    root = X11.XDefaultRootWindow(display)
    X11.XWarpPointer(display, 0, root, 0, 0, 0, 0, x, y)
    X11.XFlush(display)
    X11.XCloseDisplay(display)
  end

  def position
    display = X11.XOpenDisplay(0)
    root = X11.XDefaultRootWindow(display)

    win_root_ptr = FFI::MemoryPointer.new :pointer
    win_child_ptr = FFI::MemoryPointer.new :pointer
    r_x = FFI::MemoryPointer.new :pointer
    r_y = FFI::MemoryPointer.new :pointer
    win_x = FFI::MemoryPointer.new :pointer
    win_y = FFI::MemoryPointer.new :pointer
    mark_ptr = FFI::MemoryPointer.new :pointer

    X11.XQueryPointer(display, root, win_root_ptr, win_child_ptr, r_x, r_y, win_x, win_y, mark_ptr)
    X11.XCloseDisplay(display)

    { x: win_x.read_int32, y: win_y.read_int32 }
  end

  def screen_size
    display = X11.XOpenDisplay(0)
    screen = X11.XDefaultScreenOfDisplay(display)
    x = X11.XWidthOfScreen(screen)
    y = X11.XHeightOfScreen(screen)
    X11.XCloseDisplay(display)
    
    {x: x, y: y}
  end
end