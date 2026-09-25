# bot

Joins Teams meetings as the user's stand-in, streams the transcript, and posts approved answers to the meeting chat.

- **PoC path:** meeting-bot vendor (e.g. Recall.ai). Create a bot with the meeting URL, receive real-time transcript via webhook, send chat messages through the vendor API.
- **Later:** own Teams real-time media bot (Microsoft Graph Communications API). Months of work, Windows hosting required.
- **Text only:** the bot never speaks. It posts only text the user has approved, prefixed "Name (via Sijainen, approved)".

Output: transcript chunks `{meetingId, speaker, text, ts}` sent to the queue.
