# notifier

Sends push notifications to the user's phone and handles their response.

- Push: FCM (Android), APNs (iOS), or a Teams chat message as the simplest fallback.
- Actions: reply in meeting chat, join call (deep link), defer.
- Rate-limit pings per meeting.
