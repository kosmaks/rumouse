require 'ffi'

module User32
  extend FFI::Library
  ffi_lib 'user32.dll'

  attach_function :SetCursorPos,
                  [:int, :int],
                  :bool
end

class RuMouse
  def move x, y
    User32::SetCursorPos x, y
  end
end
