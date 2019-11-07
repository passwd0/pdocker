local ZSH_CONF=/root/.zsh
	autoload -Uz promptinit && promptinit && prompt walters
	export PS1="%B%(?..[%?] )%b%n@%U%F{3}%m%f%u> "
	export VISUAL=vim
	export EDITOR=vim
	export WORDCHARS='|*?_-.[]~=&;!#$%^(){}<>'
	export PAGER=less
	export LESS="-R"
	export LANG="en_US.UTF-8"

# Misc
	#setopt function_arg_zero
	setopt ZLE                         # Enable the ZLE line editor
	declare -U path                    # prevent duplicate entries in path
	LESSHISTFILE="/dev/null"           # Prevent the less hist file from being made, I don't want it
	umask 002                          # Default permissions for new files, subract from 777 to understand
	setopt NO_BEEP                     # Disable beeps
	setopt NO_HUP                      # Kill all child processes when we exit, don't leave them running
	setopt INTERACTIVE_COMMENTS        # Allows comments in interactive shell.
	setopt RC_EXPAND_PARAM             # Abc{$cool}efg where $cool is an array surrounds all array variables individually
	unsetopt FLOW_CONTROL              # Ctrl+S and Ctrl+Q usually disable/enable tty input. This disables those inputs
	setopt LONG_LIST_JOBS              # List jobs in the long format by default. (I don't know what this does but it sounds good)
	unsetopt vi                          # Make the shell act like vi if i hit escape

# ZSH History
	alias history='fc -fl 1'
	HISTFILE=~/.history    # Keep our home directory neat by keeping the histfile somewhere else
	SAVEHIST=10000                     # Big history
	HISTSIZE=10000                     # Big history
	setopt EXTENDED_HISTORY            # Include more information about when the command was executed, etc
	setopt APPEND_HISTORY              # Allow multiple terminal sessions to all append to one zsh command history
	setopt HIST_FIND_NO_DUPS           # When searching history don't display results already cycled through twice
	setopt HIST_EXPIRE_DUPS_FIRST      # When duplicates are entered, get rid of the duplicates first when we hit $HISTSIZE
	setopt HIST_IGNORE_SPACE           # Don't enter commands into history if they start with a space
	setopt HIST_VERIFY                 # makes history substitution commands a bit nicer. I don't fully understand
	setopt SHARE_HISTORY               # Shares history across multiple zsh sessions, in real time
	setopt HIST_IGNORE_DUPS            # Do not write events to history that are duplicates of the immediately previous event
	setopt INC_APPEND_HISTORY          # Add commands to history as they are typed, don't wait until shell exit
	setopt HIST_REDUCE_BLANKS          # Remove extra blanks from each command line being added to history



	autoload -Uz compinit                                  	# Autoload auto completion
	compinit -i -d "${ZSH_COMPDUMP}"                        # Init auto completion; tell where to store autocomplete dump
	zstyle ':completion:*' menu select                      # Have the menu highlight as we cycle through options
	zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
	setopt COMPLETE_IN_WORD                                 # Allow completion from within a word/phrase
	setopt ALWAYS_TO_END                                    # When completing from the middle of a word, move cursor to end of word
	#setopt MENU_COMPLETE                                    # When using auto-complete, put the first option on the line immediately
	setopt COMPLETE_ALIASES                                 # Turn on completion for aliases as well
	#setopt LIST_ROWS_FIRST                                  # Cycle through menus horizontally instead of vertically

	setopt NO_CASE_GLOB				# Case insensitive wildcard
	setopt NO_CLOBBER				#'>' cant overwrite, use '>|'
	setopt EXTENDED_GLOB				# extends globbing feature
	setopt NUMERIC_GLOB_SORT			# Sort globs that expand to numbers numerically, not by letter (i.e. 01 2 03)

# Aliases
	git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"

	alias -g ...='../..'
	alias -g ....='../../..'
	alias -g .....='../../../..'
	alias -g ......='../../../../..'
	alias -g .......='../../../../../..'
	alias -g ........='../../../../../../..'

	alias ls="ls -h --color='auto'"
	alias lsa='ls -a'
	alias ll='ls -l'
	alias la='ls -la'
	alias cdl=changeDirectory; function changeDirectory { cd $1 ; la }

	alias md='mkdir -p'
	alias rd='rmdir'

	# Search running processes. Usage: psg <process_name>
	alias psg="ps aux $( [[ -n "$(uname -a | grep CYGWIN )" ]] && echo '-W') | grep -i $1"

	# Copy with a progress bar
	alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"

	alias d='dirs -v | head -10'   # List the last ten directories we've been to this session, no duplicates

	if [[ -f '/opt/peepdf/peepdf.py' ]]; then
		alias peepdf='python2.7 /opt/peepdf/peepdf.py'
	fi

	for env in /root/env*; do
		if [[ -f "${env}/bin/activate" ]]; then
			alias $(basename "$env")=". $env/bin/activate"
		fi
	done

# Key Bindings

	# move
	autoload -Uz history-search-end
	bindkey '^H'		backward-word
		zle -N history-beginning-search-backward-end history-search-end
	bindkey "^K" history-beginning-search-backward-end

		zle -N history-beginning-search-forward-end history-search-end
	bindkey "^J" history-beginning-search-forward-end
	bindkey '^L'		forward-word
	bindkey '^[[1;5D'	backward-word			#ctrl+left
	bindkey '^[[1;5C'	forward-word			#ctrl+right
	bindkey '^[^H'		backward-char
	bindkey '^[^L'		forward-char
	# default move
	bindkey '^A'		beginning-of-line
	bindkey '^E'		end-of-line
	bindkey '^D'		kill-word
	bindkey '^W'		backward-kill-word
	# default delete
	bindkey '^[[23~'	backward-kill-word
	bindkey '^[[3^'		kill-word
	bindkey '^[[3~'		delete-char
	# overwrite
	autoload -Uz history-search-end
		zle -N history-beginning-search-backward-end history-search-end
	bindkey "^[[A" history-beginning-search-backward-end

		zle -N history-beginning-search-forward-end history-search-end
	bindkey "^[[B" history-beginning-search-forward-end

	bindkey "\e\e" sudo-command-line		# [Esc] [Esc] - insert "sudo" at beginning of line
	zle -N sudo-command-line
	sudo-command-line() {
		[[ -z $BUFFER ]] && zle up-history
		if [[ $BUFFER == sudo\ * ]]; then
			LBUFFER="${LBUFFER#sudo }"
		else
			LBUFFER="sudo $LBUFFER"
		fi
	}

# Setup grep to be a bit more nice

	grep-flag-available() {echo | grep $1 "" >/dev/null 2>&1}

	local GREP_OPTIONS=""
	export LS_COLORS=":ow=0;31"
	# color grep results
	if grep-flag-available --color=auto; then
		GREP_OPTIONS+=" --color=auto"
	fi

	# ignore VCS folders (if the necessary grep flags are available)
	local VCS_FOLDERS="{.bzr,CVS,.git,.hg,.svn}"

	if grep-flag-available --exclude-dir=.cvs; then
		GREP_OPTIONS+=" --exclude-dir=$VCS_FOLDERS"
	elif grep-flag-available --exclude=.cvs; then
		GREP_OPTIONS+=" --exclude=$VCS_FOLDERS"
	fi

	# export grep settings
	alias grep="grep $GREP_OPTIONS"

	# clean up
	unfunction grep-flag-available

	# Allow local zsh settings (superseding anything in here) in case I want something specific for certain machines
	if [[ -r $LOCAL_ZSHRC ]]; then
		. $LOCAL_ZSHRC
	fi
