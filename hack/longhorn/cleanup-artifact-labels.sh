#!/bin/bash

# Remove artifact recurring job labels from Longhorn volumes
echo "Finding volumes with artifact recurring job labels..."

kubectl get volumes.longhorn.io -n longhorn-system -o json | jq -r '.items[] | select(.metadata.labels | keys[] | test("recurring-job\\.longhorn\\.io/c-")) | "\(.metadata.name)|\(.status.kubernetesStatus.pvcName // "no-pvc")|\(.status.kubernetesStatus.namespace // "no-ns")"' | while IFS='|' read -r volume pvc namespace; do
  echo "==========================================="
  echo "PVC: $pvc ($namespace)"
  echo "Volume: $volume"
  echo ""
  
  # Get all the artifact labels
  artifact_labels=$(kubectl get volume -n longhorn-system "$volume" -o json | jq -r '.metadata.labels | keys[] | select(test("recurring-job\\.longhorn\\.io/c-"))')
  
  echo "ARTIFACT LABELS TO REMOVE:"
  for label in $artifact_labels; do
    echo "  $label"
  done
  echo ""
  
  # Ask for confirmation
  read -p "Remove these artifact labels from volume $volume? (y/N): " -n 1 -r < /dev/tty
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    for label in $artifact_labels; do
      echo "  Removing label: $label"
      kubectl label volume -n longhorn-system "$volume" "$label-"
    done
    echo "✓ Labels removed from $volume"
  else
    echo "⏭ Skipped $volume"
  fi
  echo ""
done

echo "Cleanup complete!"