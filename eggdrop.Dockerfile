######################################################
# define builder stage to build and prepare everything
######################################################
FROM eggdrop:1.8.4 as builder

# install qstat build dependencies
RUN apk add --no-cache git build-base automake autoconf

# get the qstat source code with git
RUN git clone https://github.com/multiplay/qstat.git

# check out the tested version; remove if you want latest
RUN cd qstat && \
    git checkout 85fbecb117e90e1029c1bfa0ca9bc610a67d41af

# build the qstat binary
RUN cd qstat && \
    ./autogen.sh && \
    ./configure && \
    make CFLAGS=-O0	# -O0 is a workaround for a compile error

######################################################
# define runtime stage to build the runtime image
######################################################
FROM eggdrop:1.8.4 as runtime

# copy the scripts into the image
COPY --chown=eggdrop:nogroup \
     ["./scripts/*.tcl", "/home/eggdrop/eggdrop/scripts/"]

# copy qstat binary from builder
COPY --from=builder \
     --chown=eggdrop:nogroup \
     ["/home/eggdrop/eggdrop/qstat/qstat", "/usr/local/bin/"]

# install other script dependencies
RUN apk add --no-cache bind-tools libpq

# add scripts to the config
RUN echo "" >> eggdrop.conf && \
    echo "# start of scripts from repository" >> eggdrop.conf && \
    echo "source scripts/auth.tcl" >> eggdrop.conf && \
    echo "source scripts/beer.tcl" >> eggdrop.conf && \
    echo "source scripts/date.tcl" >> eggdrop.conf && \
    echo "source scripts/funwar.tcl" >> eggdrop.conf && \
    echo "source scripts/greetings.tcl" >> eggdrop.conf && \
    echo "source scripts/help.tcl" >> eggdrop.conf && \
    echo "source scripts/host.tcl" >> eggdrop.conf && \
    echo "source scripts/insult.tcl" >> eggdrop.conf && \
    echo "source scripts/maketiny.tcl" >> eggdrop.conf && \
    echo "source scripts/match.tcl" >> eggdrop.conf && \
    echo "source scripts/qstat.tcl" >> eggdrop.conf && \
    echo "source scripts/topic.tcl" >> eggdrop.conf && \
    echo "source scripts/watch.tcl" >> eggdrop.conf && \
    echo "# end of scripts from repository" >> eggdrop.conf && \
    echo "" >> eggdrop.conf

# the original entrypoint.sh from eggrop:1.8.4 changes the dns setting to an
# external dns address; disable this with a hack
RUN sed -i \
    -e 's/^#set dns-servers "8.8.8.8 8.8.4.4"/#set dns-servers "127.0.0.11"/' \
    eggdrop.conf
