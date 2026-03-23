#!/bin/bash
set -euo pipefail

git submodule foreach --recursive '
    echo "Updating $name..."

    # Fetch only the latest commit (shallow)
    git fetch --depth=1 origin

    # Reset to fetched commit
    git reset --hard FETCH_HEAD

    # Optional cleanup
    git gc --prune=all >/dev/null 2>&1 || true
'

echo "Done."
