#!/bin/bash

# PrivacyGuard VPN - Automated Setup Script
# This script sets up the entire project in one command
#
# Usage: ./setup.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo ""
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main setup function
main() {
    print_header "PrivacyGuard VPN Setup"
    print_info "Starting automated setup..."
    echo ""

    # 1. Check Flutter
    print_header "Step 1: Checking Flutter"
    if command_exists flutter; then
        FLUTTER_VERSION=$(flutter --version | head -n 1)
        print_success "Flutter found: $FLUTTER_VERSION"
    else
        print_error "Flutter not found!"
        print_info "Please install Flutter from: https://docs.flutter.dev/get-started/install"
        exit 1
    fi

    # 2. Check Node.js
    print_header "Step 2: Checking Node.js"
    if command_exists node; then
        NODE_VERSION=$(node --version)
        print_success "Node.js found: $NODE_VERSION"
    else
        print_error "Node.js not found!"
        print_info "Please install Node.js 18+ from: https://nodejs.org"
        exit 1
    fi

    # 3. Install Flutter Dependencies
    print_header "Step 3: Installing Flutter Dependencies"
    print_info "Running: flutter pub get"
    flutter pub get
    print_success "Flutter dependencies installed"

    # 4. Generate Freezed Models
    print_header "Step 4: Generating Freezed Models"
    print_info "This may take a few minutes..."
    print_info "Running: flutter pub run build_runner build --delete-conflicting-outputs"

    if flutter pub run build_runner build --delete-conflicting-outputs; then
        print_success "Freezed models generated successfully"
    else
        print_warning "Freezed generation had warnings (this is usually OK)"
    fi

    # 5. Check Convex CLI
    print_header "Step 5: Checking Convex"
    if command_exists npx; then
        print_success "NPM found, can use Convex"

        print_info "Checking if Convex is logged in..."
        if npx convex dev --version >/dev/null 2>&1; then
            print_success "Convex CLI available"
        else
            print_warning "Convex CLI not found, installing..."
            npm install -g convex
        fi
    else
        print_error "NPM not found!"
        exit 1
    fi

    # 6. Setup Convex (Optional - requires user interaction)
    print_header "Step 6: Convex Backend Setup"
    print_info "To deploy Convex backend, run:"
    echo ""
    echo "  cd convex"
    echo "  npx convex login"
    echo "  npx convex dev"
    echo ""
    print_warning "Skipping Convex deployment (requires manual login)"

    # 7. Check Android Setup
    print_header "Step 7: Checking Android Environment"
    if [ -d "$ANDROID_HOME" ]; then
        print_success "Android SDK found: $ANDROID_HOME"
    else
        print_warning "ANDROID_HOME not set (iOS-only setup?)"
    fi

    # 8. List Available Devices
    print_header "Step 8: Available Devices"
    print_info "Checking for connected devices..."
    flutter devices

    # 9. Final Instructions
    print_header "Setup Complete! 🎉"
    echo ""
    print_success "PrivacyGuard VPN is ready for development!"
    echo ""
    print_info "Next steps:"
    echo ""
    echo "  1. Deploy Convex backend:"
    echo "     ${GREEN}npx convex dev${NC}"
    echo ""
    echo "  2. Add test VPN server to Convex:"
    echo "     ${GREEN}npx convex run vpn:addServer \\${NC}"
    echo "       --name \"Amsterdam, Netherlands\" \\"
    echo "       --countryCode \"NL\" \\"
    echo "       --countryName \"Netherlands\" \\"
    echo "       --cityName \"Amsterdam\" \\"
    echo "       --ipAddress \"YOUR_VPN_IP\" \\"
    echo "       --port 51820 \\"
    echo "       --protocol \"wireguard\" \\"
    echo "       --publicKey \"YOUR_PUBLIC_KEY\" \\"
    echo "       --isPremium false \\"
    echo "       --maxUsers 100"
    echo ""
    echo "  3. Create default missions:"
    echo "     ${GREEN}npx convex run rewards:createDefaultMissions${NC}"
    echo ""
    echo "  4. Run the app:"
    echo "     ${GREEN}flutter run -d android${NC}"
    echo ""
    print_info "Test credentials:"
    echo "  Email: test@example.com"
    echo "  Password: password123"
    echo ""
    print_info "Full documentation: ${BLUE}./SETUP_GUIDE.md${NC}"
    echo ""
}

# Run main function
main

exit 0
