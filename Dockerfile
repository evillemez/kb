ARG NAME=elv

## STEP: Run Ergogen
FROM node:18.10-alpine3.16 as ergogen
WORKDIR /root
COPY package.json yarn.lock
RUN yarn install
COPY . .
RUN npm run build

## STEP: Export DSN
FROM soundmonster/kicad-automation-scripts:latest
WORKDIR /root
COPY --from=0 /root/output .
RUN mkdir -p $HOME/.config/kicad ;
RUN cp /root/.config/kicad/* $HOME/.config/kicad ;
RUN /usr/lib/python2.7/dist-packages/kicad-automation/pcbnew_automation/export_dsn.py /root/output/pcbs/${NAME}.kicad_pcb /root/output/pcbs/${NAME}.dsn

## STEP: Autoroute PCB
## STEP: Import SES
## STEP: Run DRC
## STEP: Export gerbers
## STEP: Persist results

# syntax=docker/dockerfile:1
##
# FROM golang:1.16
# WORKDIR /go/src/github.com/alexellis/href-counter/
# RUN go get -d -v golang.org/x/net/html  
# COPY app.go ./
# RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o app .

# FROM alpine:latest  
# RUN apk --no-cache add ca-certificates
# WORKDIR /root/
# COPY --from=0 /go/src/github.com/alexellis/href-counter/app ./
# CMD ["./app"]