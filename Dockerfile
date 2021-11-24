FROM julia:1.6.4

# Install basic packages on default environment
RUN julia -e 'using Pkg; Pkg.add(["Plots", "Distributions"])'

WORKDIR /work
ENV JULIA_PROJECT=/work
COPY Project.toml /work/

# create dummy module
RUN mkdir -p /work/src && echo 'module GeometryObjects end' > /work/src/GeometryObjects.jl

RUN julia -e '\
    using Pkg; Pkg.instantiate(); \
    Pkg.precompile(); \
    using InteractiveUtils; versioninfo() \
'

# For Jupyter Notebook
EXPOSE 8888
# For Http Server
EXPOSE 8000
# For Pluto Server
EXPOSE 9999

ENV GKSwstype="100"

CMD ["julia"]
