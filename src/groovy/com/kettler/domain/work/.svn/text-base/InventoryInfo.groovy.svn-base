package com.kettler.domain.work

class InventoryInfo implements Serializable {
	int qtyOnHand
	int qtyOnBackOrder
	int qtyAlloc
	int qtyOnCredHold
	int qtyFutureShip
	int avail 
	static int INV_AVAIL_FUDGE_FACTOR = 3
	
	boolean isAvailable(int orderQty) { 
		(qtyOnHand - qtyAlloc - orderQty - INV_AVAIL_FUDGE_FACTOR > 0) ? true : false
	}
}
