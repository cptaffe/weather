FROM golang:1.24.2-alpine3.21

RUN apk add --no-cache \
	jq \
	curl \
	git \
	build-base \
	linux-headers \
	perl

# Install plan9port (works as of 9da5b4451365e33c4f561d74a99ad5c17ff20fed)
ENV PLAN9=/usr/src/plan9port
ENV PATH="$PATH:$PLAN9/bin"
WORKDIR /usr/src/plan9port
RUN git clone https://github.com/9fans/plan9port.git . && \
	./INSTALL

WORKDIR /usr/src/weather

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -v -o /usr/local/bin/tcpw ./tcpw && \
	mv alerts /usr/local/bin

CMD ["alerts"]

