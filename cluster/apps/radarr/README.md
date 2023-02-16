# Radarr

## Trailers

This is a simple cronjob that runs @daily to download trailers for your movie collection using [yt-dlp](https://github.com/yt-dlp/yt-dlp). Each movie directory is checked for an existing trailer file before attempting to download. Any missing trailer will be downloaded alongside existing movie files, utilizing the [standardized Jellyfin file suffix](https://jellyfin.org/docs/general/server/media/movies/#file-suffix) for trailers. The presence of a file matching a trailer file suffix will automatically enable the trailer button in the Jellyfin client UI.
