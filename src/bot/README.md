# bot

Joins Teams meetings as the user's stand-in and streams the transcript.

- **PoC path:** meeting-bot vendor (e.g. Recall.ai). Create a bot with the meeting URL, receive real-time transcript via webhook.
- **Later:** own Teams real-time media bot (Microsoft Graph Communications API). Months of work, Windows hosting required.

Output: transcript chunks `{meetingId, speaker, text, ts}` sent to the queue.
