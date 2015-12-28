package com.clearprecision.log.service.controllers

import com.clearprecision.log.service.domain.LoggingEvent
import com.clearprecision.log.service.domain.LoggingEventException
import com.clearprecision.log.service.domain.LoggingEventProperty
import com.clearprecision.log.service.domain.SimpleLogEvent
import com.clearprecision.log.service.services.LogViewerService
import grails.converters.JSON
import groovy.util.logging.Slf4j;

@Slf4j
class LogViewerController {

    LogViewerService logViewerService

    def index = {
        render logViewerService.getLogs() as JSON
    }

    def show = {

        def logEvent = new LoggingEvent(
                id:1,
                callerClass: "Class",
                callerFilename: "callerfileName",
                callerLine: "line 20",
                callerMethod: "callerMethod",
                formattedMessage:"This is a log message",
                levelString: "DEBUG",
                timestmp: "123455667899",
                arg0: "arg0",
                arg1: "arg1",
                arg2: "arg2",
                arg3: "arg3",
                loggerName: "TestLogger",
                threadName: "Thread1",
                referenceFlag: "refFlag")


        def excp = new LoggingEventException(eventId: 1, i: 1, traceLine: "traceline", loggingEvent: logEvent)

        def logEventProperty = new LoggingEventProperty(loggingEvent: logEvent, eventId: 1, mappedKey: "mappedKey", mappedValue: "mappedValue")

        logEvent.loggingEventExceptions = [excp]
        logEvent.loggingEventProperties = [logEventProperty]

        def events = [logEvent]

        render events as JSON

    }
}