import com.kettler.domain.orderentry.share.OrderHeader
import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.orderentry.share.Role

import org.jsecurity.SecurityUtils

public class SelectOrderCommand implements Serializable {
    String compCode
    String orderNo

    static constraints = {
    	compCode (blank:false, inList:['01','02'])
    	orderNo (blank:false, matches:/^\d*$/, validator: {orderNo, obj ->
    		if (! (orderNo ==~ /^\d*$/)) {
    			return "not.numeric"
    		}
    		WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal())
            def ord = OrderHeader.findByCompCodeAndOrderNo(user.compCode, orderNo)
			if (ord &&
				((user.role.name == Role.REP_PLUS || user.role.name == Role.REP || user.role.name == Role.REP_ADMIN)  && ord.salesperson1 != user.salesperson.id) ||
				((user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN) && ord.custNo       != user.custNo)           ) {
				return "not.authorized"
			} else {
				return ord != null
			}
       })
    }
}
