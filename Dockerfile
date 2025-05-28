FROM ubuntu:latest
LABEL authors="Pablo"

ENTRYPOINT ["top", "-b"]