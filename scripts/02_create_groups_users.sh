#!/usr/bin/env bash
set -euo pipefail
PROFILE=${PROFILE:-iam-labs}

echo "Creating groups..."
aws iam create-group --group-name FinanceRead --profile "$PROFILE" || true
aws iam create-group --group-name HRRead --profile "$PROFILE" || true
aws iam create-group --group-name DevOpsLimited --profile "$PROFILE" || true

echo "Creating users..."
for u in alice.finance bob.hr carol.devops; do
  aws iam create-user --user-name "$u" --profile "$PROFILE" || true
done

echo "Adding users to groups..."
aws iam add-user-to-group --user-name alice.finance --group-name FinanceRead --profile "$PROFILE"
aws iam add-user-to-group --user-name bob.hr --group-name HRRead --profile "$PROFILE"
aws iam add-user-to-group --user-name carol.devops --group-name DevOpsLimited --profile "$PROFILE"

echo "Done: users & groups."
