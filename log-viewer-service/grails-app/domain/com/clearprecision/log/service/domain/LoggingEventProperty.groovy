package com.clearprecision.log.service.domain

import org.apache.commons.lang.builder.EqualsBuilder
import org.apache.commons.lang.builder.HashCodeBuilder

class LoggingEventProperty implements Serializable {

	Long eventId
	String mappedKey
	String mappedValue
	LoggingEvent loggingEvent

	int hashCode() {
		def builder = new HashCodeBuilder()
		builder.append eventId
		builder.append mappedKey
		builder.toHashCode()
	}

	boolean equals(other) {
		if (other == null) return false
		def builder = new EqualsBuilder()
		builder.append eventId, other.eventId
		builder.append mappedKey, other.mappedKey
		builder.isEquals()
	}

	static belongsTo = [LoggingEvent]

	static mapping = {
		id composite: ["eventId", "mappedKey"]
		version false
	}

	static constraints = {
		mappedKey maxSize: 254
		mappedValue nullable: true
	}
}
