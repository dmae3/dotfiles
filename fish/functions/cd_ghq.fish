# cd to a ghq-managed repository using fzf (replaces anyframe-widget-cd-ghq-repository)
function cd_ghq
    set -l repo (ghq list | fzf --prompt="ghq > ")
    if test -n "$repo"
        cd (ghq root)/$repo
        commandline -f repaint
    end
end
