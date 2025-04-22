package main

import (
	"flag"
	"io"
	"log"
	"net"
	"os"
)

var address = flag.String("address", "", "Address to connect to, e.g. google.com:80")

func main() {
	flag.Parse()

	if *address == "" {
		log.Fatal("--address is required")
	}
	log.Printf("Connecting to %s", *address)
	conn, err := net.Dial("tcp", *address)
	if err != nil {
		log.Fatalf("dial: %v", err)
	}
	defer conn.Close()
	_, err = io.Copy(conn, os.Stdin)
	if err != nil {
		log.Fatalf("copy from stdin: %v", err)
	}
}
