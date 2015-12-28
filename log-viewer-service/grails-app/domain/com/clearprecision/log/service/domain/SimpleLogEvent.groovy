package com.clearprecision.log.service.domain

/**
 * Created by tony on 27/12/15.
 */
class SimpleLogEvent {

    Integer id
    String callerClass
    String callerFilename
    String callerLine
    String callerMethod
    String formattedMessage
    String levelString
    String timestmp

}
