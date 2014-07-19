import com.kettler.domain.actrcv.share.Customer

class SelectCustomerCommand implements Serializable {
    String custNo

    static constraints = {
        custNo (blank:false, validator: {custNo, obj ->
        	obj.custNo = custNo.toUpperCase()
            def cust = Customer.findByCustNo(custNo.toUpperCase())
            return cust != null
       })
    }
}