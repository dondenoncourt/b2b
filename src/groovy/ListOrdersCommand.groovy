import java.io.Serializable;
// note: not all page inputs are in here, only those that required sophisticated validation
public class ListOrdersCommand implements Serializable {
    Date fromInvoiceDate
    Date toInvoiceDate

    static constraints = {
    	fromInvoiceDate validator: {fromInvoiceDate, obj ->
    			if (fromInvoiceDate && (!obj.toInvoiceDate || fromInvoiceDate > obj.toInvoiceDate)) {
    				return false
    			}
		    }
		toInvoiceDate validator: {toInvoiceDate, obj ->
			if (toInvoiceDate && !obj.fromInvoiceDate) {
				return false
			}
	    }
    }
}