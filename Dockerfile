FROM julia:1.6.3

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    unzip \
    wget \
    nano \
    htop \
    && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* # clean up

# Install NodeJS
RUN apt-get update && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* # clean up

# Install basic packages on default environment
RUN julia -e 'using Pkg; Pkg.add(["PyCall", "IJulia", "Pluto", "PlutoUI", "Revise", "BenchmarkTools"]); Pkg.precompile()'
RUN julia -e 'using Pkg; Pkg.add(["Plots", "PyPlot", "PlotlyJS"])'

WORKDIR /work
ENV JULIA_PROJECT=/work
COPY Project.toml /work/
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
