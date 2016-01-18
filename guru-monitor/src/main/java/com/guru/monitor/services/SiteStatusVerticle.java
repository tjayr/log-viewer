package com.guru.monitor.services;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Handler;
import io.vertx.core.http.HttpClient;
import io.vertx.core.http.HttpClientOptions;
import io.vertx.core.json.JsonObject;

/**
 * Created by tony on 17/01/16.
 */
public class SiteStatusVerticle extends AbstractVerticle {


    @Override
    public void start() throws Exception {
        super.start();

        System.out.println("Deploying SiteStatus verticle");

        JsonObject config = context.config();
        String host = config.getString("host");
        Integer sleep = config.getInteger("sleep", 5000);

        System.out.println("Starting");
        HttpClientOptions options = new HttpClientOptions()
                .setKeepAlive(false).setDefaultHost(host).setDefaultPort(7080);
        HttpClient httpClient = vertx.createHttpClient(options);

        vertx.setPeriodic(sleep, handler -> {
            System.out.println("check");
            httpClient.getNow("/", event -> {
                System.out.println("Status: " + event.statusCode());
                vertx.eventBus().publish("siteStatus", event.statusMessage());
            });
        });
    }


}
