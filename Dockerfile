FROM ubuntu:18.04
RUN mkdir -p /slides && cd /slides
RUN apt-get update  &&\
    apt-get install -y git wget
RUN apt-get install -y curl software-properties-common
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs bzip2
RUN npm install -g phantomjs-prebuilt --ignore-scripts reveal-md
WORKDIR /slides
COPY slides .

ENTRYPOINT ["reveal-md", "/slides/index.md"]
CMD ["--theme", "blood"]
