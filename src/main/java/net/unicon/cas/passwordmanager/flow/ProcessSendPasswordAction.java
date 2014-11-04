package net.unicon.cas.passwordmanager.flow;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;
import java.util.ResourceBundle;
import java.lang.Exception;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import net.unicon.cas.passwordmanager.service.PasswordManagerService;
import org.springframework.webflow.action.AbstractAction;
import org.springframework.webflow.execution.Event;
import org.springframework.webflow.execution.RequestContext;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.context.i18n.LocaleContextHolder;

import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.net.InetAddress;
import java.util.Properties;
import java.util.Date;

import javax.mail.*;
import javax.mail.internet.*;

import com.sun.mail.smtp.*;

/**
 * <p>Action for sending the new password to the user's email adress.</p>
 */
public class ProcessSendPasswordAction extends AbstractAction {

	private final Log logger = LogFactory.getLog(this.getClass());
	
	private static final String RESPONSE_PARAMETER_PREFIX = "response";
	private PasswordManagerService passwordManagerService;

	@Override
	protected Event doExecute(RequestContext req) throws Exception {	
		String emailContent = "";	
		String emailTitle = "";
		String firstName = "";
		String[] userInfo = new String[2];
		String username = (String)req.getFlowScope().get("username");
		String newPassword = passwordManagerService.generatePassword();
		
		try {
		ResourceBundle resourceBundle = ResourceBundle.getBundle("messages", LocaleContextHolder.getLocale());
		
		logger.debug("Send the new password : " + newPassword + " by email for user :" + username);
		userInfo = getEmail(username);
		emailContent = resourceBundle.getString("pm.sendPassword.email");
		emailContent = emailContent.replace("{0}", userInfo[0]);
		emailContent = emailContent.replace("{1}", newPassword);
		emailTitle = resourceBundle.getString("pm.sendPassword.header");
		}
		catch (Exception e) {
			logger.debug("Exception : " + e);
		}
		
		boolean rslt = (userInfo.length > 0);
		
		if (rslt) {
			try {
				passwordManagerService.setUserPassword(username, newPassword);
				passwordManagerService.setMustChangePassword(username);
				sendEmail(emailTitle, emailContent, userInfo[1]);
				passwordManagerService.setAccountUnLock(username);
			}
			catch (Exception e) {
				logger.debug("Exception : " + e);
				rslt = false;
			}
		}
		
		return rslt ? success() : error();

	}

	public void setPasswordManagerService(
			PasswordManagerService passwordManagerService) {
		this.passwordManagerService = passwordManagerService;
	}
	
	private String[] getEmail(String username) {
		Connection dbConnection = null;
		PreparedStatement preparedStatement = null;
		String email = "";
		String prenom = "";
 
		String selectSQL = "SELECT PRENOM, USER_PART," +
			"DOMAIN_NAME, MAIN" +
			" FROM contact_email_address cea" +
			" INNER JOIN abstract_contact ac" +
			" ON cea.contact_id = ac.contact_id" +
			" INNER JOIN login_licences ll" +
			" ON ac.associated_user = ll.id_licence"+
			" WHERE ll.login = ?";
		
		try {
			dbConnection = getDBConnection();
			preparedStatement = dbConnection.prepareStatement(selectSQL);
			preparedStatement.setString(1, username);
 
			// execute select SQL stetement
			ResultSet rs = preparedStatement.executeQuery();
			
 
			while (rs.next()) { 
				if (rs.getBoolean("MAIN") || email == "") {
					email = rs.getString("USER_PART") + "@" +rs.getString("DOMAIN_NAME"); 
					prenom = rs.getString("PRENOM"); 
					logger.debug("email : " + email); 
				}
			}
 
		} catch (SQLException e) {
			logger.debug("Exception : " + e); 
		} finally {

			try {  
				if (preparedStatement != null) {
					preparedStatement.close();
				}
	 
				if (dbConnection != null) {
					dbConnection.close();
				}
			} catch (Exception e) { 
				logger.debug("Exception : " + e);
			}
 
		}
		return new String[]{ prenom, email };
	}

	 
	private Connection getDBConnection() {		
		Properties prop = new Properties();
		try {
			prop.load(new FileInputStream("webapps/cas/WEB-INF/jdbc.properties"));
			Connection dbConnection = null; 
			
			Class.forName(prop.getProperty("jdbc.driverClassName"));
			dbConnection = DriverManager.getConnection(prop.getProperty("jdbc.url"), prop.getProperty("jdbc.username"), prop.getProperty("jdbc.password"));
			return dbConnection; 
		} catch (SQLException e) { 
			logger.debug("Exception : " + e);
		}
		return dbConnection;
 
	}
	
	private void sendEmail(String title, String content, String email) {
		Properties props = null;
		Session session = null;
		Message msg = null;
		
		try {
			props = System.getProperties();
			props.put("mail.smtps.host","smtp.gmail.com");
			props.put("mail.smtps.auth","true");
			
			session = Session.getInstance(props, null);
			
			msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress("support@omnimed.com"));;
			msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email, false));
			msg.setSubject(title);
			msg.setText(content);
			msg.setHeader("X-Mailer", "Reset Password");
			msg.setSentDate(new Date());
			SMTPTransport t = (SMTPTransport)session.getTransport("smtps");
			t.connect("smtp.gmail.com", "support@omnimed.com", "********");
			t.sendMessage(msg, msg.getAllRecipients());
			System.out.println("Response: " + t.getLastServerResponse());
			t.close();
		} catch (Exception e) { 
			logger.debug("Exception : " + e);
		}
	}

}
