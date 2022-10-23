
```console
$ cd path/to/this/dir
$ julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()'
$ julia --project=@. minifb.jl
```
