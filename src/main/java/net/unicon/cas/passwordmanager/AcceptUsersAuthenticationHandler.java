/*
 * Licensed to Jasig under one or more contributor license
 * agreements. See the NOTICE file distributed with this work
 * for additional information regarding copyright ownership.
 * Jasig licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file
 * except in compliance with the License.  You may obtain a
 * copy of the License at the following location:
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package net.unicon.cas.passwordmanager;

import java.security.GeneralSecurityException;
import java.util.Collections;
import java.util.Map;

import org.jasig.cas.authentication.handler.BadCredentialsAuthenticationException;
import org.jasig.cas.authentication.handler.support.AbstractUsernamePasswordAuthenticationHandler;
import org.jasig.cas.authentication.handler.AuthenticationException;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;

import javax.security.auth.login.AccountNotFoundException;
import javax.security.auth.login.FailedLoginException;
import javax.validation.constraints.NotNull;

public class AcceptUsersAuthenticationHandler extends AbstractUsernamePasswordAuthenticationHandler {

    /** The list of users we will accept. */
    @NotNull
    private Map<String, String> users;

    @Override
    protected boolean authenticateUsernamePasswordInternal(final UsernamePasswordCredentials credential)
            throws AuthenticationException {

        final String username = credential.getUsername();
        final String password = credential.getPassword();
        final String cachedPassword = this.users.get(username);

        if (cachedPassword == null) {
           throw new BadCredentialsAuthenticationException();
        }

        final String encodedPassword = this.getPasswordEncoder().encode(credential.getPassword());
        if (!cachedPassword.equals(encodedPassword)) {
            throw new BadCredentialsAuthenticationException();
        }
        
        return password.equals(cachedPassword);
    }

    /**
     * @param users The users to set.
     */
    public final void setUsers(final Map<String, String> users) {
        this.users = Collections.unmodifiableMap(users);
    }
}