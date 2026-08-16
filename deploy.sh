#!/usr/bin/env bash
set -e

# ==============================================================================
# Splitr - Automated Git Push & VPS Deploy Script
# Usage: ./deploy.sh [optional commit message]
# ==============================================================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REMOTE_REPO="https://github.com/dushyantahuja/Splitr.git"
VPS_HOST="103.194.228.118"
VPS_USER="root"
VPS_TARGET_DIR="/var/www/splitr.ahuja.ws/"

echo "======================================================"
echo "🚀 Starting Splitr Deployment"
echo "======================================================"

cd "$PROJECT_DIR"


# ------------------------------------------------------------------------------
# 1. Git Commit & Push
# ------------------------------------------------------------------------------
echo ""
echo "📦 [1/2] Updating Git Repository..."

# Ensure git remote is configured
if ! git remote | grep -q "^origin$"; then
  echo "Adding git remote origin: $REMOTE_REPO"
  git remote add origin "$REMOTE_REPO"
else
  git remote set-url origin "$REMOTE_REPO"
fi

# Ensure default branch is main
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
if [ -z "$CURRENT_BRANCH" ]; then
  CURRENT_BRANCH="main"
fi

# Stage all changes
git add -A

# Determine commit message
COMMIT_MSG="${1:-"Auto-deploy: $(date '+%Y-%m-%d %H:%M:%S')"}"

# Check if there are changes to commit
if git diff-index --quiet HEAD -- 2>/dev/null; then
  echo "ℹ️  No new local changes to commit."
else
  echo "📝 Committing changes: '$COMMIT_MSG'"
  git commit -m "$COMMIT_MSG"
fi

echo "⬆️  Pushing to GitHub ($CURRENT_BRANCH)..."
git push -u origin "$CURRENT_BRANCH" || echo "⚠️ Git push returned an issue (check credentials or repo permissions if first push)."

# ------------------------------------------------------------------------------
# 2. Deploy to VPS
# ------------------------------------------------------------------------------
echo ""
echo "🌐 [2/2] Deploying static assets to VPS ($VPS_HOST)..."

# Ensure target directory exists on VPS
ssh "${VPS_USER}@${VPS_HOST}" "mkdir -p ${VPS_TARGET_DIR}"

rsync -avz --delete \
  --exclude='.git/' \
  --exclude='.gitignore' \
  --exclude='.DS_Store' \
  --exclude='deploy.sh' \
  "$PROJECT_DIR/" "${VPS_USER}@${VPS_HOST}:${VPS_TARGET_DIR}"

echo ""
echo "======================================================"
echo "✅ Deployment complete!"
echo "🔗 Site is live at: https://splitr.ahuja.ws"
echo "🔗 Also accessible: https://SplitR.ahuja.ws"
echo "======================================================"
