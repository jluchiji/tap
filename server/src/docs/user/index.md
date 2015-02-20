# Group User Accounts

# Create [/api/users]

# POST

*Does not require `X-Tap-Auth` header.*  
Creates a new user account from the request body.

  + Request (application/json)

    + Headers


    + Body

        <!-- include(req/post-users.json) -->


  + Response 200 (application/json; charset=utf-8)

        <!-- include(res/post-users-201.json) -->


  + Response 500 (application/json; charset=utf-8)

        <!-- include(res/post-users-500.json) -->
