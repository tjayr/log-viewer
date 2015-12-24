package com.clearprecision.logger;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.*;

/**
 * Created by tony on 24/12/15.
 */
public class LogGenerator {

    private static final Logger log = LoggerFactory.getLogger(LogGenerator.class);


    public void log(Runnable producer) throws InterruptedException {
        ScheduledExecutorService service = Executors.newScheduledThreadPool(1);
        service.scheduleWithFixedDelay(producer, 10, 3, TimeUnit.SECONDS);
        Thread.sleep(60 * 1000);
        service.shutdown();
        service.awaitTermination(1, TimeUnit.MINUTES);
    }


    public static void main(String args[]) throws Exception {
        System.out.println("Starting log generator");
        LogGenerator logGenerator = new LogGenerator();
        logGenerator.log(() -> log.debug("This is a test log message generated by the LogGenerator"));
    }

}