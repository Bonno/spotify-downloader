#!/bin/bash

CONFIG_FILE="playlists.env"
OUTPUT_PLAYLIST="{playlist}/{artist}_{song_name}"
OUTPUT=""


# Functie voor de helptekst
usage() {
    echo "Gebruik: $0 <SPOTIFY_URL | ALIAS> [--output <PATROON>] [-h|--help]"
    echo ""
    echo "Argumenten:"
    echo "  <SPOTIFY_URL | ALIAS>   De URL van het Spotify nummer/album/playlist (verplicht)"
    echo "                          Of gebruik een alias gedefinieerd in $CONFIG_FILE"
    echo ""
    echo "Opties:"
    echo "  --output <PATROON>      Output file pattern (bijv. \"{artist}_{song_name}\")"
    echo "  -h, --help              Toon deze helptekst"
    exit 1
}

# Controleer op -h of --help direct als argument
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
fi

# Verplichte eerste argument afvangen
if [ -z "$1" ] || [[ "$1" == -* ]]; then
    echo "Fout: Spotify URL of alias is verplicht."
    echo ""
    usage
fi

INPUT_ARG="$1"
IS_ALIAS=false
SPOTIFY_URL=""

# Controleer of het argument een URL is (begint met http of spotify:)
if [[ "$INPUT_ARG" == http* ]] || [[ "$INPUT_ARG" == spotify:* ]]; then
    SPOTIFY_URL="$INPUT_ARG"
else
    # Zoek de alias op in het configuratiebestand
    if [ -f "$CONFIG_FILE" ]; then
        # Haal de url op bij de alias (pakt alles na de eerste '=')
        SPOTIFY_URL=$(grep "^${INPUT_ARG}=" "$CONFIG_FILE" | cut -d'=' -f2-)
    fi
    
    # Als de URL leeg is, is de alias niet gevonden
    if [ -z "$SPOTIFY_URL" ]; then
        echo "Fout: Alias '$INPUT_ARG' niet gevonden in $CONFIG_FILE en het is geen geldige URL."
        exit 1
    fi
    
    IS_ALIAS=true
fi

# Verwerk de overige argumenten
shift
while [[ $# -gt 0 ]]; do
    case "$1" in
        --output)
            if [ -n "$2" ] && [[ "$2" != -* ]]; then
                OUTPUT="$2"
                shift 2
            else
                echo "Fout: --output vereist een waarde."
                echo ""
                usage
            fi
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Fout: Onbekend argument '$1'"
            echo ""
            usage
            ;;
    esac
done

# Samenstellen van het Docker Command
CMD_ARGS=("$SPOTIFY_URL")

# Alleen toevoegen als --output daadwerkelijk is meegegeven
if [ -n "$OUTPUT" ]; then
    CMD_ARGS+=("--output" "$OUTPUT")
fi

# Extra vlag toevoegen als er een alias is gebruikt
if [ "$IS_ALIAS" = true ]; then
    CMD_ARGS+=("--output-ext-playlist" "$OUTPUT_PLAYLIST")
fi

# Uitvoeren
docker compose run --rm --remove-orphans zotify python -m zotify "${CMD_ARGS[@]}"
