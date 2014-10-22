package net.unicon.cas.passwordmanager.flow.validator;

import java.util.List;

import javax.validation.constraints.Size;

import net.unicon.cas.passwordmanager.flow.model.ChangePasswordBean;
import net.unicon.cas.passwordmanager.ldap.LdapServer;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.binding.validation.ValidationContext;

public class ChangePasswordBeanValidator {

	// default regex accepts any password
	private final Log logger = LogFactory.getLog(this.getClass());
	private String passwordRegex = ".*";
	@Size(min=1)
	private List<LdapServer> ldapServers;
	
	public void validateChangePasswordView(ChangePasswordBean changePasswordBean,
			ValidationContext context) {
		
		MessageContext messageContext = context.getMessageContext();
		String oldPassword = changePasswordBean.getOldPassword();
		String newPassword = changePasswordBean.getNewPassword();
		String confirmNewPassword = changePasswordBean.getConfirmNewPassword();
		// we'll validate the username in the action object
		
		if(oldPassword == null || oldPassword.isEmpty()) {
			messageContext.addMessage(new MessageBuilder().error().source("oldPassword")
					.code("cas.pm.oldpassword.empty")
					.defaultText("Please enter your current password")
					.build());
		}
		
		if(newPassword == null || newPassword.isEmpty()) {
			messageContext.addMessage(new MessageBuilder().error().source("newPassword")
					.code("cas.pm.newpassword.empty")
					.defaultText("Please enter a new password")
					.build());
		} else {
			if(newPassword.equals(oldPassword)) {
				messageContext.addMessage(new MessageBuilder().error().source("newPassword")
						.code("cas.pm.newpassword.same")
						.defaultText("The new password must be different")
						.build());
			}
			if(!newPassword.matches(passwordRegex)) {
				messageContext.addMessage(new MessageBuilder().error().source("newPassword")
						.code("cas.pm.newpassword.weak")
						.defaultText("The password is too weak")
						.build());
			} else if(confirmNewPassword == null || !confirmNewPassword.equals(newPassword)) {
				messageContext.addMessage(new MessageBuilder().error().source("confirmNewPassword")
						.code("cas.pm.newpassword.mismatch")
						.defaultText("The passwords do not match")
						.build());
			}
		}
	}

	public void validateSetPassword(ChangePasswordBean changePasswordBean,
			ValidationContext context) {
		
		MessageContext messageContext = context.getMessageContext();
		String newPassword = changePasswordBean.getNewPassword();
		String confirmNewPassword = changePasswordBean.getConfirmNewPassword();
		String username = changePasswordBean.getUsername();
		
		if(newPassword == null || newPassword.isEmpty()) {
			messageContext.addMessage(new MessageBuilder().error().source("newPassword")
					.code("cas.pm.newpassword.empty")
					.defaultText("Please enter a new password")
					.build());
		} else {
			if(!newPassword.matches(passwordRegex)) {
				messageContext.addMessage(new MessageBuilder().error().source("newPassword")
						.code("cas.pm.newpassword.weak")
						.defaultText("The password is too weak")
						.build());
			} else if(confirmNewPassword == null || !confirmNewPassword.equals(newPassword)) {
				messageContext.addMessage(new MessageBuilder().error().source("confirmNewPassword")
						.code("cas.pm.newpassword.mismatch")
						.defaultText("The passwords do not match")
						.build());
			} else {
				for(LdapServer ldapServer : ldapServers) {
					if (ldapServer.verifyPassword(username, newPassword)) {
						logger.debug("cas.pm.newpassword.same :  " + changePasswordBean);
						messageContext.addMessage(new MessageBuilder().error().source("newPassword")
							.code("cas.pm.newpassword.same")
							.defaultText("The new password must be different")
							.build());
						
					}
				}
			}
		}
	}
	
	public void setPasswordRegex(String passwordRegex) {
		this.passwordRegex = passwordRegex;
	}

	public void setLdapServers(List<LdapServer> ldapServers) {
		this.ldapServers = ldapServers;
	}
}
