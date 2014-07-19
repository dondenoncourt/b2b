import org.jsecurity.authc.credential.*
import org.jsecurity.authc.*
import com.kettler.domain.orderentry.share.WebUser
class AuthRealm {
		static authTokenClass = org.jsecurity.authc.UsernamePasswordToken
		CredentialsMatcher credentialMatcher 
		def authenticate(authToken) {
			def username = authToken.username
			if (username == null) {
					throw new AccountException('Null usernames are not allowed by this realm.')
			}
			def user = WebUser.findByEmail(username)
			if (!user) {
				throw new AccountException("no WebUser found for $username.")
			}
			// Now check the user's password against the hashed value stored
			// in the database.
			def account = new SimpleAccount(username, user.password, "kettlerRealm")
			if (!credentialMatcher.doCredentialsMatch(authToken, account)) {
				throw new IncorrectCredentialsException("Invalid password for $username")
			}
			return username
		}
	    def hasRole(principal, roleName) {
	        def user = WebUser.findByEmail(principal)
	        return roleName == user.role.name
	    }
		
}