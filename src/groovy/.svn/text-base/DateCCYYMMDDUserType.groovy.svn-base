import org.hibernate.*;
import org.hibernate.usertype.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.*;
import java.text.SimpleDateFormat;
import java.io.Serializable;
import java.math.BigDecimal;
import com.kettler.domain.work.DateUtils

public class DateCCYYMMDDUserType implements UserType {

	def SQL_TYPES = [Hibernate.STRING.sqlType()];
	private static SimpleDateFormat dateFormatCCYYMMDD = new SimpleDateFormat("yyyyMMdd");

	public int[] sqlTypes() {
		return SQL_TYPES;
	}

	public Class returnedClass() {
		return Date.class;
	}

	public boolean equals(Object x, Object y) throws HibernateException {
		if (x == y) {
			return true;
		} else if (x == null || y == null) {
			return false;
		} else {
			return x.equals(y);
		}
	}

	public Object nullSafeGet(ResultSet resultSet, String[] names, Object owner)
	throws HibernateException, SQLException {
		Date result = null;
		BigDecimal dateAsDecimal = resultSet.getBigDecimal(names[0]);
		if (!resultSet.wasNull()) {
			if (0.equals(dateAsDecimal.intValue())) {
				//result = null issue with nullable:false
				result = DateUtils.getYearOne()
			} else {
				result = convertIntegerToDate(dateAsDecimal)
			}

		}
		return result;
	}

	public void nullSafeSet(PreparedStatement statement, Object value, int index)
	throws HibernateException, SQLException {
		if (value == null) {
			statement.setBigDecimal(index, new BigDecimal(0));
		} else {
			BigDecimal dateAsDecimal =
			convertDateToInteger((Date) value);
			statement.setBigDecimal(index, dateAsDecimal);
		}
	}

	public Object deepCopy(Object value) throws HibernateException { return value; }

	public boolean isMutable() { return false; }

	public Object replace(Object original, Object target, Object owner) { return original; }

	public Object assemble(Serializable cached, Object owner) { return cached; }

	public Serializable disassemble(Object value) { return (Serializable) value; }

	public int hashCode(Object x) { return x.hashCode(); }

	private Date convertIntegerToDate(BigDecimal someDate){
		Date date = new Date();
		try {
			date = dateFormatCCYYMMDD.parse(someDate.toString());
		} catch (Exception e) {
			e.printStackTrace()
			println e
		}
		return date;
	}

	private BigDecimal convertDateToInteger(Date someDate) {
		def cal = new GregorianCalendar()
		cal.setTime(someDate)
		// if year is 0001, assume empty date
		if (cal.get(Calendar.YEAR) == 1) {
			return 0g 
		}
		BigDecimal decDate = null;
		try {
			decDate = new BigDecimal(dateFormatCCYYMMDD.format(someDate));
		} catch (Exception e) {}
		return decDate;
	}
}
