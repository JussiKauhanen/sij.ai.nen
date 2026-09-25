# sij.ai.nen – Sijainen

Simple mockups for agentic meetings.

> *Sijainen* (Finnish) = stand-in, substitute.

An AI agent that sits in Microsoft Teams meetings on your behalf and follows the discussion. When someone needs you, it drafts an answer from your own docs and pings your phone. You approve, and it posts the answer to the meeting chat. If it can't find an answer, it just pings you.

**Status:** proof of concept (PoC). The landing page is live on GitHub Pages; the agent itself is not built yet.

**Live page:** `https://jussikauhanen.github.io/sij.ai.nen/`

---

## How it works

1. **Listens:** a bot joins the Teams meeting as your stand-in and transcribes it live.
2. **Detects:** an LLM (large language model) watches the rolling transcript for your name, your topics, or questions aimed at you.
3. **Drafts:** it searches your docs, tickets and past meeting notes (Confluence, Jira, SharePoint) and drafts a short answer with its sources. If nothing relevant is found, it drafts nothing and says so.
4. **Pings you:** a push notification lands on your phone with the question, the draft and the sources.
5. **You approve:** post the draft as is, edit it, join the call in one tap, or defer. Nothing is posted without your tap.

Approved answers are posted to the meeting chat as text, labelled *"Mikko (via Sijainen, approved)"*. After the meeting you get a summary with decisions and your action items.

## Scope

| Version | Scope | Status |
|---|---|---|
| **V1** | Listen, detect mentions, ping, summary. Read-only. | **In scope.** High feasibility: 1–2 weeks with a meeting-bot vendor. |
| **V2** | Draft answers with RAG (retrieval-augmented generation: look things up, then answer) over your docs. You approve on phone, bot posts to chat. | **In scope.** Medium feasibility: getting the right context and tenant security approval are the real work, not the LLM. |
| ~~V3~~ | Speaks in the meeting via TTS (text-to-speech), answers autonomously. | **Out of scope.** Voice latency, turn-taking and unapproved commitments aren't reliable enough in 2026. |

### Honest limits

- **Retrieval quality decides everything.** Stale or duplicated docs produce confident, wrong drafts. Always show sources and start with a small, curated set of spaces or projects.
- **Permissions:** the drafter must only see what the user can see. Search on the user's behalf with their token (Microsoft Graph and Atlassian OAuth), not with a service account that can read everything.
- **Timing:** a draft takes around 5–15 s and your approval takes a bit longer, so answers arrive in chat 20–60 s after the question. That's fine for chat, and is why voice is out.
- **Finnish speech-to-text** is weaker than English, so a misheard question gives a wrong draft. The question is shown next to the draft so you can spot it.

## Architecture (planned)

```
Teams meeting
     │  audio / transcript
     ▼
[bot]       meeting-bot vendor (e.g. Recall.ai); later own Teams media bot
     │  transcript chunks (webhook / websocket)
     ▼
[detector]  LLM checks rolling ~30 s window: mention? question for user?
     │  question event
     ▼
[drafter]   search user's sources (as the user) -> LLM drafts answer + citations
     │  question + draft + sources   (or "no answer found")
     ▼
[notifier]  push to phone (FCM / APNs / Teams chat)
     │
     ▼
[app]       approve / edit / join / later
     │  approved text only
     ▼
[bot]       posts to meeting chat, labelled "via Sijainen, approved"
```

Abbreviations: FCM = Firebase Cloud Messaging (Android push), APNs = Apple Push Notification service, PWA = progressive web app, OAuth = the standard "sign in and grant access" protocol.

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
│   ├── drafter/           retrieval (RAG) and answer drafting
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
| Search index (RAG) | Bedrock Knowledge Bases or OpenSearch Serverless | Azure AI Search |
| Source connectors | Custom ingestion (Lambda) | Graph connectors / Copilot retrieval API, or custom ingestion |
| Push | SNS (to FCM/APNs) | Notification Hubs |

For a Teams-first product in a Microsoft 365 organization, **Azure is the easier sell**: same tenant, Entra ID (formerly Azure AD) sign-in, and security teams already know it. With drafting in scope this matters more, because SharePoint and OneDrive content is reached through Microsoft Graph with the user's own permissions. AWS is fine if that's where the rest of your stack lives.

See `infra/aws/README.md` and `infra/azure/README.md`.

## Privacy and compliance

The bot records people, so before any real use:

- **Consent:** the bot must be visible and named, and participants informed. Teams shows a recording banner.
- **GDPR** (EU General Data Protection Regulation): define lawful basis, retention and deletion; keep data in the EU.
- **EU AI Act:** disclose that participants are interacting with an AI. Every posted answer is labelled as coming via Sijainen.
- **Accountability:** the user approves every posted message, and approved text, sources and timestamps are logged.
- **Finland:** workplace monitoring may require co-operation (YT) procedures with employees.
- **Tenant policy:** many organizations block external bots in Teams, so get IT/security approval early.

This is not legal advice; check with your legal team.

## License

TBD.
