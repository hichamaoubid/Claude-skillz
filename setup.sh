#!/bin/bash
# Installe skills, préférences et dépendances de /watch. Ne doit jamais bloquer le démarrage de session.
T=$(mktemp -d)
git clone --depth 1 https://github.com/hichamaoubid/Claude-skillz "$T/cs" || exit 0
mkdir -p ~/.claude/skills
for d in "$T"/cs/skills/*/; do rm -rf ~/.claude/skills/$(basename "$d"); cp -r "$d" ~/.claude/skills/; done
cp "$T/cs/config/CLAUDE.md" ~/.claude/CLAUDE.md
command -v ffmpeg >/dev/null || { apt-get install -y -qq ffmpeg >/dev/null 2>&1 || true; }
command -v yt-dlp >/dev/null || pip install -q yt-dlp >/dev/null 2>&1 || true
# Config /watch préremplie (sans clé) pour éviter l'assistant de premier lancement
if [ ! -f ~/.config/watch/.env ]; then
  mkdir -p ~/.config/watch
  printf 'SETUP_COMPLETE=true\nWATCH_ENGINE=auto\nWATCH_DETAIL=efficient\nWATCH_WHISPER_BACKEND=auto\n' > ~/.config/watch/.env
  chmod 600 ~/.config/watch/.env
fi
rm -rf "$T"
exit 0
