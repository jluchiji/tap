# Group User Accounts

# Find [/api/users/:prefix]

# GET

*Does not require `X-Tap-Auth` header.*  
Finds users whose usernames begin with the `:prefix`.

  + Response 200 (application/json; charset=utf-8)

        <!-- include(res/get-users-200.json) -->



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
