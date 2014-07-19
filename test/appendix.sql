-- Appendix A 
delete from rtrnfgtdsc;
insert into r99files.rtrnfgtdsc (id, version, descr) values
(1,0,'Shipping and Handling'),
(2,0,'Drop Ship Charge'),
(3,0,'Inbound Handling Charge');


delete from rtrnstat;
insert into rtrnstat (code, collcklvl, descr) values
('RAREQ',  1, 'RA requested by customer or rep via website'),
('NEWRA',  2, 'RA created by sales'),
('NORA',   3, 'warehouse user enters new return without RA, sales review needed'),
('CMQUE',  4, 'CM not approved, questions need to be answered by sales assistant'),
('CMDIF',  5, 'return that has a discrepancy(ies) from original authorization, sales review needed'),
('CMPEN',  6, 'CM pending approval by management'),
('CMAPP',  7, 'Controller approves CM'),
('DENYD',  8, 'Controller does not approve CM'),
('CMFIN',  9, 'Assistant accounts receivable manager reviews and posts CM'),
('RAREJ', 99, 'return is rejected');

-- Appendix B Reason codes for returns:
delete from rtrnreas;
insert into rtrnreas (version, code, crs_reason_id) values
(0, 'DEFECTIVE MERCHANDISE', 'DM'),
(0, 'INSUFFICIENT PACKAGING', 'IN'),
(0, 'FREIGHT DAMAGE', 'FD'),
(0, 'FREIGHT LOST BY CARRIER', 'FL'),
(0, 'CUSTOMER RETURN', 'CR'),
(0, 'ORDER ENTRY ERROR', 'OE'),
(0, 'SHIPPING ERROR', 'SE'),
(0, 'RETAILER ERROR', 'RT'),
(0, 'INSIDE SALES ERROR', 'IE'),
(0, 'SALES REP ERROR', 'RE'),
(0, 'PAST DUE ACCOUNT', 'PD');
 
-- Appendix C Conditions codes for returned goods: 
delete from rtrncond;
insert into rtrncond (version, code) values
(0, 'NEW'),
(0, 'PACKAGING DAMAGED'),
(0, 'DEFECTIVE'),
(0, 'REPAIRABLE DAMAGE'),
(0, 'SUBSTANTIAL DAMAGE');


-- Appendix D Reason codes for disposition of goods:
delete from rtrndisp;
insert into rtrndisp (version, code) values
(0, 'RETURN TO STOCK'),
(0, 'SCRAPPED FOR PARTS'),
(0, 'RETURN TO MANUFACTURER'),
(0, 'SCRAPPED'),
(0, 'HELD FOR SALE AS SD'),
(0, 'FIELD DESTROY');

--Appendix E Reason codes for freight claim denials:
delete from rtrnnix;
insert into rtrnnix (version, code) values
(0, 'CUSTOMER DID NOT INSPECT'),
(0, 'INSUFFICIENT PACKAGING'),
(0, 'FILED TOO LATE');




