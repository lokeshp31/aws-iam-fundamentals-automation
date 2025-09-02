#!/usr/bin/env bash
set -euo pipefail
PROFILE=${PROFILE:-iam-labs}

mkdir -p docs/evidence

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text --profile "$PROFILE")

echo "Simulating for alice.finance (FinanceRead group) ..."
aws iam simulate-principal-policy   --policy-source-arn arn:aws:iam::${ACCOUNT_ID}:user/alice.finance   --action-names ce:GetCostAndUsage   --profile "$PROFILE" --output table | tee docs/evidence/policy-sim-results.txt

echo "Expect ExplicitDeny for high-risk actions (e.g., CreateAccessKey) ..."
aws iam simulate-principal-policy   --policy-source-arn arn:aws:iam::${ACCOUNT_ID}:user/alice.finance   --action-names iam:CreateAccessKey   --profile "$PROFILE" --output table | tee -a docs/evidence/policy-sim-results.txt

echo "Done: simulation evidence saved to docs/evidence/policy-sim-results.txt"
