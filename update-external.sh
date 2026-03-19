#!/bin/bash
set -e

for repo in linux busybox strace; do
    echo "Updating $repo..."
    git -C "$repo" fetch origin
    git -C "$repo" reset --hard origin/HEAD
done

echo "Done."
