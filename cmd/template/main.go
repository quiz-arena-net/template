package main

import (
	"log/slog"
	"net/http"
	"os"

	"connectrpc.com/grpchealth"
	"connectrpc.com/grpcreflect"
	"github.com/quiz-arena-net/template/internal/gen/quiz_arena/template/v1/templatev1connect"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
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

	addr := ":50051"

	slog.Info("starting server", "addr", addr)
	err := http.ListenAndServe(
		addr,
		h2c.NewHandler(mux, &http2.Server{}),
	)
	if err != nil {
		slog.Error("listen and serve failed", "err", err)
		os.Exit(1)
	}
}
