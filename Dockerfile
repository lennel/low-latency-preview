FROM golang:1.15.7-buster
RUN go get -u github.com/lennel/low-latency-preview
RUN mkdir www
RUN mkdir logs

RUN go install github.com/lennel/low-latency-preview
ENTRYPOINT /go/bin/low-latency-preview www 80
EXPOSE 80
