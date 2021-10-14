module GeometryObjects

using Random

using RecipesBase
using StaticArrays:FieldVector

# types
export Point2D, Point3D, Velocity2D, Circle2D, Circle3D, Particle2D
include("types.jl")
include("recipes.jl")

end # module
