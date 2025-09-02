#!/usr/bin/env bash
set -euo pipefail
PROFILE=${PROFILE:-iam-labs}

create_and_attach () {
  local name=$1 file=$2 group=$3
  local arn
  arn=$(aws iam create-policy --policy-name "$name" --policy-document "file://$file"         --query 'Policy.Arn' --output text --profile "$PROFILE" 2>/dev/null || true)
  if [[ -z "$arn" || "$arn" == "None" ]]; then
    arn=$(aws iam list-policies --scope Local --query "Policies[?PolicyName=='$name'].Arn"           --output text --profile "$PROFILE")
  fi
  aws iam attach-group-policy --group-name "$group" --policy-arn "$arn" --profile "$PROFILE"
  echo "Attached $name to $group ($arn)"
}

create_and_attach FinanceReadOnly ./policies/finance_read_only.json FinanceRead
create_and_attach DevOpsLeastPriv ./policies/devops_least_priv.json DevOpsLimited
create_and_attach S3ReadProjectX ./policies/s3_read_projectX.json DevOpsLimited
create_and_attach DenyHighRisk ./policies/deny_high_risk_actions.json FinanceRead
create_and_attach DenyHighRisk ./policies/deny_high_risk_actions.json DevOpsLimited
create_and_attach MFARequired ./policies/mfa_required.json FinanceRead
create_and_attach MFARequired ./policies/mfa_required.json DevOpsLimited

echo "Done: policies attached to groups."
