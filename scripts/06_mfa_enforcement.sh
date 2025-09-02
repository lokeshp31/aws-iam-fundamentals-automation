#!/usr/bin/env bash
set -euo pipefail
PROFILE=${PROFILE:-iam-labs}

echo "MFARequired policy is already attached to FinanceRead & DevOpsLimited via 03_attach_policies.sh."
echo "To demonstrate, attempt a non-list action without MFA using a user session token and show Deny (optional)."
echo "Note: Full MFA interactive setup is out-of-scope; this is a guardrail demonstration."
