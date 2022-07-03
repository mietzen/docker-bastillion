# Full Environment Variable list:
_Dockerize is used to generate a configuration file for the application_

* **set to true to regenerate and import SSH keys**

   `RESET_APPLICATION_SSH_KEY` 

   _Default: "false"_


* **SSH key type 'dsa', 'rsa', or 'ecdsa' for generated keys**

   `SSH_KEY_TYPE` 

   Default: "rsa"


* **SSH key length for generated keys**

   2048 => 'rsa','dsa'; 521 => 'ecdsa'
   
   `SSH_KEY_LENGTH` 
   
   _Default: "2048"_

* **private ssh key**
   Provide **path** to private keyfile

   leave blank to generate key pair

   `SSH_PRIVATE_KEY` 

   _Default: ""_


* **public ssh key**
   Provide **path** to public keyfile

   leave blank to generate key pair

   `SSH_PUBLIC_KEY` 

   _Default: ""_

* **default passphrase** 

   leave blank for key without passphrase

   `defaultSSHPassphrase=${randomPassphrase}` 


* **enable audit**

   `ENABLE_INTERNAL_AUDIT`

   _Default: "false"_


* **keep audit logs for in days**

   `DELETE_AUDIT_LOG_AFTER`

   _Default:  "90"_

* **The number of seconds that the client will wait before sending a null packet to the server to keep the connection alive**

   `SERVER_ALIVE_INTERVAL` 

   _Default: "60"_


* **enable SSH agent forwarding**

   `AGENT_FORWARDING` 

   _Default: "false"_

* **enable two-factor authentication with a one-time password**

   'required', 'optional', or 'disabled'

   `ONE_TIME_PASSWORD` 

   _Default: "optional"_

* **set to false to disable key management**
   
   If false, the Bastillion public key will be appended to the authorized_keys file (instead of it being overwritten completely).
   
   `KEY_MANAGEMENT_ENABLED`
   
   _Default: "true"_

* **set to true to generate keys when added/managed by users and enforce strong passphrases set to false to allow users to set their own public key**

   `FORCE_USER_KEY_GENERATION` 

   _Default: "true"_

* **authorized_keys refresh interval in minutes**
   
   (no refresh for <=0)
   
   `AUTH_KEYS_REFRESH_INTERVAL` 
   
   _Default: "120"_


* **HTTP header to identify client IP Address**
  
  ('X-FORWARDED-FOR')
  
  `CLIENT_IP_HEADER` 

* **The session time out value of application in minutes**

   `SESSION_TIMEOUT`
   
   _Default: "15"_

* **Database user**

   `DB_USER` 
   
   _Default: "bastillion"_

* **Database password**

   `DB_PASSWORD`

* **Connection URL to the DB**

   `DB_CONNECTION_URL` 

   _Default: "jdbc:h2:keydb/bastillion;CIPHER=AES"_
