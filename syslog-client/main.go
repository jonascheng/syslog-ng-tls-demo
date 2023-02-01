package main

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"io/ioutil"
	"log"

	// "log/syslog"
	syslog "github.com/RackSec/srslog"
)

func run_tcp() {
	w, err := syslog.Dial("tcp", "192.168.1.10:601", syslog.LOG_ERR, "tcp")
	if err != nil {
		log.Printf("w=%v, err=%v\n", w, err)
	}
	defer w.Close()

	w.SetFormatter(syslog.RFC5424Formatter)
	w.SetFramer(syslog.RFC5425MessageLengthFramer)
	w.SetHostname("jonas")

	for i := 0; i < 100; i++ {
		msg := fmt.Sprintf("tcp log %d", i)
		log.Println(msg, " sent")
		w.Alert(msg)
	}
}

func run_tls() {
	// load trusted root CA
	rootCAs, _ := x509.SystemCertPool()
	if rootCAs == nil {
		log.Println("fail to load from system cert pool")
		rootCAs = x509.NewCertPool()
	}

	serverCert, err := ioutil.ReadFile("root-ca.pem")
	if err != nil {
		log.Printf("fail to read server ca, err=%v", err)
		return
	}
	rootCAs.AppendCertsFromPEM(serverCert)

	// specify client CA for mutual TLS
	cert, err := tls.LoadX509KeyPair("client-ca.pem", "client-ca.key")
	if err != nil {
		log.Printf("fail to read client ca, err=%v", err)
		return
	}

	config := tls.Config{
		InsecureSkipVerify: false,
		RootCAs:            rootCAs,
		Certificates:       []tls.Certificate{cert},
	}

	w, err := syslog.DialWithTLSConfig("tcp+tls", "192.168.1.10:6514", syslog.LOG_ERR, "tls", &config)
	if err != nil {
		log.Printf("w=%v, err=%v\n", w, err)
	}
	defer w.Close()

	w.SetFormatter(syslog.RFC5424Formatter)
	w.SetFramer(syslog.RFC5425MessageLengthFramer)
	w.SetHostname("jonas")

	for i := 0; i < 100; i++ {
		msg := fmt.Sprintf("tls log %d", i)
		log.Println(msg, " sent")
		if err := w.Alert(msg); err != nil {
			log.Printf("w=%v, err=%v\n", w, err)
			break
		}
	}
}

func main() {
	run_tcp()
	run_tls()
}
