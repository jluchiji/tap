# Group Friends

# List [/api/users]

# GET

Gets a list of user's friends.

  + Request

    + Headers

        X-Tap-Auth: lMKjVTAxzlTmnTi4U3RqUDhvQUdPeUNRblVjYStKR05Jdz09

  + Response 200 (application/json; charset=utf-8)

        <!-- include(res/get-friends-200.json) -->


  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/friends-401.json) -->


# Add [/api/users]

# POST

Sends a friend invitation to a user.

  + Request (application/json)

    + Headers

        X-Tap-Auth: lMKjVTAxzlTmnTi4U3RqUDhvQUdPeUNRblVjYStKR05Jdz09

    + Body

        <!-- include(req/post-friends.json) -->


  + Response 200 (application/json; charset=utf-8)

        <!-- include(res/post-friends-201.json) -->

  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/friends-401.json) -->

  + Response 500 (application/json; charset=utf-8)

        <!-- include(res/post-friends-500.json) -->


# Accept Request [/api/users/{id}]

# PUT

Accepts the friend invitation send from a specific user.

  + Parameters

    + id (string) ... ID of the user who sent the friend request.

  + Request

    + Headers

        X-Tap-Auth: lMKjVTAxzlTmnTi4U3RqUDhvQUdPeUNRblVjYStKR05Jdz09


  + Response 200 (application/json; charset=utf-8)

        <!-- include(res/put-friends-200.json) -->


  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/friends-401.json) -->

# Remove [/api/users/{id}]

# DELETE

Removes the specified user from the friend list.

  + Parameters

    + id (string) ... ID of the user to remove.

  + Request

    + Headers

        X-Tap-Auth: lMKjVTAxzlTmnTi4U3RqUDhvQUdPeUNRblVjYStKR05Jdz09

  + Response 200 (application/json; charset=utf-8)

        <!-- include(res/delete-friends-200.json) -->

  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/friends-401.json) -->
