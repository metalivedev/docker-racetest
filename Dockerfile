FROM ubuntu
RUN apt-get update; apt-get install -y git
# Must add local directory to make it a git repo in the container.
ADD . /builddir
WORKDIR /builddir
ENV SLEEPFOR 600
# This sleep gives a chance for you to do another git push with a shorter
# SLEEPFOR value. So you can force the race condition for the test.
RUN sleep $SLEEPFOR
RUN [ $(git rev-parse HEAD) = \
      $(git ls-remote $(git rev-parse --abbrev-ref @{u} | \
      sed 's/\// /g') | cut -f1) ] && echo up to date \
    || (echo not up to date && exit 1)
CMD git rev-parse HEAD
