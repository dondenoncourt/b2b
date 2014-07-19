import com.kettler.domain.orderentry.share.WebUser
import org.jsecurity.crypto.hash.Sha1Hash

WebUser user = WebUser.findByEmail("dondenoncourt@kettlerusa.com")
println "${user.firstname} ${user.lastname}"
user.password = new Sha1Hash("D3noncourt").toHex()
if (!user.hasErrors() && user.save()) {
  println "password changed"
} else {
  println "oops"
} 