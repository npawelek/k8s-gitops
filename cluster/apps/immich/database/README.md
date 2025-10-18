# Immich Database

This directory contains the dedicated PostgreSQL database for Immich with VectorChord extension support.

## Post-Deployment Setup

### 1. Add Longhorn Backup Labels

After the database is deployed, manually add backup labels to enable recurring backups:

#### Label the PVC:
```bash
kubectl label pvc postgres-1 -n immich recurring-job-group.longhorn.io/backup-24h=enabled
kubectl label pvc postgres-1 -n immich recurring-job-group.longhorn.io/default=enabled
```

#### Find and Label the Longhorn Volume:
```bash
# Get the volume name from the PVC
VOLUME_NAME=$(kubectl get pvc postgres-1 -n immich -o jsonpath='{.spec.volumeName}')

# Label the Longhorn volume
kubectl label volume $VOLUME_NAME -n longhorn-system recurring-job-group.longhorn.io/backup-24h=enabled
kubectl label volume $VOLUME_NAME -n longhorn-system recurring-job-group.longhorn.io/default=enabled
```

### 2. VectorChord Extension Updates

When installing a new version of VectorChord, manually update the extension and reindex:

```bash
# Connect to the Immich database
kubectl exec -it postgres-1 -n immich -- psql -U immich -d immich

# Run the following SQL commands:
ALTER EXTENSION vchord UPDATE;
REINDEX INDEX face_index;
REINDEX INDEX clip_index;
```
