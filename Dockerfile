FROM golang:1.15-alpine AS builder
#ARG APP_ENV
WORKDIR /tmp/build/

COPY go.mod .
COPY go.sum .

RUN go env -w GOPROXY=https://goproxy.cn,direct

RUN go mod download && go mod graph

COPY . .

RUN go build  -tags "doc" -o run-app . ;

#RUN if [ "${APP_ENV}" != "prod" ];then \
#        go get -u github.com/swaggo/swag/cmd/swag ;\
#        swag init ;\
#        go build  -tags "doc" -o run-app . ;\
#    else\
#        mkdir -p docs ;\
#        go build  -o run-app . ;\
#    fi

# ---
FROM alpine

WORKDIR /app

COPY --from=builder /tmp/build/run-app /usr/bin/

EXPOSE 1323

CMD ["run-app"]

