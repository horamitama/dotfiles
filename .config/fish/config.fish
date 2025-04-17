if status is-interactive
    eval (/opt/homebrew/bin/brew shellenv)
end

alias v nvim
alias vim nvim
alias g git
alias e exit
alias c clear
alias t tmux
alias k kubectl

# Prompt options
set -g theme_nerd_fonts yes
set -g theme_powerline_fonts no
set -g theme_color_scheme nord
set -g theme_display_user ssh
set -g theme_display_go verbose
set -g theme_display_node yes
# set -g theme_display_k8s_context yes
set -g theme_display_k8s_namespace yes
set -g theme_display_git yes
set -g theme_display_git_default_branch yes

# Right prompt options
set -g theme_date_format +%m/%d-%H:%M:%S

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/s-nakaue/.gcloud/google-cloud-sdk/path.fish.inc' ]
    . '/Users/s-nakaue/.gcloud/google-cloud-sdk/path.fish.inc'
end
