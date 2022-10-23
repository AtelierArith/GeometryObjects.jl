# GeometryObjects.jl
Demonstrate [2D elastic collision](https://en.wikipedia.org/wiki/Elastic_collision) in Julia

![](https://github.com/AtelierArith/GeometryObjects.jl/releases/download/result%2Flatest/result.gif)

# How to use

```console
$ git clone https://github.com/AtelierArith/GeometryObjects.jl.git
$ cd GeometryObjects.jl
$ julia --project=@. -e 'using Pkg; Pkg.instantiate()'
$ julia --project=@. demo/gif/gif.jl
```

After that you'll see a gif file `result.gif` is generated.

# Appendix: using Docker

You can execute `demo/gif/gif.jl` out of the box by creating a Docker image from a Dockerfile we prepared. Just try this:

```console
$ make
$ docker-compose run --rm shell julia demo/gif/gif.jl
```

# Appendix: Genie.jl

https://github.com/AtelierArith/ElasticCollision.jl demonstrates 2D elastic collision using Genie.jl

# Appendix MiniFB

See [demo/minifb/README.md](https://github.com/AtelierArith/GeometryObjects.jl/tree/main/demo/minifb)
