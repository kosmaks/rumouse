all: build_gem

deploy:
	gem push rumouse-0.0.1.gem

install:
	gem install rumouse-0.0.1.gem

build_gem:
	gem build rumouse.gemspec
