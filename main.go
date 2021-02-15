package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"path/filepath"
	"time"

	"github.com/gorilla/mux"
	"github.com/rs/cors"
)

func main() {

	flag.Parse()
	args := flag.Args()
	if len(args) < 1 || args[0] == "" {
		GetMainLogger().Errorf("Usage: need base dir\n")
		return
	}

	filePath, err := filepath.Abs(args[0])
	if err != nil {
		GetMainLogger().Errorf("Cannot resolve this path %s\n", filePath)
		return
	}
	port := "8080"
	if len(args) >= 2 && args[1] != "" {
		port = args[1]
	}

	GetMainLogger().Infof("baseDir %v \n", filePath)

	// clean the segment folder
	RemoveContents(args[0])
	file_downloadHandler := &FileDownloadHandler{
		StartTime: time.Now(),
		BaseDir:   filePath,
	}

	file_uploadHandler := &FileUploadHandler{
		BaseDir: filePath,
	}

	dash_playHandler := &DashPlayHandler{
		BaseDir: filePath,
	}

	file_deleteHandler := &FileDeleteHandler{
		BaseDir: filePath,
	}

	r := mux.NewRouter()

	r.Handle("/ldash/{folder}/{name:[a-zA-Z0-9/_-]+}.{name:[a-zA-Z0-9/_-]+}", file_uploadHandler).Methods("PUT", "POST")
	r.Handle("/ldash/{folder}/{name:[a-zA-Z0-9/_-]+}.{name:[a-zA-Z0-9/_-]+}", file_downloadHandler).Methods("GET")
	r.Handle("/ldash/{folder}/{name:[a-zA-Z0-9/_-]+}.{name:[a-zA-Z0-9/_-]+}", file_deleteHandler).Methods("DELETE")
	r.Handle("/ldashplay/{folder}/{name:[a-zA-Z0-9/_-]+}.{name:[a-zA-Z0-9/_-]+}", dash_playHandler)
	r.Handle("/", dash_playHandler)

	// KJSL: Adding CORS
	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowCredentials: true,
	})
	rcors := c.Handler(r)

	GetMainLogger().Infof("start server\n")
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", port), rcors))
}
