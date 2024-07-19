# Description:Memes for fish shell

echo "Memes loaded: "
echo "  - bruh -- plays bruh sound"
echo "  - oomg -- plays oomg sound"
echo "  - ejectbruh -- ejects and plays bruh sound"
echo "  - sl -- ejectbruh"
echo "  - cdoe -- ejectbruh"

if status is-interactive
    # playsound
    alias bruh='nohup play -q ~/.sound/bruh.mp3 2> /dev/null'
    alias oomg='nohup play -q ~/.sound/oomg.mp3 2> /dev/null'

    alias ejectbruh="eject &; bruh"
    alias sl="ejectbruh"
    alias cdoe="ejectbruh"
end
