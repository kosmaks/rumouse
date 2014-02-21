require 'ffi'

module CGEvent
  extend FFI::Library
  ffi_lib "/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/CoreGraphics.framework/Versions/A/CoreGraphics"

  class CGPoint < FFI::Struct
    layout :x, :double,
           :y, :double
  end

  enum :CGEventType, [:kCGEventNull,               0,		 # Null Event 
                      :kCGEventLeftMouseDown,      1,		 # left mouse-down event
                      :kCGEventLeftMouseUp,        2,		 # left mouse-up event
                      :kCGEventRightMouseDown,     3,		 # right mouse-down event
                      :kCGEventRightMouseUp,       4,		 # right mouse-up event
                      :kCGEventMouseMoved,         5,		 # mouse-moved event
                      :kCGEventLeftMouseDragged,   6,    # left mouse-dragged event
                      :kCGEventRightMouseDragged,  7,    # right mouse-dragged event
                      :kCGEventOtherMouseDown,     25,   # other mouse-down event
                      :kCGEventOtherMouseUp,       26,   # other mouse-up event
                      :kCGEventOtherMouseDragged,  27]   # other mouse-dragged event

  enum :CGMouseButton, [:kCGMouseButtonLeft, 0,
                        :kCGMouseButtonRight,
                        :kCGMouseButtonCenter ]

  enum :CGEventTapLocation, [:kCGHIDEventTap, 0,
                             :kCGSessionEventTap,
                             :kCGAnnotatedSessionEventTap ]                    

  attach_function :CGEventCreateMouseEvent, 
                  [:pointer, :CGEventType, CGPoint.by_value, :CGMouseButton], 
                  :pointer

  attach_function :CGEventPost, 
                  [:CGEventTapLocation, :pointer], 
                  :void

  attach_function :CGEventCreate,
                  [:pointer],
                  :pointer

  attach_function :CGEventGetLocation,
                  [:pointer],
                  CGPoint.by_value

  attach_function :CGDisplayPixelsWide,
                  [:int],
                  :size_t

  attach_function :CGDisplayPixelsHigh,
                  [:int],
                  :size_t

  attach_function :CFRelease, 
                  [:pointer], 
                  :void
end

class RuMouse
  def press x, y, button = 1
    case button
    when 1 then mouse_event x, y, :kCGEventLeftMouseDown, :kCGMouseButtonLeft
    when 2 then mouse_event x, y, :kCGEventRightMouseDown, :kCGMouseButtonRight
    end
  end

  def release x, y, button = 1
    case button
    when 1 then mouse_event x, y, :kCGEventLeftMouseUp, :kCGMouseButtonLeft
    when 2 then mouse_event x, y, :kCGEventRightMouseUp, :kCGMouseButtonRight
    end
  end

  def move x, y
    mouse_event x, y, :kCGEventMouseMoved, :kCGMouseButtonLeft
  end

  def position
    event = CGEvent::CGEventCreate nil
    pos = CGEvent::CGEventGetLocation event
    CGEvent::CFRelease event
    { x: pos[:x], y: pos[:y] }
  end

  def screen_size
    { x: CGEvent::CGDisplayPixelsWide(0),
      y: CGEvent::CGDisplayPixelsHigh(0) }
  end
  
  private

  def mouse_event x, y, type, button
    coord = CGEvent::CGPoint.new
    coord[:x] = x
    coord[:y] = y
    event = CGEvent::CGEventCreateMouseEvent(nil, type, coord, button)
    CGEvent::CGEventPost(:kCGHIDEventTap, event)
    CGEvent::CFRelease(event)
  end
end
