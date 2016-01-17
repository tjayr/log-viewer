package com.guru.monitor.services;

import io.vertx.core.AbstractVerticle;


/**
 * Created by tony on 17/01/16.
 */
public class StatusPublisherVerticle extends AbstractVerticle {

    @Override
    public void start() throws Exception {

        vertx.eventBus().consumer("siteStatus", event -> {

            String body = (String) event.body();
            System.out.println("Received from eventBus "+body);

        });

    }
}
