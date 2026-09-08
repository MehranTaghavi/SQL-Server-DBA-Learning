# SQL Server DBA Learning

> A practical, structured path from T-SQL fundamentals to production-grade SQL Server administration.

This repository is a living learning portfolio by **Mehran Taghavi Afkham**. It combines runnable T-SQL exercises, DBA notes, operational checklists, and end-to-end projects. Every topic is organized so that a learner can start with the README, run the examples in SQL Server Management Studio, and then extend them with their own experiments.

## Learning map

| Chapter | Focus | Status |
| --- | --- | --- |
| [01-TSQL](./01-TSQL) | Querying and T-SQL problem solving | In progress |
| [02-Database-Fundamentals](./02-Database-Fundamentals) | Relational design and data integrity | Roadmap |
| [03-Backup-Restore](./03-Backup-Restore) | Recovery models and restore strategy | Roadmap |
| [04-Security](./04-Security) | Principals, permissions, and auditing | Roadmap |
| [05-SQL-Agent](./05-SQL-Agent) | Jobs, alerts, and automation | Roadmap |
| [06-Monitoring](./06-Monitoring) | Health checks and operational visibility | Roadmap |
| [07-Troubleshooting](./07-Troubleshooting) | A repeatable incident workflow | Roadmap |
| [08-Performance-Tuning](./08-Performance-Tuning) | Plans, indexes, statistics, Query Store, and DMVs | Roadmap |
| [09-High-Availability](./09-High-Availability) | Availability, failover, and disaster recovery | Roadmap |
| [10-ETL-SSIS](./10-ETL-SSIS) | Reliable data movement and ETL design | Roadmap |
| [11-SSDT](./11-SSDT) | Version-controlled database development | Roadmap |
| [12-Projects](./12-Projects) | Portfolio projects that combine the skills | In progress |

## How to use this repository

1. Use SQL Server 2019+ with SSMS or Azure Data Studio.
2. Read the chapter README before running a script.
3. Run scripts in a disposable learning database unless the file says otherwise.
4. Record observations, execution plans, and remediation steps in the relevant chapter.

Scripts are intentionally small and focused. Where possible, an exercise creates its own sample data so it can be reproduced without an external download.

## Conventions

- `README.md` explains the learning goal and prerequisites for a folder.
- `.sql` files are runnable examples or exercises and use SQL Server T-SQL.
- Destructive statements are limited to clearly named learning objects; never run them against production.
- New topics should follow the numbered chapter structure and include a short README.

## Portfolio

The repository is designed to show both query-writing ability and operational DBA thinking: safe changes, measurable performance work, recovery planning, and clear documentation.
