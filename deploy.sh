#!/bin/bash

# ==========================================
# Skirk Bot Website - Deploy Script
# ==========================================

set -e # Exit on error

# Colors for output
GREEN='\033[0;32m✅'
RED='\033[0;31m❌'
YELLOW='\033[1;33m⚠'
BLUE='\033[0;34m🔵'
PURPLE='\033[0;35m🟣'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${PURPLE} Skirk Bot Website - Deploy Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# ==========================================
# Prerequisites Check
# ==========================================

echo -e "${YELLOW}Checking prerequisites...${NC}"

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo -e "${RED}✗ Git not initialized${NC}"
    echo -e "${YELLOW}Running: git init${NC}"
    git init
fi

# Check if build works
echo -e "${YELLOW}Testing build...${NC}"
bun run build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Build successful${NC}"
else
    echo -e "${RED}✗ Build failed${NC}"
    echo -e "${YELLOW}Please fix errors before deploying${NC}"
    exit 1
fi

echo ""

# ==========================================
# Git Status Check
# ==========================================

echo -e "${YELLOW}Checking git status...${NC}"

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${GREEN}✓ Working directory clean${NC}"
else
    echo -e "${YELLOW}⚠ Uncommitted changes found${NC}"
    git status --short
    echo ""
    echo -e "${YELLOW}Would you like to commit them? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Committing changes...${NC}"
        git add .
        git commit -m "Update before deployment"
        echo -e "${GREEN}✓ Changes committed${NC}"
    else
        echo -e "${YELLOW}Skipping commit${NC}"
    fi
fi

echo ""

# ==========================================
# Push to GitHub
# ==========================================

echo -e "${BLUE}========================================${NC}"
echo -e "${PURPLE}Push to GitHub${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if remote exists
if ! git remote get-url origin &> /dev/null; then
    echo -e "${YELLOW}No git remote found${NC}"
    echo -e "${YELLOW}Please add a GitHub remote:${NC}"
    echo ""
    echo -e "${YELLOW}Run: git remote add origin https://github.com/YOUR_USERNAME/skirk-bot-website.git${NC}"
    echo ""
    read -p "Press Enter when you've added the remote..."
    read -r
fi

echo -e "${YELLOW}Pushing to GitHub...${NC}"
git push -u origin main

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Pushed successfully${NC}"
else
    echo -e "${RED}✗ Push failed${NC}"
    exit 1
fi

echo ""

# ==========================================
# Vercel Deployment Instructions
# ==========================================

echo -e "${BLUE}========================================${NC}"
echo -e "${PURPLE}Next: Deploy to Vercel${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${GREEN}Your code is now on GitHub!${NC}"
echo ""
echo -e "${YELLOW}Deploy to Vercel:${NC}"
echo -e "1. Go to https://vercel.com/new"
echo -e "2. Click 'Continue with GitHub'"
echo -e "3. Find 'skirk-bot-website' repository"
echo -e "4. Click 'Deploy'"
echo ""
echo -e "${YELLOW}⏱ Wait 1-2 minutes for deployment${NC}"
echo ""
echo -e "${YELLOW}After deployment:${NC}"
echo -e "1. Go to your Vercel project → Settings → Environment Variables"
echo -e "2. Add: DISCORD_WEBHOOK_URL"
echo -e "3. Click 'Save' and 'Redeploy'"
echo ""
echo -e "${GREEN}✅ That's it! Your site will be live!${NC}"
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${PURPLE}Deployment Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}Quick Links:${NC}"
echo -e "  Vercel Dashboard: https://vercel.com/dashboard"
echo -e "  Vercel Docs: https://vercel.com/docs"
echo -e "  Discord Setup: See DISCORD_SETUP.md"
echo ""
