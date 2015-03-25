# Group Groups

# List [/api/groups]

# GET

Gets a list of groups the user is a member of.

  + Request

    + Headers

        X-Tap-Auth: lMKjVTAxzlTmnTi4U3RqUDhvQUdPeUNRblVjYStKR05Jdz09

  + Response 200 (application/json; charset=utf-8)

        <!-- include(res/get-groups-200.json) -->


  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/groups-401.json) -->

# Create [/api/groups]

# POST

Create a new group.  
*Group name does NOT have to be unique.*

  + Request (application/json)

    + Headers

        X-Tap-Auth: lMKjVTAxzlTmnTi4U3RqUDhvQUdPeUNRblVjYStKR05Jdz09

    + Body

        <!-- include(req/post-groups.json) -->


  + Response 201 (application/json; charset=utf-8)

        <!-- include(res/post-groups-201.json) -->


  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/groups-401.json) -->


# Update [/api/groups/:groupId]

# PUT

Renames the group.  
*Group name does NOT have to be unique.*

  + Request (application/json)

    + Headers

        X-Tap-Auth: lMKjVTAxzlTmnTi4U3RqUDhvQUdPeUNRblVjYStKR05Jdz09

    + Body

        <!-- include(req/post-groups.json) -->


  + Response 200 (application/json; charset=utf-8)

        <!-- include(res/put-groups-200.json) -->


  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/groups-401.json) -->


  + Response 404 (application/json; charset=utf-8)

        <!-- include(res/groups-404.json) -->


# Delete [/api/groups/:groupId]

# DELETE

Deletes the group and removes all members from it.

  + Request (application/json)

    + Headers

        X-Tap-Auth: lMKjVTAxzlTmnTi4U3RqUDhvQUdPeUNRblVjYStKR05Jdz09


  + Response 200 (application/json; charset=utf-8)

        <!-- include(res/put-groups-200.json) -->


  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/groups-401.json) -->


  + Response 404 (application/json; charset=utf-8)

        <!-- include(res/groups-404.json) -->
