# VIM Plugins & Shortcuts
```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
```

*Updated July 2024*

## General plugin info - current setup

- vim-plug is the current plugin manager: 		https://github.com/junegunn/vim-plug

- ~/.vim/autoload/plug.vim
Purpose: This file is the core of vim-plug. It contains the code necessary for managing plugins—installing, updating, and loading them.
How it works: When you call `plug#begin()` and `plug#end()` in your .vimrc, plug.vim handles these commands and manages your plugins accordingly.

- ~/.vim/plugged
Purpose: This directory is where vim-plug installs and stores all the plugins you specify in your .vimrc.
How it works: When you use Plug 'plugin/repo' in your .vimrc and run `:PlugInstall`, vim-plug clones the specified repositories into the ~/.vim/plugged directory.
Management: This directory is automatically populated and managed by vim-plug, based on the plugins you list in your configuration.


- FOR WINDOWS: manually download the plug.vim file from vim-plug GitHub and place it in the C:\Users<YourUsername>\vimfiles\autoload\ directory.
Then, modify _vimrc file to call the Plugins


- Adding Plugins: Add the Plug 'username/repo' lines to your .vimrc within the `plug#begin()` and `plug#end()` block.
Installing Plugins: Run `:PlugInstall` in Vim.
Cleaning Up Plugins: Run `:PlugClean` in Vim to remove any plugins no longer listed in your .vimrc.
- Updating Plugins: Run `:PlugUpdate` in Vim.
For automatic updates, add this to .vimrc
`autocmd VimEnter * PlugUpdate --sync | source $MYVIMRC`
- To See status:
`:PlugStatus`


## Current Plugins


```shell
Plug 'itchyny/lightline.vim' "Highlights lines
Missing a seat
Plug 'joshdick/onedark.vim' "The One Dark Theme
Plug 'nordtheme/vim' "Nord Theme
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' "Fuzzy find plugin
Plug 'junegunn/goyo.vim' "Removes Line numbers for focusing
Plug 'mbbill/undotree' "Creates an undo tree
Plug 'preservim/nerdtree' "File browser inside vim
Plug 'godlygeek/tabular' "Auto formatting
Plug 'plasticboy/vim-markdown' "Markdown syntax highlighting
Plug 'ryanoasis/vim-devicons' "Cool icons for nerd tree
Plug 'Xuyuanp/nerdtree-git-plugin' "nerd tree customization
Plug '907th/vim-auto-save' "auto saves files as you edit
Plug 'jasonccox/vim-wayland-clipboard' "workaround for vim's Wayland issues. Use "+ prior to y or p commands
```


## Shortcuts and use

`\-1 thru 5` switch to particular tab
`\-t` :tabnew
`\-c` :tabclose
---
### FZF
---


:Files or :Files! for full screen
Description: Opens a fuzzy finder to search for files in the current working directory. Start typing to filter the list of files.
- mapped to `\ f`
:Buffers
Description: Lists and allows you to switch between open buffers. Useful for quickly navigating between multiple open files.
:History
- mapped to `\ h`
Description: Shows the command history, allowing you to search and re-run previous commands.
:GFiles
Description: Lists git-tracked files in the current repository. Useful for navigating a git project.
:Commits
Description: Shows git commit history. You can search and check out specific commits.
:BCommits
Description: Shows git commit history for the current buffer/file.
:Commands
Description: Lists and searches available Vim commands. Handy for discovering and running less frequently used commands.


---
### GOYO
---
:Goyo - Toggle Goyo on/off
- mapped to `\ g`
:Goyo 120x50% - Resize by width and %
---
### UNDOTREE
---
Use :UndotreeToggle to toggle the undo-tree panel.
- mapped to `F5`, hit ? for quick help
- use CTRL-WW to switch between tabs or TAB to go to document tab
- hit ENTER to view the particular undo state
- :earlier 10m or :earlier 1d or :later 3m to travel to a specific time

---
### NERDTREE
---
Use :NERDtreeToggle to toggle the browser
- mapped to `\ n`, hit ? for quick help
t: Open the selected file in a new tab
i: Open the selected file in a horizontal split window
s: Open the selected file in a vertical split window
I: Toggle hidden files
m: Show the NERD Tree menu
R: Refresh the tree, useful if files change outside of Vim
?: Toggle NERD Tree's quick helpsample markdown text
B: Bookmarks. To bookmark a location, type `:Bookmark`

---
### TABULARIZE
---
- mapped to `\ l`
- Basic usage: http://vimcasts.org/episodes/aligning-text-with-tabular-vim
- Positione your cursor inside a relavant block or line and run `:Tab/:` or  which would line up text based on `:`