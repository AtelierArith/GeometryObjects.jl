#=
using Pkg

for pkg in ["Plots", "Distributions"]
    if isnothing(Base.find_package(pkg))
        Pkg.add(pkg)
    end
end
=#

using LinearAlgebra

using Plots
using Distributions

using GeometryObjects



Base.@kwdef struct CollisionSystem
    xmin::Float64 = -4
    xmax::Float64 = 4
    ymin::Float64 = -4
    ymax::Float64 = 4
    maxT::Int = 500
    num_particles::Int = 20
end

function setup_particle(sys::CollisionSystem)
    particles = Particle2D[]
    num_particles = sys.num_particles
    while length(particles) != num_particles
        θ = 2π * rand()
        v_abs = 0.08
        v = Velocity2D(v_abs * cos(θ), v_abs * sin(θ))
        m = r = rand(Uniform(0.1, 0.3))
        x = rand(Uniform(sys.xmin + r, sys.xmax - r))
        y = rand(Uniform(sys.ymin + r, sys.ymax - r))

        c = Particle2D(
            Circle2D(Point2D(x, y), r),
            v,
            m,
        )

        c_plus_r = Particle2D(
            Circle2D(Point2D(x, y), r + v_abs),
            v,
            m,
        )

        any(has_contact.(Ref(c_plus_r), particles)) && continue
        push!(particles, c)
    end
    return particles
end

function move!(sys::CollisionSystem, pt::Point2D, v::Velocity2D, r::Real=0)
    pt .+= v # do not use `pt += v`
    if pt.y  ≥ sys.ymax - r
        pt.y = 2(sys.ymax - r) - pt.y
        v.y = -v.y
    end
    if pt.y ≤ (sys.ymin + r)
        pt.y = 2(sys.ymin + r) - pt.y
        v.y = -v.y
    end

    if pt.x ≥ (sys.xmax - r)
        pt.x = 2(sys.xmax - r) - pt.x
        v.x = -v.x
    end
    if pt.x ≤ (sys.xmin + r)
        pt.x = 2(sys.xmin + r) - pt.x
        v.x = -v.x
    end
    return pt, v
end

move!(sys::CollisionSystem, p::Particle2D) = move!(sys, p.c.pt, p.v, p.c.r)

dist(pt1, pt2) = sqrt((pt1.x - pt2.x)^2 + (pt1.y - pt2.y)^2)
has_contact(c1::Circle2D, c2::Circle2D) = c1.r + c2.r ≥ dist(c1.pt, c2.pt)
has_contact(p1::Particle2D, p2::Particle2D) = has_contact(p1.c, p2.c)

isijulia() = isdefined(:Main, :IJulia)

function create_animation(sys::CollisionSystem; disp::Bool=true)
    particles = setup_particle(sys)

    anim = @animate for t in 1:sys.maxT
        disp && isijulia() && IJulia.clear_output(true)
        move!.(Ref(sys), particles)
        # naive collision algorithm
        for i in 1:length(particles)
            for j in (i + 1):length(particles)
                particle1 = particles[i]
                particle2 = particles[j]
                c1 = particle1.c
                c2 = particle2.c
                # update c1.v and c2.v
                if has_contact(c1, c2)
                    pt1 = c1.pt
                    pt2 = c2.pt

                    v1 = particle1.v
                    v2 = particle2.v
                    m1 = particle1.m
                    m2 = particle2.m

                    # correct position so that c1 and c2 does not contact
                    for _ in 0:0.005:1
                        c1.pt .-= 0.005 .* v1
                        c2.pt .-= 0.005 .* v2
                        if !has_contact(c1, c2)
                            break
                        end
                    end

                    # update velocity
                    v1_next = v1 - 2m2 / (m1 + m2) * dot(v1 - v2, pt1 - pt2) * (pt1 - pt2) / dot(pt1 - pt2, pt1 - pt2)
                    v2_next = v2 - 2m1 / (m2 + m1) * dot(v2 - v1, pt2 - pt1) * (pt2 - pt1) / dot(pt2 - pt1, pt2 - pt1)
                    particle1.v .= v1_next
                    particle2.v .= v2_next

                end
            end
        end

        s = plot(
            size=(400, 300),
            xlim=(sys.xmin, sys.xmax), ylim=(sys.ymin, sys.ymax),
            aspect_ratio=:equal, legend=false,
            grid=false, ticks=false,
            framestyle=:box,
        )

        plot!(s, particles)
        plot!(s, title="$t")
        disp && isijulia() && display(s)
    end

    return anim
end

anim = create_animation(CollisionSystem(;maxT=100, xmin=-8, xmax=8), disp=false)
gif(anim, "result.gif")
