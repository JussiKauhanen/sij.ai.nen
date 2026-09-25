# drafter

Turns a detected question into a short draft answer with sources, or reports that it found nothing.

1. **Query:** rewrite the question with meeting context (topic, last ~2 min of transcript).
2. **Retrieve as the user:** search Confluence, Jira, SharePoint and past meeting summaries with the user's own OAuth token, so it only sees what they can see.
3. **Draft:** LLM writes 1–3 sentences, grounded only in the retrieved passages, with citations.
4. **Guardrails:**
   - No relevant sources, or low confidence: send "no answer found", not a guess.
   - Never commit to dates, money or scope unless a source says so.
   - Keep drafts short, since they go to a chat.

Output: `{questionId, draft, sources[{title, url, system}], confidence}` to the notifier.
Nothing is posted from here. Only the app's approve action triggers the bot to post.
