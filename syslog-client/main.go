package main

import (
	"fmt"
	"log"

	// "log/syslog"
	syslog "github.com/RackSec/srslog"
)

func run_tcp() {
	w, err := syslog.Dial("tcp", "127.0.0.1:601", syslog.LOG_ERR, "testtag")
	if err != nil {
		log.Printf("w=%v, err=%v\n", w, err)
	}

	w.SetFormatter(syslog.RFC5424Formatter)
	w.SetFramer(syslog.RFC5425MessageLengthFramer)
	w.SetHostname("jonas")

	for i := 0; i < 100; i++ {
		msg := fmt.Sprintf("log %d", i)
		log.Println(msg, " sent")
		w.Alert(msg)
	}
}

func main() {
	run_tcp()
}
