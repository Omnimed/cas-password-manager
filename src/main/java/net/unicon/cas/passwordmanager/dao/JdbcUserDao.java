package net.unicon.cas.passwordmanager.dao;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import javax.sql.DataSource;

/**
 * <p>Dao to get user information.</p>
 */
public class JdbcUserDao {

	private final Log logger = LogFactory.getLog(this.getClass());
	
	private static final String RESPONSE_PARAMETER_PREFIX = "response";
	private static final String SELECT_USER = "SELECT PRENOM, USER_PART, DOMAIN_NAME, MAIN" +
			" FROM contact_email_address cea" +
			" INNER JOIN abstract_contact ac" +
			" ON cea.contact_id = ac.contact_id" +
			" INNER JOIN login_licences ll" +
			" ON ac.associated_user = ll.id_licence"+
			" WHERE ll.login = ?";
	
	private DataSource dataSource;
	private JdbcTemplate jdbcTemplate;
 
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	} 
	
	public String[] getEmail(String username) {
		String email = "";
		String prenom = "";
		jdbcTemplate = new JdbcTemplate(dataSource);
		
		Map result = jdbcTemplate.queryForMap(SELECT_USER, username);
		
		email = (String)result.get("USER_PART") + "@" + (String)result.get("DOMAIN_NAME");
		prenom = (String)result.get("PRENOM");
		logger.debug("email : " + email); 
		
		return new String[]{ prenom, email };
	}

}
