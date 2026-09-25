# detector

Reads transcript chunks, keeps a rolling ~30 s window per meeting, and asks an LLM:

- Was the user mentioned (name, nickname, role, owned topics)?
- Is a question directed at the user?
- Is a decision being made that affects the user?

Emits `{meetingId, type, quote, context, confidence}` events to the notifier.
Tune for precision: a missed ping is annoying, a stream of false pings kills the product.
