```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
```

*Updated July 2024*

## Vim: Global Commands and Macros

### Global Commands

Global commands operate on all lines in a file or a selected range that match a specific pattern. 

**Example:** Deleting commented lines

Let's say you want to remove all lines that start with `#` and end with `!` (comments). You can use the following global command:

```vim
:g/^#.*!$/d
```

**Breakdown:**

* `:g` - Initiates a global command.
* `^#` - Matches lines starting with `#`.
* `.*` - Matches any characters (zero or more) in between.
* `!$` - Matches lines ending with `!`.
* `d` - Deletes the matching lines.

**Additional Tips:**

* Use `:g/pattern/s/old/new/g` to replace text globally (replace `pattern`, `old`, and `new` with your specific values).
* Experiment with different patterns for various global editing tasks.

### Macros

Macros record a sequence of Vim commands and keystrokes that can be replayed later. This is helpful for repetitive tasks.

**Example:** Adding " - Done" to a list

Suppose you have a list of items and want to append " - Done" to each line. Here's how to create a macro:

1. **Start Recording:** Press `qa`.
2. **Record Actions:**
    * Press `A` to move to the line end in insert mode.
    * Type ` - Done`.
    * Press `Esc` to exit insert mode.
    * Press `j` to move to the next line.
3. **Stop Recording:** Press `q` again.
4. **Execute Macro:** Press `@a` to replay the macro.

**Additional Notes:**

* You can repeat the macro:
    * `10@a`: Executes the macro 10 times.
    * `@@`: Repeats the last recorded macro.
* Use meaningful names for macros (e.g., `qaDD` for deleting a line).
* Macros offer various use cases for efficient editing.