FROM golang:latest

# Set necessary environmet variables needed for our image
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Move to working directory /build
RUN mkdir /build
WORKDIR /build

# copy go files to build dir
COPY go.mod /build/
COPY hello-world.go /build/
 
# Build the application
RUN cd /build && go build hello-world.go 

# Export necessary port
EXPOSE 8085

CMD ["/build/hello-world"]
