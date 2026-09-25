# notifier

Sends push notifications to the user's phone and relays their response.

- Push: FCM (Android), APNs (iOS), or a Teams chat message as the simplest fallback.
- Payload: question, draft (if any), sources, meeting deep link.
- Response: `approve | edit(text) | join | later`. On approve or edit, tells the bot to post the text to the meeting chat.
- Rate-limit pings per meeting. Expire a draft if the meeting has moved on (for example, after 3 minutes).
