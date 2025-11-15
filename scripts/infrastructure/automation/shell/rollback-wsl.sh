#!/bin/bash
echo "Rolling back WSL changes..."
cp ~/migration-backup/20250921/bashrc-backup ~/.bashrc
source ~/.bashrc
echo "Rollback complete. Exit terminal and reopen."
