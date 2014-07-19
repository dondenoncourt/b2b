import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import groovy.sql.Sql
import grails.util.Environment
import com.kettler.domain.item.share.Dealer
import com.kettler.domain.item.share.DealerLocation
import com.kettler.domain.item.share.DealerInventory

class DeleteInactiveDealersJob {
    def cronExpression = "0 3 0 * * ?" // 0:03AM"
    //def cronExpression = "0 * * * * ?" // every minute
    def sessionFactory

    def execute() {
        log.debug "DeleteInactiveDealersJob processing begin"
        def stmt = 
        """select d.id from ${CH.config.inventoryLib}${(Environment.current == Environment.TEST?'':'.')}dealer d 
        inner join ${CH.config.accountingLib}${(Environment.current == Environment.TEST?'':'.')}custmast c 
          on d.customer_id = c.id 
         and c.mactv = 'I'"""
        log.debug "DeleteInactiveDealersJob SQL: $stmt"
        Sql sql = new Sql(sessionFactory.getCurrentSession().connection())
		sql.query (stmt.toString()) {rs ->   
			while (rs.next()) {
				Dealer dealer = Dealer.get(rs.getString('id').toInteger())
				assert dealer
				log.info "deleting dealer with inactive customer status: $dealer.customer.custNo : $dealer.customer.name "
				dealer.locations.each {location ->
					location.inventories.each {inventory -> 
						inventory.delete()
					}
					location.delete()
				}
				dealer.divisions.each {division ->
					println "about to delete dealer_division id $division.id"
					String deleteDealer = "delete from ${CH.config.inventoryLib}${(Environment.current == Environment.TEST?'':'.')}dealer_division where dealer_id = $dealer.id"
					println deleteDealer
				    sql.execute deleteDealer 
				}
				dealer.delete()
			}
        }
        log.debug "DeleteInactiveDealersJob processing done"
    }
}
 