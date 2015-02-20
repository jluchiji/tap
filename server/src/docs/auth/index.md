# Group Authentication

# Authentication [/api/auth]

# Authenticatie [POST]

*Does not require `X-Tap-Auth` header.*  
Authenticates the user, and if successful, returns an authentication token for API access.

 + Request

        <!-- include(req/post-auth.json) -->


 + Response 200

        <!-- include(res/post-auth-200.json) -->


 + Response 401

        <!-- include(res/auth-401.json) -->


# Renew Token [GET]

Takes the **unexpired** and **non-secure** authentication token from the `Authorization` header
and extends its lifetime by one TTL duration. TTL duration can be changed in server configuration.

 + Response 200

        <!-- include(res/get-auth-200.json) -->

 + Response 401

        <!-- include(res/auth-401.json) -->


# Revoke All Tokens [DELETE]

Revokes **all** authentication tokens generated for the user and issues a new token for the requesting
client.

 + Response 200

        <!-- include(res/delete-auth-200.json) -->

 + Response 401

        <!-- include(res/auth-401.json) -->
