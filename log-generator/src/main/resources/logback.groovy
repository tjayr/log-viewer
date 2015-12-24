import ch.qos.logback.classic.AsyncAppender
import ch.qos.logback.classic.db.DBAppender
import ch.qos.logback.classic.encoder.PatternLayoutEncoder
import ch.qos.logback.core.ConsoleAppender
import ch.qos.logback.core.FileAppender
import ch.qos.logback.core.db.DriverManagerConnectionSource

appender("FILE", FileAppender) {
    file = "build/testFile.log"
    append = true
    encoder(PatternLayoutEncoder) {
        pattern = "%level %logger - %msg%n"
    }
}

appender("CONSOLE", ConsoleAppender) {

    encoder(PatternLayoutEncoder) {
        pattern = "%-4relative [%thread] %-5level %logger{35} - %msg %n"
    }
}

appender("MYSQL", DBAppender) {
    connectionSource(DriverManagerConnectionSource) {
        driverClass = "com.mysql.jdbc.Driver"
        url="jdbc:mysql://localhost:3306/gurudev"
        user="root"
        password="admin"
    }

    encoder(PatternLayoutEncoder) {
        pattern = "[%date{yyyy-MM-dd'T'HH:mm:ss.SSSZ}] [%level] [%logger] [%thread] - %msg%n"
    }
}

appender("ASYNC", AsyncAppender) {
    ref="MYSQL"
}

root(DEBUG, ["MYSQL", "CONSOLE"])