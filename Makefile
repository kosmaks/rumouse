all: build_gem

deploy:
	gem push rumouse*.gem

install:
	gem install rumouse*.gem

build_gem:
	rm -f *.gem
	gem build rumouse.gemspec
