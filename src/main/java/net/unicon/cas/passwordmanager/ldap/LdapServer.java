package net.unicon.cas.passwordmanager.ldap;

import javax.naming.directory.ModificationItem;

import net.unicon.cas.passwordmanager.flow.SecurityChallenge;

public interface LdapServer {
	
	public void ldapModify(String username, ModificationItem[] modificationItems);

	public void setAccountLock(String username);

	public void setAccountUnLock(String username);
	
	public void setMustChangePassword(String username) throws Exception;
	
	public void setPassword(String username, String password);
	
	public boolean verifyPassword(String username, String password);
	
	public SecurityChallenge getUserSecurityChallenge(String username);
	
	public void setUserSecurityChallenge(String username, SecurityChallenge securityChallenge);
	
	public SecurityChallenge getDefaultSecurityChallenge(String username);
	
	/**
	 * <p>Gets a user-specified description for logging purposes</p>
	 * @return server description
	 */
	public String getDescription();
}
