#!/usr/bin/env sh

die () {
  echo >&2 "$@"
  cd "${PWD}"
  exit 1
}

# Add packages
apk add jq curl

# Verify environment variables
[ -n "${RADARR_APIKEY}" ] || die "Environment variable RADARR_APIKEY is required"
[ -n "${RADARR_URL}" ] || die "Environment variable RADARR_URL is required"
[ -n "${RADARR_ANIME_APIKEY}" ] || die "Environment variable RADARR_APIKEY is required"
[ -n "${RADARR_ANIME_URL}" ] || die "Environment variable RADARR_URL is required"

# Iterate through all movies in radarr, skipping any with a null movieId
for ID in $(curl -sL "${RADARR_URL}/api/v3/movie" -H "X-Api-Key:$RADARR_APIKEY" | jq -r '.[].movieFile.movieId | select( . != null)')
do
  # Store movie json
  MOVIE_DETAIL=$(curl -sL "${RADARR_URL}/api/v3/movie/${ID}" -H "X-Api-Key:$RADARR_APIKEY" | jq -r)

  # Determine if a -trailer suffix file exists in the movie directory
  MOVIE_PATH=$(echo "${MOVIE_DETAIL}" | jq -r '.movieFile.path')
  MOVIE_DIRECTORY=$(dirname "${MOVIE_PATH}")
  TRAILER_FILE=$(find "${MOVIE_DIRECTORY}" -name "*-trailer.*")

  # Check if trailer is missing
  if [ -z "${TRAILER_FILE}" ]; then
    # Get movie details
    MOVIE_FILENAME=$(basename "${MOVIE_PATH}")
    TRAILER_ID=$(echo "${MOVIE_DETAIL}" | jq -r .youTubeTrailerId | tr -d \")
    MOVIE_NAME=$(echo "${MOVIE_DETAIL}" | jq -r '.title')

    if [ -n "${TRAILER_ID}" ]; then
      # Build the YouTube trailer URL
      TRAILER_URL="https://www.youtube.com/watch?v=${TRAILER_ID}"

      # Set the yt-dlp output template containing YouTube ID and Jellyfin file suffix
      OUTPUT_TEMPLATE="${MOVIE_FILENAME%\ [*} [${TRAILER_ID}]-trailer.%(ext)s"

      # Enter movie directory
      cd "${MOVIE_DIRECTORY}"

      # Grab the trailer with the best video+audio and store in mkv format
      echo -e "\n\nID: ${ID}\tDownloading trailer for ${MOVIE_NAME} ...\n\n"
      yt-dlp -v -f "bestvideo+bestaudio/best" \
        --geo-bypass \
        --retries 10 \
        --paths temp:/cache \
        --concurrent-fragments 5 \
        --merge-output-format mkv \
        --restrict-filenames \
        --output "${OUTPUT_TEMPLATE}" \
        "${TRAILER_URL}"

      # Exit movie directory
      cd
    else
      echo -e "ID: ${ID}\tSkipping '${MOVIE_NAME}' due to missing YouTube video ID ..."
    fi
  else
    echo -e "ID: ${ID}\tTrailer already exists in ${MOVIE_DIRECTORY} ..."
  fi
done

# Iterate through all movies in radarr anime, skipping any with a null movieId
for ID in $(curl -sL "${RADARR_ANIME_URL}/api/v3/movie" -H "X-Api-Key:$RADARR_ANIME_APIKEY" | jq -r '.[].movieFile.movieId | select( . != null)')
do
  # Store movie json
  MOVIE_DETAIL=$(curl -sL "${RADARR_ANIME_URL}/api/v3/movie/${ID}" -H "X-Api-Key:$RADARR_ANIME_APIKEY" | jq -r)

  # Determine if a -trailer suffix file exists in the movie directory
  MOVIE_PATH=$(echo "${MOVIE_DETAIL}" | jq -r '.movieFile.path')
  MOVIE_DIRECTORY=$(dirname "${MOVIE_PATH}")
  TRAILER_FILE=$(find "${MOVIE_DIRECTORY}" -name "*-trailer.*")

  # Check if trailer is missing
  if [ -z "${TRAILER_FILE}" ]; then
    # Get movie details
    MOVIE_FILENAME=$(basename "${MOVIE_PATH}")
    TRAILER_ID=$(echo "${MOVIE_DETAIL}" | jq -r .youTubeTrailerId | tr -d \")
    MOVIE_NAME=$(echo "${MOVIE_DETAIL}" | jq -r '.title')

    if [ -n "${TRAILER_ID}" ]; then
      # Build the YouTube trailer URL
      TRAILER_URL="https://www.youtube.com/watch?v=${TRAILER_ID}"

      # Set the yt-dlp output template containing YouTube ID and Jellyfin file suffix
      OUTPUT_TEMPLATE="${MOVIE_FILENAME%\ [*} [${TRAILER_ID}]-trailer.%(ext)s"

      # Enter movie directory
      cd "${MOVIE_DIRECTORY}"

      # Grab the trailer with the best video+audio and store in mkv format
      echo -e "\n\nID: ${ID}\tDownloading trailer for ${MOVIE_NAME} ...\n\n"
      yt-dlp -v -f "bestvideo+bestaudio/best" \
        --geo-bypass \
        --retries 10 \
        --paths temp:/cache \
        --concurrent-fragments 5 \
        --merge-output-format mkv \
        --restrict-filenames \
        --output "${OUTPUT_TEMPLATE}" \
        "${TRAILER_URL}"

      # Exit movie directory
      cd
    else
      echo -e "ID: ${ID}\tSkipping '${MOVIE_NAME}' due to missing YouTube video ID ..."
    fi
  else
    echo -e "ID: ${ID}\tTrailer already exists in ${MOVIE_DIRECTORY} ..."
  fi
done
