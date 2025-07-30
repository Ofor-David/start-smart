# Frontend

This frontend helps to simulate Events to test out the Backend.
It emmits a mock json event like this:
```json
{
  "title": "Test purchase",
  "description": "Triggered event type: purchase",
  "endTime": "2025-07-30T20:06:21.596Z",
  "startTime": "2025-07-30T19:06:21.596Z",
}
```
## Requirements
-  [NodeJs  & npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm/) installed.

## Setup Instructions
1. Clone the repository
2. Navigate to `frontend/` directory.
3. Run `npm install` to install dependendencies.
4. Rename `src/example_.env` to `src/.env` and make sure to update the *VITE_API_URL* variable with the invocation url of your aws api gateway.
4. Run `npm run dev` to start a localserver at `https://localhost:5173`

**NB**: Your api calls would return *\*failed to send event\** if you haven't provisioned the terraform resources yet.