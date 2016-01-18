# My configuration files

This is based on ideas from 
https://www.digitalocean.com/community/tutorials/how-to-use-git-to-manage-your-user-configuration-files-on-a-linux-vps

To configure a computer:

    git clone --no-checkout https://github.com/ColinPitrat/myconfig.git
    cd myconfig
    git config core.worktree "../../"
    # Beware: this will overwrite existing configuration
    git reset --hard origin/master
    echo "gitdir: `pwd`/.git" > ../.git
