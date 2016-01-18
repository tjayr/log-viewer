package com.guru.monitor.services;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Future;
import io.vertx.core.http.HttpMethod;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.CorsHandler;
import io.vertx.ext.web.handler.StaticHandler;

/**
 * Created by tony on 18/01/16.
 */
public class HttpServerVerticle extends AbstractVerticle {

    @Override
    public void start(Future<Void> fut) throws Exception {

        System.out.println("Starting Http server on port 8081");
        Router router = Router.router(vertx);

        CorsHandler corsHandler = CorsHandler.create("*");
        corsHandler.allowedMethod(HttpMethod.GET);
        corsHandler.allowedMethod(HttpMethod.POST);
        corsHandler.allowedMethod(HttpMethod.PUT);
        corsHandler.allowedMethod(HttpMethod.DELETE);
        corsHandler.allowedHeader("Authorization");
        corsHandler.allowedHeader("Content-Type");

        router.route().handler(corsHandler);

        router.route("/*")
                .handler(StaticHandler.create("assets"));

        vertx.createHttpServer()
                .requestHandler(router::accept)
                .listen(
                        // Retrieve the port from the configuration,
                        // default to 8080.
                        config().getInteger("http.port", 8082),
                        result -> {
                            if (result.succeeded()) {
                                fut.complete();
                            } else {
                                fut.fail(result.cause());
                            }
                        }
                );
    }
}
