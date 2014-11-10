package net.unicon.cas.passwordmanager.flow;

import java.util.List;

import net.unicon.cas.passwordmanager.service.PasswordManagerLockoutService;
import net.unicon.cas.passwordmanager.service.PasswordManagerService;
import org.springframework.webflow.action.AbstractAction;
import org.springframework.webflow.execution.Event;
import org.springframework.webflow.execution.RequestContext;
import net.unicon.cas.passwordmanager.UserLockedOutException;

/**
 * <p>Action for checking the responses to users' security questions.</p>
 */
public class CheckSecurityQuestionResponseAction extends AbstractAction {
    
    private static final String RESPONSE_PARAMETER_PREFIX = "response";

    private PasswordManagerLockoutService lockoutService;
	private PasswordManagerService passwordManagerService; 

    @Override
    protected Event doExecute(RequestContext req) throws Exception {
        
        boolean rslt = true;
        
        SecurityChallenge challenge = (SecurityChallenge) req.getFlowScope().get(LookupSecurityQuestionAction.SECURITY_CHALLENGE_ATTRIBUTE);
        if (challenge != null) {
            List<SecurityQuestion> questions = challenge.getQuestions(); 
            for (int i=0; i < questions.size(); i++) {
                String responseText = req.getRequestParameters().get(RESPONSE_PARAMETER_PREFIX + i);
                if (!questions.get(i).validateResponse(responseText)) {
                    rslt = false;
                    break;
                }
            }
        } else {
            rslt = false;  // Should not get here...
        }
        
        if (!rslt) {
        	try {
            	lockoutService.registerIncorrectAttempt((String)req.getFlowScope().get("username"));	
        	}
        	catch (UserLockedOutException e) {
            	passwordManagerService.setAccountLock((String)req.getFlowScope().get("username"));	
        	}
        	
        }
        
        return rslt ? success() : error(/* TODO:  Send error message to client */);

    }


	public void setLockoutService(PasswordManagerLockoutService lockoutService) {
		this.lockoutService = lockoutService;
	}
	public void setPasswordManagerService(
			PasswordManagerService passwordManagerService) {
		this.passwordManagerService = passwordManagerService;
	}

}
