# sij.ai.nen – Sijainen

Simple mockups for agentic meetings.

> *Sijainen* (Finnish) = stand-in, substitute.

An AI agent that sits in Microsoft Teams meetings on your behalf, follows the discussion, and pings your phone only when someone needs you or it can't answer a question itself.

**Status:** proof of concept (PoC). The landing page is live on GitHub Pages; the agent itself is not built yet.

**Live page:** `https://jussikauhanen.github.io/sij.ai.nen/`

---

## How it works (V1)

1. **Listens:** a bot joins the Teams meeting as your stand-in and transcribes it live.
2. **Detects:** an LLM (large language model) watches the rolling transcript for your name, your topics, or questions aimed at you.
3. **Pings you:** a push notification lands on your phone with the question and context.
4. **You act:** reply in the meeting chat, join the call in one tap, or defer.

After the meeting you get a summary with decisions and your action items.

## Roadmap

| Version | Scope | Feasibility (autumn 2026) |
|---|---|---|
| **V1** | Listen, detect mentions, ping, summary. Read-only. | High. 1–2 weeks with a meeting-bot vendor. |
| **V2** | V1 + RAG (retrieval-augmented generation) over your docs/Jira/Confluence. Drafts answers, you approve on phone, bot posts to chat. | Medium. Context quality and tenant security approval are the real work. |
| **V3** | Speaks in the meeting via TTS (text-to-speech), answers autonomously. | Low for real use. Latency, turn-taking and hallucinated commitments. |

## Architecture (planned)

```
Teams meeting
     │  audio / transcript
     ▼
[bot]  meeting-bot vendor (e.g. Recall.ai) or Teams real-time media bot
     │  transcript chunks (webhook / websocket)
     ▼
[detector]  LLM checks rolling ~30 s window: mention? question for user?
     │  event
     ▼
[notifier]  push to phone (FCM / APNs / Teams chat)
     │  user action
     ▼
[app]  mobile / PWA: reply, join, defer  ──►  bot posts reply to meeting chat
```

Abbreviations: FCM = Firebase Cloud Messaging (Android push), APNs = Apple Push Notification service, PWA = progressive web app.

## Repository structure

```
sij.ai.nen/
├── README.md
├── docs/                  GitHub Pages site (landing page)
│   ├── index.html         single-file page, no build step
│   ├── .nojekyll          serve files as-is, skip Jekyll processing
│   └── assets/
│       └── favicon.svg
├── src/                   agent code (placeholders)
│   ├── bot/               joins meetings, streams transcript
│   ├── detector/          LLM mention and question detection
│   ├── notifier/          push notifications
│   └── app/               mobile app / PWA
└── infra/                 infrastructure as code
    ├── aws/               Terraform, eu-north-1 (Stockholm)
    └── azure/             Bicep, Sweden Central
```

## GitHub Pages

The site is plain HTML in `docs/`, so no build or Actions workflow is needed.

1. Push to `main`.
2. In the repo: **Settings → Pages → Build and deployment**.
3. Source: **Deploy from a branch**, branch `main`, folder `/docs`, then **Save**.
4. The page is published at `https://jussikauhanen.github.io/sij.ai.nen/` within a minute or two.

All asset paths are relative, so the page works under the `/sij.ai.nen/` sub-path and on a custom domain. For a custom domain, add a `docs/CNAME` file containing the domain.

Preview locally:

```bash
cd docs && python3 -m http.server 8000
# open http://localhost:8000
```

## Cloud: AWS or Azure

Both folders under `infra/` are skeletons with the same components. Pick one.

| Component | AWS | Azure |
|---|---|---|
| Webhook / API | API Gateway + Lambda | Functions |
| Detector worker | Lambda or ECS Fargate | Functions or Container Apps |
| Queue | SQS | Service Bus |
| Transcript + state | DynamoDB | Cosmos DB |
| Secrets | Secrets Manager | Key Vault |
| LLM | Bedrock | Azure OpenAI / AI Foundry |
| Push | SNS (to FCM/APNs) | Notification Hubs |

For a Teams-first product in a Microsoft 365 organization, **Azure is the easier sell**: same tenant, Entra ID (formerly Azure AD) sign-in, and security teams already know it. AWS is fine if that's where the rest of your stack lives.

See `infra/aws/README.md` and `infra/azure/README.md`.

## Privacy and compliance

The bot records people, so before any real use:

- **Consent:** the bot must be visible and named, and participants informed. Teams shows a recording banner.
- **GDPR** (EU General Data Protection Regulation): define lawful basis, retention and deletion; keep data in the EU.
- **EU AI Act:** disclose that participants are interacting with an AI.
- **Finland:** workplace monitoring may require co-operation (YT) procedures with employees.
- **Tenant policy:** many organizations block external bots in Teams, so get IT/security approval early.

This is not legal advice; check with your legal team.

## License

TBD.
