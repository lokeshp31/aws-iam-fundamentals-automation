# AWS IAM Fundamentals Automation (Least-Privilege, MFA, Audits)

**Purpose:** Professional, interview-ready IAM project for your GitHub/portfolio. Demonstrates user & group provisioning, least-privilege policies, trust policies for roles, MFA guardrails, policy simulation evidence, and automated weekly audit reporting.

> Tip for screenshots: keep your AWS **Account ID masked** (e.g., blur all but the last 4 digits) and include a **timestamp**.

---

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
   ```

> Add screenshots to `docs/screenshots/` (see the list below), commit, and push to GitHub.

---

## What to Screenshot (for your portfolio)

| # | Screenshot | Where | Why |
|---|------------|------|-----|
| 1 | Users/Groups overview | IAM Console → Users & Groups | Proves provisioning matches scripts |
| 2 | Group attached policies | IAM Console → Groups → Policies tab | Shows least-privilege + guardrail |
| 3 | Trust policies | IAM Console → Roles → Trust relationships | Demonstrates role-based access |
| 4 | Policy Simulator results | Terminal or saved file | Evidence of Allow vs ExplicitDeny |
| 5 | Audit CSV open | `docs/evidence/weekly-audit-YYYY-MM-DD.csv` opened in Excel | Shows governance reporting |
| 6 | (Optional) MFA Deny | Terminal/API call failing without MFA (if configured) | Compliance evidence |

Put images in `docs/screenshots/` and link them from this README.

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

---

## Clean Up (important)
Run the cleanup script to detach policies and delete lab resources:
```bash
bash scripts/90_cleanup.sh
```

---

## Talking Points for Interviews / README
- Automated IAM provisioning (users, groups, roles) via AWS CLI & JSON policies.
- Implemented least-privilege RBAC and explicit Deny for high-risk actions.
- Created trust policies for EC2 and cross-account scenarios; attached managed ReadOnlyAccess.
- Enforced MFA guardrail (deny all but list/identity calls if no MFA).
- Validated access with the Policy Simulator and produced an auditable weekly access report.
- All steps documented; evidence saved to repository.
