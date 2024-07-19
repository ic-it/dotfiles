source ~/.config/fish/git_aliases.fish

# fish_default_key_bindings
fish_vi_key_bindings

set fish_greeting

function mkdcd
    mkdir $argv
    cd $argv
end

function rm-chlocks
    rm /home/ic-it/.var/app/com.spotify.Client/cache/spotify/SingletonLock
    rm ~/.config/google-chrome-unstable/SingletonLock
end

# Load a script from ~/.config/fish/scripts
for file in ~/.config/fish/scripts/*.fish
    set desc $(sed -n 's/# Description: //p' $file)
    set name $(basename -s .fish $file)
    if test -z $desc
        set desc "No description"
    end
    complete -f -c load-script -a $name -d $desc
end
function load-script
    if test -z $argv
        echo "Usage: load-script <script-name>"
        return 1
    end
    if not test -f ~/.config/fish/scripts/$argv.fish
        echo "Script $argv not found"
        return 1
    end
    source ~/.config/fish/scripts/$argv.fish
end

load-script runglish

alias :q="exit"
alias :w="echo This Is NOT a vim && eject"
alias :wq="exit"
alias less="less -R"
alias cls=clear
alias chmox="chmod +x"

if type -q rg
    alias rg="rg -A 3 -B 3"
else
    echo "ripgrep not found"
end

if not type -q code
    alias code="code-insiders"
    complete -c code -a code-insiders
end

if type -q exa
    alias e="exa -abF --group-directories-first --icons"
    alias ex="exa -abF --group-directories-first --icons -lTL 1 --no-time --git --no-user"
    alias la="ex"
    alias ll="ex"
    alias l="e"
else
    echo "exa not found, using ls"
    alias e="ls -a"
    alias ex="ls -al"
    alias la="ex"
    alias ll="ex"
    alias l="e"
end

# Paths
fish_add_path ~/go/bin
fish_add_path /usr/local/go/bin
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/bin

# Exports
export PYTHONDONTWRITEBYTECODE=1
export VISUAL=lvim
export EDITOR=lvim

# zoxide <3
if type -q zoxide
    zoxide init fish --cmd cd | source
else
    echo "zoxide not found"
end

# direnv
if type -q direnv
    direnv hook fish | source
else
    echo "direnv not found"
end
