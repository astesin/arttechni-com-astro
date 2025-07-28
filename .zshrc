
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/stesin/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/stesin/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/stesin/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/stesin/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# SSH Agent Management
# ===================

# Define the path to your primary SSH key (adjust if different)
# If you have multiple keys, you can list them in an array, e.g.,
# SSH_KEYS=(~/.ssh/id_rsa ~/.ssh/id_ed25519)
SSH_PRIMARY_KEY="$HOME/.ssh/id_gitlab_rsa"

# Check if an ssh-agent is already running and accessible
if ! ssh-add -l > /dev/null 2>&1; then
  # No agent running or accessible, so start one
  echo "Starting ssh-agent..."
  eval "$(ssh-agent -s)"

  # Add your primary SSH key to the agent
  if [ -f "$SSH_PRIMARY_KEY" ]; then
    echo "Adding SSH key: $SSH_PRIMARY_KEY"
    ssh-add "$SSH_PRIMARY_KEY"
  else
    echo "Warning: SSH primary key not found at $SSH_PRIMARY_KEY"
    echo "Please ensure your SSH key exists or update SSH_PRIMARY_KEY in ~/.zshrc."
  fi

  # If you have multiple keys, loop through them
  # for key in "${SSH_KEYS[@]}"; do
  #   if [ -f "$key" ]; then
  #     echo "Adding SSH key: $key"
  #     ssh-add "$key"
  #   else
  #     echo "Warning: SSH key not found at $key"
  #   fi
  # done

else
  # Agent is running, but let's check if keys are loaded
  if ssh-add -l | grep -q "$SSH_PRIMARY_KEY"; then
    # Primary key is already loaded
    : # Do nothing, just a placeholder for clarity
  else
    # Agent is running, but primary key isn't loaded, so add it
    echo "SSH agent is running, but key $SSH_PRIMARY_KEY is not loaded. Adding it..."
    if [ -f "$SSH_PRIMARY_KEY" ]; then
      ssh-add "$SSH_PRIMARY_KEY"
    else
      echo "Warning: SSH primary key not found at $SSH_PRIMARY_KEY. Cannot add."
    fi
  fi

  # If you have multiple keys and want to ensure all are loaded
  # for key in "${SSH_KEYS[@]}"; do
  #   if ! ssh-add -l | grep -q "$(basename "$key")"; then
  #     if [ -f "$key" ]; then
  #       echo "Adding SSH key: $key"
  #       ssh-add "$key"
  #     else
  #       echo "Warning: SSH key not found at $key"
  #     fi
  #   fi
  # done
fi

