# Setting up username:
git config --global user.name "vtpb"
# Email id:
git config --global user.email "vascotpbatista@gmail.com"
# Avoid merging conflicts when pulling:
git config --global branch.autosetuprebase always
# Enable color highlighting for Git in console:
git config --global color.ui true
git config --global color.status auto
git config --global color.branch auto
# Setting default editor:
git config --global core.editor nvim
# Set default merge tool:
git config --global merge.tool nvim -d
# List of Git settings (changed settings):
git config --list 
