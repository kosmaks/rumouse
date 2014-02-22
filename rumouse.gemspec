Gem::Specification.new do |s|
  s.name        = "rumouse"
  s.version     = "0.0.6"
  s.date        = "2014-02-22"
  s.summary     = "Port of pythons' PyMouse."
  s.description = "Cross-platform solution for simulating mouse events"
  s.authors     = ["Maxim Kostuchenko",
                   "Eduard Antsupov"]
  s.email       = "kstmaks@gmail.com"
  s.files       = ["lib/rumouse.rb", 
                   "lib/rumouse/darwin.rb",
                   "lib/rumouse/win32.rb",
                   "lib/rumouse/x11.rb"]
  s.homepage    = "https://github.com/kosmaks/rumouse"
  s.license     = "MIT"

  s.add_runtime_dependency "ffi", "~> 1.9.3"
end
