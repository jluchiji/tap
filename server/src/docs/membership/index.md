# Group Membership

# List [/api/groups/:groupId/members]

# GET

Lists all members of the given group, including outstanding invitations.  
*Requires accepted group membership.*

  + Request

    + Headers

      X-Tap-Auth: lMKjVTAxzlTmnTi4U3RqUDhvQUdPeUNRblVjYStKR05Jdz09

  + Response 200 (application/json; charset=utf-8)

        <!-- include(res/get-members-200.json) -->

  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/members-401.json) -->

  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/members-401-a.json) -->

  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/members-401-b.json) -->

# Invite [/api/groups/:groupId/members]

# POST

Invites a user to become the group member.  
*Requires accepted group membership.*

  + Request

    + Headers

      X-Tap-Auth: lMKjVTAxzlTmnTi4U3RqUDhvQUdPeUNRblVjYStKR05Jdz09

    + Body (application/json; charset=utf-8)

        <!-- include(req/post-members.json) -->

  + Response 201 (application/json; charset=utf-8)

        <!-- include(res/post-members-201.json) -->

  + Response 400 (application/json; charset=utf-8)

        <!-- include(res/post-members-400.json) -->

  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/members-401.json) -->

  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/members-401-a.json) -->

  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/members-401-b.json) -->

# Accept [/api/groups/:groupId/members]

# PUT

Accepts an outstanding group member invitation.  
*Requires group membership; no effect for already accepted memberships.*


  + Request

    + Headers

      X-Tap-Auth: lMKjVTAxzlTmnTi4U3RqUDhvQUdPeUNRblVjYStKR05Jdz09


  + Response 200 (application/json; charset=utf-8)

        <!-- include(res/put-members-200.json) -->

  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/members-401.json) -->

  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/members-401-a.json) -->

  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/members-401-b.json) -->


# Leave [/api/groups/:groupId/members]

# DELETE

Removes the requesting user from the group.  
*Requires accepted group membership.*

  + Request

    + Headers

      X-Tap-Auth: lMKjVTAxzlTmnTi4U3RqUDhvQUdPeUNRblVjYStKR05Jdz09

  + Response 200 (application/json; charset=utf-8)

        <!-- include(res/delete-members-200.json) -->
        
  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/members-401.json) -->

  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/members-401-a.json) -->

  + Response 401 (application/json; charset=utf-8)

        <!-- include(res/members-401-b.json) -->
