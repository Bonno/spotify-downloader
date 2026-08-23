# Spotify Downloader (Zotify Wrapper)

This project contains a Bash wrapper script to easily download Spotify tracks, albums, and playlists locally using Docker. 

Under the hood, this script uses the open-source project [Zotify](https://github.com/Googolplexed0/zotify.git). All credit for the actual download functionality goes to the creators of that repository.

## How it Works

The script (`spotify-downloader.sh`) runs a temporary Docker container with Zotify. It simplifies the download process by supporting aliases (via a `.env` file), eliminating the need to look up the full Spotify URL every time. 

When you use an alias, the script looks up the corresponding URL and automatically appends the Zotify parameter `--output-ext-playlist` to the command. Direct URLs are handled without this extra flag.

## Requirements

- Docker and Docker Compose
- Bash (Linux/macOS or WSL)

## Configuration: `playlists.env`

To use aliases, create a file named `playlists.env` in the same directory as the script. Define the names and their corresponding Spotify URLs here using a `key=value` structure.

Example of `playlists.env`:
```env
name1=[https://open.spotify.com/playlist/72RfOXaOy80wmjfN6SzC4N](https://open.spotify.com/playlist/72RfOXaOy80wmjfN6SzC4N)
name2=[https://open.spotify.com/playlist/3L24feY2vuDZ4lA37gCodK](https://open.spotify.com/playlist/3L24feY2vuDZ4lA37gCodK)
summer_mix=[https://open.spotify.com/playlist/1234567890abcdef](https://open.spotify.com/playlist/1234567890abcdef)
```

## Usage

Run the script by providing either a direct URL or a configured alias.

```bash
./spotify-downloader.sh <SPOTIFY_URL ALIAS |> [OPTIONS]
```

### Arguments and Parameters

| Parameter | Required | Description |
| :--- | :--- | :--- |
| `<SPOTIFY_URL \| ALIAS>` | Yes | A direct URL starting with `http` or `spotify:`, or an alias defined in `playlists.env`. |
| `--output <PATTERN>` | No | Define a specific output filename pattern, e.g., `"{artist}_{song_name}"`. |
| `-h, --help` | No | Displays the help text and exits. |

### Examples

**Download using a direct URL:**
```bash
./spotify-downloader.sh "[https://open.spotify.com/track/123456789](https://open.spotify.com/track/123456789)"
```

**Download a configured playlist using an alias:**
```bash
./spotify-downloader.sh name1
