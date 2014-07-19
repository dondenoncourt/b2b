import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Hibernate;
import org.hibernate.usertype.UserType;

public class TrimString implements UserType, Serializable {
	def SQL_TYPES = [Hibernate.STRING.sqlType()];
	
    public TrimString() {}

    public int[] sqlTypes() { return SQL_TYPES   }
    public Class returnedClass() { String.class  }
    public boolean equals(Object x, Object y) {
        return (x == y) || (x != null && y != null && (x.equals(y)))
    }
    public Object nullSafeGet(ResultSet inResultSet, String[] names, Object o)
        throws SQLException {
        String val =
            (String) Hibernate.STRING.nullSafeGet(inResultSet, names[0]);
        return StringUtils.stripEnd(val, ' ') //	remove trailling spaces, previously used: StringUtils.trim(val)
    }
    public void nullSafeSet(PreparedStatement inPreparedStatement, Object o, int i)
        throws SQLException {
        String val = (String) o;
        inPreparedStatement.setString(i, val);
    }
    public Object deepCopy(Object o) {
        if (o == null) {
            return null
        }
        return new String(((String) o))
    }
    public boolean isMutable() { return false  }
    public Object assemble(Serializable cached, Object owner) { return cached }
    public Serializable disassemble(Object value) { return (Serializable) value }
    public Object replace(Object original, Object target, Object owner) { original }
    public int hashCode(Object x) {x.hashCode() }
}
