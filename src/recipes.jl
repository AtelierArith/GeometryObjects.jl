# recipes
@recipe function f(pt::Point2D)
    seriestype := :scatter
    label --> :none
    [(pt.x, pt.y)]
end

@recipe function f(pt::Point3D)
    seriestype := :scatter
    label --> :none
    [pt.x], [pt.y], [pt.z]
end

@recipe function f(c::Circle2D)
    seriestype := :shape
    linecolor --> :black
    aspect_ratio --> :equal
    fillalpha --> 0.25
    label --> :none
    θ = 0:0.1:2π
    c.pt.x .+ c.r .* cos.(θ), c.pt.y .+ c.r .* sin.(θ)
end

@recipe function f(particle::Particle2D)
    particle.c
end

@recipe function f(c::Circle3D)
    seriestype := :scatter
    label --> :none
    markersize --> 10c.r
    [c.pt.x], [c.pt.y], [c.pt.z]
end

@recipe function f(geomobjs::AbstractArray{<:ConcreteGeometricTypes})
    for obj in geomobjs
        @series begin
            obj
        end
    end
end

@recipe f(geomobjs::T...) where {T<:ConcreteGeometricTypes} = collect(geomobjs)
