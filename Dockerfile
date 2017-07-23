FROM r-base:latest

MAINTAINER Winston Chang "efcaguab@gmail.com"

# Install dependencies and Download and install shiny server
RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    default-jdk \
    default-jre \
    icedtea-netx \
    libbz2-dev \
    libcairo2-dev \
    libgdal-dev \
    libicu-dev \
    liblzma-dev \
    libproj-dev \
    libgeos-dev \
    libgsl0-dev \
    librdf0-dev \
    librsvg2-dev \
    libv8-dev \
    libxcb1-dev \
    libxdmcp-dev \
    libxslt1-dev \
    libxt-dev \
    mdbtools \
    netcdf-bin \
    libxt-dev \
    libssl-dev && \
    wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')" && \
    # install my own required packages
    R -e "install.packages(c('scales', 'vegan', 'dplyr', 'foreach', 'reshape2', 'httr', 'jsonlite'), repos='https://cran.rstudio.com/')" && \
    # extra packages for the fishing-monitoring app
    # check packages included in hadleyverse
    R -e "install.packages(c('flexdashboard', 'magrittr', 'plyr', 'ggplot2', 'DT', 'leaflet', 'rgdal', 'lubridate'), repos='https://cran.rstudio.com/')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]
