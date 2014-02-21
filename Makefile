all: build_gem

install:
	gem install rumouse*gem

build_gem:
	gem build rumouse.gemspec
