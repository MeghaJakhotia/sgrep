#!/bin/bash
set -e

echo "Loading version from file: $(cat version)"
cat version | sed 's/^v//' > release-version
echo "Installing via homebrew"
brew tap returntocorp/sgrep https://github.com/returntocorp/sgrep.git
brew install semgrep

echo "Running homebrew recipe checks"
brew test semgrep


brew info semgrep --json | jq -r '.[0].installed[0].version' | tee brew-version

semgrep --version > semgrep-version
echo -n "Validating brew the version ($(cat brew-version) vs. $(cat release-version))..."
diff brew-version release-version
echo "OK!"

echo -n "Validating brew the version ($(cat semgrep-version) vs. $(cat release-version))..."
diff semgrep-version release-version
echo "OK!"
