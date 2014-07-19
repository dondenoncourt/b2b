import org.hibernate.*;
import org.hibernate.usertype.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.io.Serializable;

public class YesBlankType implements UserType {

	def SQL_TYPES = [Hibernate.STRING.sqlType()];

	public int[] sqlTypes() {
		return SQL_TYPES;
	}

	public Class returnedClass() {
		return Boolean.class;
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
		String yesNo = resultSet.getString(names[0]);
		if (!resultSet.wasNull()) {
			return  'Y' == yesNo
		}
		return null;
	}

	public void nullSafeSet(PreparedStatement statement, Object value, int index)
	throws HibernateException, SQLException {
		if (value == null || !value) {
			statement.setString(index, ' ');
		} else {
			statement.setString(index, 'Y');
		}
	}

	public Object deepCopy(Object value) throws HibernateException { return value; }

	public boolean isMutable() { return false; }

	public Object replace(Object original, Object target, Object owner) { return original; }

	public Object assemble(Serializable cached, Object owner) { return cached; }

	public Serializable disassemble(Object value) { return (Serializable) value; }

	public int hashCode(Object x) { return x.hashCode(); }

}
