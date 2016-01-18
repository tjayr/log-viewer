package com.guru.monitor;

import io.vertx.core.DeploymentOptions;
import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpMethod;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.handler.CorsHandler;
import io.vertx.ext.web.handler.StaticHandler;
import io.vertx.ext.web.handler.sockjs.BridgeOptions;
import io.vertx.ext.web.handler.sockjs.SockJSHandler;
import io.vertx.ext.web.handler.sockjs.SockJSHandlerOptions;

import java.util.Arrays;
import java.util.List;

/**
 * Created by tony on 17/01/16.
 */
public class Monitor {

    private Vertx vertx;

    public void start() {
        vertx = Vertx.vertx();
        startWorkers();
        startRoutes();
    }

    private void startWorkers(){
        vertx.deployVerticle("com.guru.monitor.services.StatusPublisherVerticle");
        vertx.deployVerticle("com.guru.monitor.services.HttpServerVerticle");

        List<String> instances = Arrays.asList("localhost");
        instances.forEach(element -> {
            JsonObject config = new JsonObject();
            config.put("host", element);
            DeploymentOptions options = new DeploymentOptions();
            options.setWorker(true);
            options.setConfig(config);
            vertx.deployVerticle("com.guru.monitor.services.SiteStatusVerticle", options);
        });

    }


    private void startRoutes() {
        Router router = Router.router(vertx);

        CorsHandler corsHandler = CorsHandler.create("*");
        corsHandler.allowedMethod(HttpMethod.GET);
        corsHandler.allowedMethod(HttpMethod.POST);
        corsHandler.allowedMethod(HttpMethod.PUT);
        corsHandler.allowedMethod(HttpMethod.DELETE);
        corsHandler.allowedHeader("Authorization");
        corsHandler.allowedHeader("Content-Type");

        router.route("/eventbus/*").handler(corsHandler);


        SockJSHandler sockJSHandler = SockJSHandler.create(vertx);
        BridgeOptions options = new BridgeOptions();
        sockJSHandler.bridge(options);

        router.route("/eventbus/*").handler(sockJSHandler);

    }


    public static void main(String[] args) {
        Monitor monitor = new Monitor();
        monitor.start();
    }
}
