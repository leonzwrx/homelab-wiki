```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```

# neomutt & mutt-wizard  Setup & Config
_Updated August 2025_

### General setup
- Install and run mutt-wizard (reference [https://www.youtube.com/watch?v=iwYL3JzVVXM](https://www.youtube.com/watch?v=iwYL3JzVVXM))
- Follow [Mutt-wizard instructions](https://github.com/LukeSmithxyz/mutt-wizard?tab=readme-ov-file) for general setup
- Get everything synced on the initial computer
- If installing mutt-wizard manually, install dependencies then install from source: `sudo dnf install neomutt isync msmtp pass lynx notmuch abook urlview gettext`

> NOTE: since installing from source puts stuff in `/usr/local` vs `/usr`, when installing from source, use `sudo make install PREFIX=/usr`
   
### Changes, Configs
  Set in `/usr/share/mutt-wizard/mutt-wizard.muttrc` or in the home folder's `muttrc` file:
  ```
  set smtp_authenticators = "login
  ```
`mw -T` to sync every 10

___
  
## Configuring another machine

> If using the same GPG keys - OPTIONAL
> **On the original machine:**
> 1. List your secret keys
> `gpg --list-secret-keys --keyid-format LONG`
>  Note down the full key ID (the long string of hex characters after `sec rsa4096/` or similar).
> 2. Export
> `gpg --export-secret-keys --armor keyid > ~/Downloads/gmail_priv_key.asc`
> #optional`gpg --export --armor keyid > ~/Downloads/gmail_pub_key.asc`
> ___
> **On the destination machine**
> 
> 3. Import
>   `gpg --import gmail_priv_key.asc`
> #optional`gpg --import gmail_pub_key.asc`
> 
> 4. Trust
>  `gpg --edit-key keyid`
> 	at the `gpg` prompt, type `trust`, then select `5` (I trust ultimately), then `y` to confirm, and finally quit.
> 5. Reload
> ```
> gpgconf --kill gpg-agent
> gpgconf --launch gpg-agent
> ```
> 6. Initialize - this creates the `~/.password-store` directory, linked to your existing key.
> `pass init email@gmail.com`
> 7. **Crucial step: Copy your existing `~/.password-store` from your old computer to your new one.** This contains your actual encrypted passwords. 

**Another option - copy `~/.gnupg` from another machine or from backups, use `gpg --list-sercret-keys` to verify**

### Continue here after keys are set or imported
1. **Clone Your Dotfiles Repository:** This will bring in your `~/.config/mutt/muttrc` and `~/.config/mutt/accounts/` files.
2. Install mutt-wizard, then run `mw -a email@gmail.com`
   Because `pass` is now initialized and populated (from step 4), `mutt-wizard` should correctly find your credentials and configure `msmtp` and `mbsync` to use them. It won't prompt for passwords if they're already in `pass`.
3. If not already done, initialize pass with a GPG key`pass init email…` then add your email password to _pass_ `pass insert email` - this should prompt for the password. Provide Gmail's App password if needed, not the regular password
4. `mbsync -a` - this should work if password retrieval is sucessful. NOTE: If `mbsync -a` throws errors about not finding maildir, create a new directory `mkdir -p ~/.local/share/mail/leonid.nilva@gmail.com`
5. If _notmuch_ is not setup, set using `notmuch setup` and initialize new database usinng `notmuch new` - by default, _mw_ will do all of this the first time
___

## Tips
- To star a gmail message, 'copy' to Starred mailbox. or use shortcut C*. To unstar, DELETE from Starred
- To sync address book, copy `~/.abook/addressbook` to another machine