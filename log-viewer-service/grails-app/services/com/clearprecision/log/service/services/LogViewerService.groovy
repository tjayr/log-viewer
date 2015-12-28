package com.clearprecision.log.service.services

import com.clearprecision.log.service.domain.LoggingEvent
import groovy.json.JsonBuilder
import groovy.util.logging.Slf4j

/**
 * Created by tony on 25/12/15.
 */
@Slf4j
class LogViewerService {

    def getLogs() {
        def logs = LoggingEvent.list()

//        Long timestmp
//        String formattedMessage
//        String loggerName
//        String levelString
//        String threadName
//        Short referenceFlag
//        String arg0
//        String arg1
//        String arg2
//        String arg3
//        String callerFilename
//        String callerClass
//        String callerMethod
//        String callerLine

        logs.collect { event ->
          [timestamp: event.timestmp, message: event.formattedMessage, loggerName: event.loggerName,
                level: event.levelString, thread: event.threadName, callerClass: event.callerClass,
                callerMethod: event.callerMethod, callerLine: event.callerLine, callerfilename: event.callerFilename,
                arg0: event.arg0 ?: "", arg1: event.arg1 ?: "", arg2: event.arg3 ?: "", arg3: event.arg3 ?: ""
          ]
        }

    }

}
