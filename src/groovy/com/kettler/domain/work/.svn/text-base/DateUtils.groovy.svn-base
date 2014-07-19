package com.kettler.domain.work

import java.text.SimpleDateFormat;

public class DateUtils {
	private static SimpleDateFormat dateFormatYYMMDD = new SimpleDateFormat("yyMMdd");

	static int getTime(Date date) {
		def cal = new GregorianCalendar(TimeZone.getTimeZone("EST"),  Locale.US)
		cal.setTime(date)
		return cal.get(Calendar.HOUR_OF_DAY) * 10000 + 
		       cal.get(Calendar.MINUTE) * 100 +
		       cal.get(Calendar.SECOND)		
	}
	
	static Date buildDate(String year, String month, String day) {
		GregorianCalendar cal = new GregorianCalendar()
		cal.set(year.toInteger(), month.toInteger()-1, day.toInteger())
		return cal.time
	}
	
	static Date getYearOne() {
		return new GregorianCalendar(0,0,1).time
	}
	
	static int getNowYMD() {
		GregorianCalendar cal = new GregorianCalendar ()
		cal.time = new Date()
		return (cal.get(Calendar.YEAR) % 100 * 10000)  + ((cal.get(Calendar.MONTH)+1) * 100) + cal.get(Calendar.DAY_OF_MONTH)
	}
	static Date getBeginningOfTime() {
		GregorianCalendar cal = new GregorianCalendar ()
		cal.set(1, 0, 1, 0, 0, 0)
		return cal.time 
	}
	static Date getEndOfTime() {
		GregorianCalendar cal = new GregorianCalendar ()
		cal.set(2039, 11, 31, 0, 0, 0)
		return cal.time
	}
	static boolean isEndOfTime(Date date) {
		if (!date) {
			return false
		}
		GregorianCalendar cal = new GregorianCalendar ()
		cal.time = date 
		return  cal.get(Calendar.YEAR)         == 2039 && 
				cal.get(Calendar.MONTH)        == 11    &&  // September with 0 index  
				cal.get(Calendar.DAY_OF_MONTH) == 31
		
	}
	static int getYMD(Date date) {
		return new Integer(dateFormatYYMMDD.format(date));
	}
}
