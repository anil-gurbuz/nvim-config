
### Linux dependencies and nvim install
```
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip curl

# Now we install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-amd64.tar.gz
sudo rm -rf /opt/nvim-linux-amd64
sudo mkdir -p /opt/nvim-linux-amd64
sudo chmod a+rX /opt/nvim-linux-amd64
sudo tar -C /opt -xzf nvim-linux-amd64.tar.gz

# make it available in /usr/local/bin, distro installs to /usr/bin
sudo ln -sf /opt/nvim-linux-amd64/bin/nvim /usr/local/bin/
```

- After installign the dependencies, you might need to restart the machine.

## To install the same config in linux
`git clone https://github.com/anil-gurbuz/nvim-config  "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim`


#### Note
- Need to have Nerd fonts installed for icons to display properly
