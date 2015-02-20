FORMAT: 1A

# Tap! Server
Documentation for **Tap!** server API.

## Authentication
Authentication is established by username and password. As a representation of authentication,
a credential token will be passed for every request made to the API, unless this documentation
states that the `X-Tap-Auth` header is not required.

An example of the `X-Tap-Auth` header:
```
X-Tap-Auth: lMKoN2tpUzV3LUXOVK9QIrhPUWpaTUNMaXFQWTlPQVdtN0ptSS9RPT0
```

## Errors
All errors return a body that looks like the following:
```
{
  "status": 404,
  "error": {
    "time": "11:42:44",
    "reason": "Error description."
  }
}
```
Some security-critical error descriptions may look too generic. In that case, please use the `time` field
to look for more information in server logs, which usually provide more detailed information as to why the
error occurred.

## Request Body  
All requests that have a body must have the following header:
```
Content-Type: application/json
```
As the header suggests, request body should be of JSON format.

<!-- include(src/docs/auth/index.md) -->

<!-- include(src/docs/user/index.md) -->

<!-- include(src/docs/friends/index.md) -->
