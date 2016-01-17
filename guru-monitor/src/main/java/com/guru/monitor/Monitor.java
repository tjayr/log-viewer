package com.guru.monitor;

import io.vertx.core.DeploymentOptions;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;

import java.util.Arrays;
import java.util.List;

/**
 * Created by tony on 17/01/16.
 */
public class Monitor {

    public static void main(String[] args) {

        Vertx vertx = Vertx.vertx();

        vertx.deployVerticle("com.guru.monitor.services.StatusPublisherVerticle");

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
}
