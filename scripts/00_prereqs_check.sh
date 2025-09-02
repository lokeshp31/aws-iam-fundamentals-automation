#!/usr/bin/env bash
set -euo pipefail
PROFILE=${PROFILE:-iam-labs}
echo "Checking AWS CLI..."
aws --version || (echo "AWS CLI not found." && exit 1)
echo "Checking caller identity for profile: $PROFILE"
aws sts get-caller-identity --profile "$PROFILE" || (echo "Profile $PROFILE not configured." && exit 1)
echo "OK: AWS CLI and profile are ready."
