RuMouse
-------

[![Gem Version](https://badge.fury.io/rb/rumouse.png)](http://badge.fury.io/rb/rumouse)

This is port of PyMouse to ruby. Cross-platform library to simulate mouse events.

Installation
------------

Simply run:

```bash
$ gem install rumouse
```

or add to your Gemfile:

```ruby
gem 'rumouse'
```

Usage
-----

```ruby
require 'rumouse'

mouse = RuMouse.new

# click at 10x10
mouse.click 10, 10

# move mouse to 100x100
mouse.move 100, 100

# press to drag at 10x10
mouse.press 10, 10

# release to drop at 100x100
mouse.release 100, 100

# get current position
puts mouse.position

# get screen size
puts mouse.screen_size 
```
