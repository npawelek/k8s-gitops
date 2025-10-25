# Jellystat

Jellystat is a statistics and monitoring application for Jellyfin media servers.

## Library Media Mapping

The Jellystat code seems to prevent `BoxSets` and `Collections` from being included. There are nearly 150 collections in Jellyfin and this causes significant mismatches with media associated in Jellystat libraries. This results in a large portion of missing activities because of the mssing media in the library.

## Playback Reporting Import Fixes

When importing via playback reporting in Jellystat, some series episodes are mapped incorrectly. Running these in sequence seems to fix the issue:

```sql
-- Use only the first 32 characters for the EpisodeID
UPDATE public.jf_playback_activity
   SET "EpisodeId" = LEFT("EpisodeId", 32)
WHERE "EpisodeId" IS NOT NULL
  AND "imported" = 'True';
```

```sql
-- Temp Table to relate the Library Item Id to the Episode Id
CREATE TEMP TABLE tbl AS (
SELECT pa."NowPlayingItemId", li."Id"
  FROM public.jf_playback_activity pa
     JOIN public.jf_library_episodes le
       ON le."EpisodeId" = pa."EpisodeId"
     JOIN public.jf_library_items li
       ON le."SeriesName" = li."Name"
WHERE li."Type" <> 'Movie'
);
```

```sql
-- Update the Playback Activity Table to replace the NowPlayingItemId with the LibraryItem Id
UPDATE public.jf_playback_activity t1
SET "NowPlayingItemId" = t2."Id"
FROM tbl t2
WHERE t1."NowPlayingItemId" = t2."NowPlayingItemId";
```

```sql
-- Remove temp table
DROP TABLE tbl;
```

Reference: [issue 249](https://github.com/CyferShepard/Jellystat/issues/249)
