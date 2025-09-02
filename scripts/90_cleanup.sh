#!/usr/bin/env bash
set -euo pipefail
PROFILE=${PROFILE:-iam-labs}

echo "Detaching group policies..."
for group in FinanceRead HRRead DevOpsLimited; do
  attached=$(aws iam list-attached-group-policies --group-name "$group" --profile "$PROFILE" --query 'AttachedPolicies[].PolicyArn' --output text || true)
  for arn in $attached; do
    aws iam detach-group-policy --group-name "$group" --policy-arn "$arn" --profile "$PROFILE" || true
  done
done

echo "Detaching role policies..."
for role in EC2ReadRole CrossAccountReadOnly; do
  attached=$(aws iam list-attached-role-policies --role-name "$role" --profile "$PROFILE" --query 'AttachedPolicies[].PolicyArn' --output text || true)
  for arn in $attached; do
    aws iam detach-role-policy --role-name "$role" --policy-arn "$arn" --profile "$PROFILE" || true
  done
done

echo "Deleting roles..."
for role in EC2ReadRole CrossAccountReadOnly; do
  aws iam delete-role --role-name "$role" --profile "$PROFILE" || true
done

echo "Deleting users from groups..."
aws iam remove-user-from-group --user-name alice.finance --group-name FinanceRead --profile "$PROFILE" || true
aws iam remove-user-from-group --user-name bob.hr --group-name HRRead --profile "$PROFILE" || true
aws iam remove-user-from-group --user-name carol.devops --group-name DevOpsLimited --profile "$PROFILE" || true

echo "Deleting users..."
for u in alice.finance bob.hr carol.devops; do
  # Delete any access keys to avoid constraints
  keys=$(aws iam list-access-keys --user-name "$u" --profile "$PROFILE" --query 'AccessKeyMetadata[].AccessKeyId' --output text || true)
  for k in $keys; do
    aws iam delete-access-key --user-name "$u" --access-key-id "$k" --profile "$PROFILE" || true
  done
  aws iam delete-user --user-name "$u" --profile "$PROFILE" || true
done

echo "Deleting groups..."
for g in FinanceRead HRRead DevOpsLimited; do
  aws iam delete-group --group-name "$g" --profile "$PROFILE" || true
done

echo "Deleting **local** custom policies..."
for name in FinanceReadOnly DevOpsLeastPriv S3ReadProjectX DenyHighRisk MFARequired; do
  arn=$(aws iam list-policies --scope Local --query "Policies[?PolicyName=='$name'].Arn" --output text --profile "$PROFILE" || true)
  if [[ -n "$arn" && "$arn" != "None" ]]; then
    # Must delete non-default policy versions first
    versions=$(aws iam list-policy-versions --policy-arn "$arn" --profile "$PROFILE" --query 'Versions[?IsDefaultVersion==`false`].VersionId' --output text || true)
    for v in $versions; do
      aws iam delete-policy-version --policy-arn "$arn" --version-id "$v" --profile "$PROFILE" || true
    done
    aws iam delete-policy --policy-arn "$arn" --profile "$PROFILE" || true
  fi
done

echo "Cleanup complete."
