.PHONY: all build clean

IMAGENAME=geomrecipejl

all: build

build:
	-rm -rf .venv Manifest.toml
	docker build -t ${IMAGENAME} .
	docker-compose build
	docker-compose run --rm shell julia --project=/work -e 'using Pkg; Pkg.instantiate()'

clean:
	-rm -f Manifest.toml
	-rm -f result.gif
	docker-compose down
