```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```                                                    
*UPDATED JULY 2024*

## Vim Tips and Tricks

### Hidden Commands and Features

**Insert Mode**

* `Ctrl+u`: Delete characters from the cursor to the beginning of the line.
* `Ctrl+o`: Temporarily enter normal mode while in insert mode.
* `Ctrl+d`: Delete text from the cursor to the end of the line.


**Normal Mode**

* `dt+`: Delete text until the next `+` character (exclusive).
* `df+`: Delete text until the next `+` character (inclusive).
* `dT+`: Delete text backward until the previous `+` character (exclusive).
* `dF+`: Delete text backward until the previous `+` character (inclusive).
* `di"`, `di<`, `di(`: Delete text inside quotes, angle brackets, or parentheses, respectively.
* `ci"`, `ci<`, `ci(`: Change (delete and enter insert mode) text inside quotes, angle brackets, or parentheses, respectively.
* `yi"`, `yi<`: Yank (copy) text inside quotes or angle brackets, respectively.
* `=`: Automatically indent the current line based on syntax.
* `=gg`: Automatically indent the entire file.
* `=G`: Automatically indent the current line to the end of the file.
* `:jumps`: Show a list of previous cursor positions.
* `Ctrl+o`: Jump to the previous cursor position.
* `Ctrl+i`: Jump to the next cursor position.

### Searching and Spelling

* **Case-insensitive search:** Use `\c` in the search pattern (e.g., `/\ccopyright`).
* **Spelling correction:**
  * Enable spell checking with `:set spell spelllang=en_us`.
  * Add a word to the internal spell file: `zg`.
  * Undo adding a word: `zw`.
  * Jump to the next misspelled word: `[s`.
  * Jump to the previous misspelled word: `]s`.
  * Disable spell checking: `:set nospell`.
  * Custom spell file location: `/home/leo/.vim/spell/en.utf-8.add`.

### External Commands and File Retrieval
* **Execute a system command and insert the output:**
  ```vim
  :r !sudo cat /etc/fstab | grep-i backup
  ```
* **Execute a system command:**
  ```vim
  :r !hostnamectl
  ```
* **Show available commands:** `Ctrl+D` in command mode.
* **Open recent files:** `:browse oldfiles`.

### Commenting
* **Comment lines:**
  ```vim
  :10,100s/^/#/
  ```
* **Uncomment lines:**
  ```vim
  :10,100s/^#//
  ```
* **Visual mode commenting:**
  * Select lines with `Ctrl+v`.
  * Enter insert mode at beginning with `I`.
  * Type `#` and press `Esc`.

### Windows and Tabs
* **Equalize window sizes:** `Ctrl+w =`.
* **Change window width/height:** `Ctrl+w <`, `Ctrl+w >`, `Ctrl+w +`, `Ctrl+w -`.
* **Move between windows:** `Ctrl+w h`, `Ctrl+w j`, `Ctrl+w k`, `Ctrl+w l`.
* **Close current window:** `Ctrl+w c`.
* **Close all but current window:** `Ctrl+w o`.

### Help and Settings
* **Get help:** `:h <command>`, `:h <mode>_command`.
* **View settings:** `:set option?`.
* **Ignore case in search:** `:set ic`.
* **Highlight search results:** `:set hlsearch`.
* **Incremental search:** `:set incsearch`.

### Folding
* **Set folding method:** `:set foldmethod=syntax`.
* **Create a fold:** `zf{motion}`.
* **Open/close folds:** `zo`, `zc`, `zO`, `zC`.
* **Toggle fold:** `za`.
* **Delete fold:** `zd`, `zD`, `zE`.
* **Save/load folds:** `:mkview`, `:loadview`.

### Random
- To enter sudo mode if editing a system file:
```vim
:w ! sudo tee /etc/filename