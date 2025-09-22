package main

import (
	"net/http"

	"connectrpc.com/grpchealth"
	"connectrpc.com/grpcreflect"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"

	"quiz-arena.net/template/internal/gen/quiz_arena/template/v1/templatev1connect"
)

func main() {
	mux := http.NewServeMux()

	mux.Handle(grpchealth.NewHandler(
		grpchealth.NewStaticChecker(
			templatev1connect.TemplateServiceName,
		),
	))
	mux.Handle(grpcreflect.NewHandlerV1(
		grpcreflect.NewStaticReflector(
			grpchealth.HealthV1ServiceName,
			templatev1connect.TemplateServiceName,
		),
	))
	mux.Handle(grpcreflect.NewHandlerV1Alpha(
		grpcreflect.NewStaticReflector(
			grpchealth.HealthV1ServiceName,
			templatev1connect.TemplateServiceName,
		),
	))

	http.ListenAndServe(
		":50051",
		h2c.NewHandler(mux, &http2.Server{}),
	)
}
