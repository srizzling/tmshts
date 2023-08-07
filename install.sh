#!/usr/bin/env fish

# Update package list
sudo apt update

# Install fish
sudo apt install -y fish

# Install npm (which includes Node.js)
sudo apt install -y npm

# Install tempomat globally
sudo npm install -g tempomat

# Run tempo setup
# Note: This might require interactive setup. Depending on what this does, you may need to handle this separately or manually.
tempo setup

# Install mail utilities for emailing from cron
sudo apt install -y mailutils

# Determine absolute path of the tmsht.fish script
set script_path (pwd)/tmsht.fish

# Ensure your script has execute permissions
chmod +x $script_path

# Add the fish script to cron
echo "0 17 * * 5 /usr/bin/fish $script_path | sudo tee -a /etc/crontab > /dev/null
