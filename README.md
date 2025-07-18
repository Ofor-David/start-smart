# 📊 StartSmart – Serverless User Activity Analytics Platform

*🛑 This project is an open-source learning project under active developent. Expect bugs, rapid changes, and missing features.* 

## Overview

StartSmart is a serverless, cloud-native platform for ingesting, storing, and analyzing user activity data (e.g., logins, clicks, purchases) at scale. Built for internal teams to gain behavioral insights with minimal infrastructure overhead.

- **Scalable & cost-effective** (targeting <$100/month at MVP scale)
- **Supports real-time and historical queries**
- **Strictly serverless – no EC2, ECS, or containers**

## Architecture (MVP)

```text
Clients (Web & Mobile)
        ↓
 API Gateway (REST API)
        ↓
  Lambda (Validation)
        ↓
Kinesis Firehose (Buffering & Delivery)
        ↓
     Amazon S3 (Partitioned by YYYY/MM/DD)
        ↓
AWS Glue → Athena → QuickSight Dashboards
```

### Deliverables
- 📐 Architecture diagram + rationale
- ☁️ Terraform IaC (or manual setup)
- 🧾 Event schema (JSON)
- 🔐 IAM policies + encryption strategy
- 📊 QuickSight dashboards for KPIs
- 📘 Documentation (README, cost breakdown)