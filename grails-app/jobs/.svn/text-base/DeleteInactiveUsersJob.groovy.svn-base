import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import groovy.sql.Sql
import com.kettler.domain.orderentry.share.WebUser
import grails.util.Environment

class DeleteInactiveUsersJob {
    def cronExpression = "0 3 0 * * ?" // 0:03AM"
    def sessionFactory

    def execute() {
        log.debug "DeleteInactiveUsersJob processing begin"
        def stmt = 
        """select w.id from ${CH.config.orderEntryLib}${(Environment.current == Environment.TEST?'':'.')}webuser w 
        inner join ${CH.config.accountingLib}${(Environment.current == Environment.TEST?'':'.')}custmast c 
          on w.custNo = c.mcust 
         and c.mactv = 'I'"""
        println "SQL statement: $stmt"
        Sql sql = new Sql(sessionFactory.getCurrentSession().connection())
		sql.query (stmt.toString()) {rs ->   
			while (rs.next()) {
				WebUser user = WebUser.get(rs.getString('id').toInteger())
				assert user
				log.info "deleting web user with inactive customer status: $user"
				user.delete()
			}
        }
        log.debug "DeleteInactiveUsersJob processing done"
    }
}
