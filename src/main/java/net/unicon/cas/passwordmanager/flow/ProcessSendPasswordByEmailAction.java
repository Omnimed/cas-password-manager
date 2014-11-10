package net.unicon.cas.passwordmanager.flow;

import net.unicon.cas.passwordmanager.dao.JdbcUserDao;

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

import java.net.InetAddress;
import java.util.Properties;
import java.util.Date;

import javax.mail.*;
import javax.mail.internet.*;

import com.sun.mail.smtp.*;

/**
 * <p>Action for sending the new password to the user's email adress.</p>
 */
public class ProcessSendPasswordByEmailAction extends AbstractAction {

	private final Log logger = LogFactory.getLog(this.getClass());
	
	private static final String RESPONSE_PARAMETER_PREFIX = "response";
	private PasswordManagerService passwordManagerService;
	private JdbcUserDao jdbcUserDao;

	public void setJdbcUserDao(JdbcUserDao jdbcUserDao) {
		this.jdbcUserDao = jdbcUserDao;
	}

	public void setPasswordManagerService(
			PasswordManagerService passwordManagerService) {
		this.passwordManagerService = passwordManagerService;
	}

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
			userInfo = jdbcUserDao.getEmail(username);
			emailContent = resourceBundle.getString("pm.sendPassword.email");
			emailContent = emailContent.replace("{0}", userInfo[0]);
			emailContent = emailContent.replace("{1}", newPassword);
			emailTitle = resourceBundle.getString("pm.sendPassword.header");
		}
		catch (Exception e) {
			logger.error("Exception : " + e);
		}
		
		boolean result = (userInfo.length > 0);
		
		if (result) {
			try {
				passwordManagerService.setUserPassword(username, newPassword);
				passwordManagerService.setMustChangePassword(username);
				sendEmail(emailTitle, emailContent, userInfo[1]);
				passwordManagerService.setAccountUnLock(username);
			}
			catch (Exception e) {
				logger.error("Exception : " + e);
				result = false;
			}
		}
		
		return result ? success() : error();

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
			t.connect("smtp.gmail.com", "support@omnimed.com", "Cookshire5");
			t.sendMessage(msg, msg.getAllRecipients());
			System.out.println("Response: " + t.getLastServerResponse());
			t.close();
		} catch (Exception e) { 
			logger.error("Exception : " + e);
		}
	}

}
