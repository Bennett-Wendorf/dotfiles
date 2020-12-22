# How to Set Up

Navigate to the /etc/pacman.d/hooks/ directory or create it if it doesn't exist yet.

Then, for each hook in this directory, run 

"sudo ln -s ~/PacmanHooks/[Name of Hook].hook ."

This will create a symbolic link to the hook, meaning that pacman will automatically run it after the specified transactions. This also means that any changes to the files made in this directory will automatically be used when pacman runs the hook.
