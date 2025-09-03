# AWS IAM Automation | Least-Privilege, MFA, Trust Policies & Audits

> Automating AWS IAM provisioning with least-privilege, MFA guardrails, and weekly compliance audits — ideal for IAM Analyst and Cloud Security roles.


## Live Repository
Explore the full project with scripts, JSON policies, and evidence:
[https://github.com/lokeshp31/aws-iam-fundamentals-automation](https://github.com/lokeshp31/aws-iam-fundamentals-automation)
 

## Tech Stack
- **AWS IAM** – User, group, role, and policy management
- **AWS CLI** – Automation scripts for provisioning and audits
- **Python 3** – Automated audit report generation
- **JSON** – Custom IAM and trust policies


## Prerequisites
- AWS account (use a **non-root**, sandbox **Admin** IAM user).
- **AWS CLI v2** installed and configured with a profile (this project uses `iam-labs` by default):
  ```bash
  aws configure --profile iam-labs
  ```
- Python 3.8+ (for the audit report script).

**Region:** Use your default; scripts are region-agnostic for IAM.

**Costs:** IAM + CloudTrail management events are free. No paid resources are created.

---

## Fake Company Scenario
- Departments: **Finance**, **HR**, **DevOps**
- Users: `alice.finance`, `bob.hr`, `carol.devops`
- Groups: `FinanceRead`, `HRRead`, `DevOpsLimited`
- Roles: `EC2ReadRole` (assumed by EC2), `CrossAccountReadOnly` (cross-account trust demo)

---

## How to Run (Step-by-Step)

1) **Clone or unzip** this repo locally.
2) (Optional) Verify AWS CLI & profile access:
   ```bash
   bash scripts/00_prereqs_check.sh
   ```
3) Make scripts executable:
   ```bash
   chmod +x scripts/*.sh
   ```
4) **Create users & groups**
   ```bash
   bash scripts/02_create_groups_users.sh
   ```
5) **Attach least-privilege & guardrail policies to groups**
   ```bash
   bash scripts/03_attach_policies.sh
   ```
6) **Create roles with trust policies and attach AWS ReadOnlyAccess**
   ```bash
   bash scripts/04_create_roles_trust.sh
   ```
7) **Validate with Policy Simulator** (captures evidence into `docs/evidence/policy-sim-results.txt`)
   ```bash
   bash scripts/05_policy_simulation.sh
   ```
8) **Enforce MFA guardrail** (Deny most actions if user does not use MFA)
   ```bash
   bash scripts/06_mfa_enforcement.sh
   ```
9) **Generate audit report** (CSV written to `docs/evidence/weekly-audit-YYYY-MM-DD.csv`)
   ```bash
   python3 scripts/07_audit_report.py

---

## Repo Structure
```
aws-iam-fundamentals-automation/
├── README.md
├── .gitignore
├── scripts/
│   ├── 00_prereqs_check.sh
│   ├── 02_create_groups_users.sh
│   ├── 03_attach_policies.sh
│   ├── 04_create_roles_trust.sh
│   ├── 05_policy_simulation.sh
│   ├── 06_mfa_enforcement.sh
│   ├── 07_audit_report.py
│   └── 90_cleanup.sh
├── policies/
│   ├── finance_read_only.json
│   ├── devops_least_priv.json
│   ├── s3_read_projectX.json
│   ├── deny_high_risk_actions.json
│   └── mfa_required.json
├── trust-policies/
│   ├── ec2_assume_role.json
│   └── cross_account_readonly.json
└── docs/
    ├── screenshots/        # add your images here
    └── evidence/           # policy-sim & audit CSV output
```



- All steps documented; evidence saved to repository.
