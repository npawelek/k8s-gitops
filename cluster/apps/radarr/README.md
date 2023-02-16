# Radarr

## radarr-trailers

### Overview

A cronjob that runs at a defined interval to download trailers for your movie collection using [yt-dlp](https://github.com/yt-dlp/yt-dlp). This process assumes a standardized movie collection exists with the same remote file mapping as Radarr, because the absolute path of each movie will be assumed from the Radarr API. Each movie directory is checked for an existing trailer file before attempting to download. Any missing trailer(s) will be downloaded alongside existing movie files, utilizing the [standardized Jellyfin trailer file suffix](https://jellyfin.org/docs/general/server/media/movies/#file-suffix). The presence of a trailer matching the file suffix will automatically enable the trailer button in the Jellyfin client UI.

This leverages an updated version of yt-dlp. The configuration of the yt-dlp command will concurrently download files into memory, then use ffmpeg to combine and output the trailer in an mkv container.

If you experience any issues with missing or unavailable trailers, look at [TMDb](https://www.themoviedb.org/) and edit details accordingly. This will ensure that Radarr is populating the correct trailer URL from TMDb metadata.

### Manual Testing

The cronjob can be manually executed for testing purposes using the below examples:

Create:
```
kubectl create job -n radarr --from=cronjob/radarr-trailers manualrun
```

Logs:
```
kubectl logs -n radarr manualrun-<id> -f
```

Delete:
```
k delete job -n radarr manualrun
```
