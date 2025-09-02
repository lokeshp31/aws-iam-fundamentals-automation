#!/usr/bin/env bash
set -euo pipefail
PROFILE=${PROFILE:-iam-labs}

echo "Creating role: EC2ReadRole"
aws iam create-role --role-name EC2ReadRole   --assume-role-policy-document file://trust-policies/ec2_assume_role.json   --profile "$PROFILE" 2>/dev/null || true

aws iam attach-role-policy   --role-name EC2ReadRole   --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess   --profile "$PROFILE"

echo "Creating role: CrossAccountReadOnly"
aws iam create-role --role-name CrossAccountReadOnly   --assume-role-policy-document file://trust-policies/cross_account_readonly.json   --profile "$PROFILE" 2>/dev/null || true

aws iam attach-role-policy   --role-name CrossAccountReadOnly   --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess   --profile "$PROFILE"

echo "Done: roles created and policies attached."
