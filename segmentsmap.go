package main

import "sync"

type SegmentsMap struct {
	name     string
	segments map[string]bool
	lock     sync.Mutex
}

var streams sync.Map

func getStreamLiveSegments(streamName string) *SegmentsMap {
	store, _ := streams.LoadOrStore(streamName, &SegmentsMap{
		name:     streamName,
		segments: make(map[string]bool),
		lock:     sync.Mutex{},
	})
	return store.(*SegmentsMap)
}

func GetSegments(streamName string) []string {
	segments := getStreamLiveSegments(streamName)
	keys := make([]string, len(segments.segments))
	i := 0
	for k := range segments.segments {
		keys[i] = k
		i++
	}
	return keys
}

func AddSegment(streamName string, segmentName string) {
	segments := getStreamLiveSegments(streamName)
	segments.lock.Lock()
	defer segments.lock.Unlock()
	segments.segments[segmentName] = true
}

func RemoveSegment(streamName string, segmentName string) {
	segments := getStreamLiveSegments(streamName)
	segments.lock.Lock()
	defer segments.lock.Unlock()
	delete(segments.segments, segmentName)
}
