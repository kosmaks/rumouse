require 'ffi'

module User32
  extend FFI::Library
  ffi_lib 'user32.dll'
  ffi_convention :stdcall

  MOUSEEVENTF_ABSOLUTE  = 0x8000
  MOUSEEVENTF_LEFTDOWN  = 0x0002
  MOUSEEVENTF_LEFTUP    = 0x0004
  MOUSEEVENTF_RIGHTDOWN = 0x0008
  MOUSEEVENTF_RIGHTUP   = 0x0010

  class Point < FFI::Struct
    layout :x, :long,
           :y, :long
  end

  attach_function :SetCursorPos, [:int, :int], :bool
  attach_function :GetCursorPos, [Point], :bool
  attach_function :GetSystemMetrics, [:int], :int
  attach_function :mouse_event, [:uint, :uint, :uint, :uint, :pointer], :void
end

class RuMouse
  def move x, y
    User32::SetCursorPos x, y
  end

  def press x, y, button = 1
    move x, y
    User32::mouse_event User32::MOUSEEVENTF_ABSOLUTE | button_code(button, true),
                        x, y,
                        0, nil
  end

  def release x, y, button = 1
    move x, y
    User32::mouse_event User32::MOUSEEVENTF_ABSOLUTE | button_code(button, false),
                        x, y,
                        0, nil
  end

  def position
    point = User32::Point.new
    User32::GetCursorPos point
    { x: point[:x], y: point[:y] }
  end

  def screen_size
    { x: User32::GetSystemMetrics(0),
      y: User32::GetSystemMetrics(1) }
  end

  private

  def button_code id, state
    if    id == 1 and state then User32::MOUSEEVENTF_LEFTDOWN
    elsif id == 2 and state then User32::MOUSEEVENTF_RIGHTDOWN
    elsif id == 1 and not state then User32::MOUSEEVENTF_LEFTUP
    elsif id == 2 and not state then User32::MOUSEEVENTF_RIGHTUP
    else 0 end
  end
end
