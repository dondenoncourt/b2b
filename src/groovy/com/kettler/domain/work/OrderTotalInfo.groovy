package com.kettler.domain.work

class OrderTotalInfo implements Serializable {
	BigDecimal netAmount  = 0.0g
	BigDecimal miscAmount = 0.0g
	BigDecimal discAllowAmount = 0.0g
	BigDecimal salesAmount = 0.0g

	// not really used:
	BigDecimal tax = 0.0g
	BigDecimal taxableAmount1 = 0.0g
	BigDecimal taxableAmount2 = 0.0g
	BigDecimal taxableAmount3 = 0.0g

}
