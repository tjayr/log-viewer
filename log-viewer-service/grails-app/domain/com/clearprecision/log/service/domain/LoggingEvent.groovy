package com.clearprecision.log.service.domain

class LoggingEvent {

	Long timestmp
	String formattedMessage
	String loggerName
	String levelString
	String threadName
	Short referenceFlag
	String arg0
	String arg1
	String arg2
	String arg3
	String callerFilename
	String callerClass
	String callerMethod
	String callerLine

	static hasMany = [loggingEventExceptions: LoggingEventException,
	                  loggingEventProperties: LoggingEventProperty]

	static mapping = {
		id column: "event_id"
		version false
	}

	static constraints = {
		formattedMessage nullable: true
		loggerName maxSize: 254
		levelString maxSize: 254
		threadName nullable: true, maxSize: 254
		referenceFlag nullable: true
		arg0 nullable: true, maxSize: 254
		arg1 nullable: true, maxSize: 254
		arg2 nullable: true, maxSize: 254
		arg3 nullable: true, maxSize: 254
		callerFilename maxSize: 254
		callerClass maxSize: 254
		callerMethod maxSize: 254
		callerLine maxSize: 4
	}
}
