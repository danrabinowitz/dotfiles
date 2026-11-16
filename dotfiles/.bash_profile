# Bash login shell. .bashrc uses PROFILE_SOURCED to avoid loading the shared
# environment a second time, but still handles noninteractive shells directly.

[ -f "$HOME/.profile" ] && . "$HOME/.profile"
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
[ -f "$HOME/.bash_profile_local" ] && . "$HOME/.bash_profile_local"

for _gcloud_config in path.bash.inc completion.bash.inc; do
  [ -f "$HOME/google-cloud-sdk/$_gcloud_config" ] && \
    . "$HOME/google-cloud-sdk/$_gcloud_config"
done
unset _gcloud_config
