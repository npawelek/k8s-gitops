#!/bin/bash

# Get all PVCs with recurring-job-group labels and sync them to their Longhorn volumes
kubectl get pvc --all-namespaces -o json | jq -r '.items[] | "\(.metadata.namespace)|\(.metadata.name)|\(.spec.volumeName // "<none>")"' | while IFS='|' read -r namespace pvc volume; do
  # Skip if no volume name
  if [[ "$volume" == "<none>" || -z "$volume" ]]; then
    continue
  fi
  
  # Check if PVC has backup group labels
  labels=$(kubectl get pvc "$pvc" -n "$namespace" -o jsonpath='{.metadata.labels}' 2>/dev/null)
  
  if [[ "$labels" == *"recurring-job-group.longhorn.io"* ]]; then
    
    # Extract backup group labels from PVC
    backup_6h=$(kubectl get pvc "$pvc" -n "$namespace" -o jsonpath='{.metadata.labels.recurring-job-group\.longhorn\.io/backup-6h}' 2>/dev/null)
    backup_12h=$(kubectl get pvc "$pvc" -n "$namespace" -o jsonpath='{.metadata.labels.recurring-job-group\.longhorn\.io/backup-12h}' 2>/dev/null)
    backup_24h=$(kubectl get pvc "$pvc" -n "$namespace" -o jsonpath='{.metadata.labels.recurring-job-group\.longhorn\.io/backup-24h}' 2>/dev/null)
    default_group=$(kubectl get pvc "$pvc" -n "$namespace" -o jsonpath='{.metadata.labels.recurring-job-group\.longhorn\.io/default}' 2>/dev/null)
    
    echo "==========================================="
    echo "PVC: $pvc ($namespace)"
    echo "Volume: $volume"
    echo ""
    
    echo "PVC LABELS (source):"
    if [[ -n "$backup_6h" ]]; then
      echo "  recurring-job-group.longhorn.io/backup-6h=$backup_6h"
    fi
    if [[ -n "$backup_12h" ]]; then
      echo "  recurring-job-group.longhorn.io/backup-12h=$backup_12h"
    fi
    if [[ -n "$backup_24h" ]]; then
      echo "  recurring-job-group.longhorn.io/backup-24h=$backup_24h"
    fi
    if [[ -n "$default_group" ]]; then
      echo "  recurring-job-group.longhorn.io/default=$default_group"
    fi
    echo ""
    
    # Get current volume labels
    echo "BEFORE (current volume labels):"
    current_backup_6h=$(kubectl get volume -n longhorn-system "$volume" -o jsonpath='{.metadata.labels.recurring-job-group\.longhorn\.io/backup-6h}' 2>/dev/null)
    current_backup_12h=$(kubectl get volume -n longhorn-system "$volume" -o jsonpath='{.metadata.labels.recurring-job-group\.longhorn\.io/backup-12h}' 2>/dev/null)
    current_backup_24h=$(kubectl get volume -n longhorn-system "$volume" -o jsonpath='{.metadata.labels.recurring-job-group\.longhorn\.io/backup-24h}' 2>/dev/null)
    current_default=$(kubectl get volume -n longhorn-system "$volume" -o jsonpath='{.metadata.labels.recurring-job-group\.longhorn\.io/default}' 2>/dev/null)
    
    found_labels=false
    if [[ -n "$current_backup_6h" ]]; then
      echo "  recurring-job-group.longhorn.io/backup-6h=$current_backup_6h"
      found_labels=true
    fi
    if [[ -n "$current_backup_12h" ]]; then
      echo "  recurring-job-group.longhorn.io/backup-12h=$current_backup_12h"
      found_labels=true
    fi
    if [[ -n "$current_backup_24h" ]]; then
      echo "  recurring-job-group.longhorn.io/backup-24h=$current_backup_24h"
      found_labels=true
    fi
    if [[ -n "$current_default" ]]; then
      echo "  recurring-job-group.longhorn.io/default=$current_default"
      found_labels=true
    fi
    if [[ "$found_labels" == "false" ]]; then
      echo "  No recurring-job-group labels found"
    fi
    echo ""
    
    echo "AFTER (will apply these labels):"
    if [[ -n "$backup_6h" ]]; then
      echo "  recurring-job-group.longhorn.io/backup-6h=$backup_6h"
    fi
    if [[ -n "$backup_12h" ]]; then
      echo "  recurring-job-group.longhorn.io/backup-12h=$backup_12h"
    fi
    if [[ -n "$backup_24h" ]]; then
      echo "  recurring-job-group.longhorn.io/backup-24h=$backup_24h"
    fi
    if [[ -n "$default_group" ]]; then
      echo "  recurring-job-group.longhorn.io/default=$default_group"
    fi
    echo ""
    
    # Ask for confirmation
    read -p "Apply these labels to volume $volume? (y/N): " -n 1 -r < /dev/tty
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      # Apply labels to the Longhorn volume
      if [[ -n "$backup_6h" ]]; then
        kubectl label volume -n longhorn-system "$volume" "recurring-job-group.longhorn.io/backup-6h=$backup_6h" --overwrite
      fi
      if [[ -n "$backup_12h" ]]; then
        kubectl label volume -n longhorn-system "$volume" "recurring-job-group.longhorn.io/backup-12h=$backup_12h" --overwrite
      fi
      if [[ -n "$backup_24h" ]]; then
        kubectl label volume -n longhorn-system "$volume" "recurring-job-group.longhorn.io/backup-24h=$backup_24h" --overwrite
      fi
      if [[ -n "$default_group" ]]; then
        kubectl label volume -n longhorn-system "$volume" "recurring-job-group.longhorn.io/default=$default_group" --overwrite
      fi
      echo "✓ Labels applied to $volume"
    else
      echo "⏭ Skipped $volume"
    fi
    echo ""
  fi
done