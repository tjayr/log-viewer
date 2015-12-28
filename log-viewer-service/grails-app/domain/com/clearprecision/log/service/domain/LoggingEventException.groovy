package com.clearprecision.log.service.domain

import org.apache.commons.lang.builder.EqualsBuilder
import org.apache.commons.lang.builder.HashCodeBuilder

class LoggingEventException implements Serializable {

	Long eventId
	Short i
	String traceLine
	LoggingEvent loggingEvent

	int hashCode() {
		def builder = new HashCodeBuilder()
		builder.append eventId
		builder.append i
		builder.toHashCode()
	}

	boolean equals(other) {
		if (other == null) return false
		def builder = new EqualsBuilder()
		builder.append eventId, other.eventId
		builder.append i, other.i
		builder.isEquals()
	}

	static belongsTo = [LoggingEvent]

	static mapping = {
		id composite: ["eventId", "i"]
		version false
	}

	static constraints = {
		traceLine maxSize: 254
	}
}
