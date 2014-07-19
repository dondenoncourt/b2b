import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class DeleteOldReturnsImagesJob {
    def cronExpression = CH.config.returns.image.delete.job.cron

    def execute() {
        log.debug "DeleteOldReturnsImagesJob processing begin"
        def deleteIfOlder = new Date() - ((CH.config.returns.image.delete.days).toInteger()) 
		new File(CH.config.returns.image.directory).eachFileMatch(~/RA.*/){file ->
			def created = new Date(file.lastModified())
			if (created < deleteIfOlder) {
				log.debug "${file.name} older than ${deleteIfOlder}, deleted"
				file.delete()
			}
		}
        log.debug "DeleteOldReturnsImagesJob processing done"
    }
}
