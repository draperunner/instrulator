ARCH="$(uname -m)"

# Check if user is running as root (sudo)
if [ "$(id -u)" != "0" ] ; then
  echo "Sorry, you need to run this script as root, else it will not do much good."
  echo -e "Try the following command:\n"
  echo -e "sudo bash instrulator.sh\n"
  exit 1
fi

NUM_INSTALLS=0

echo -n "Install Google Chrome? [y/n] " && read CHROME && [ "$CHROME" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install Spotify? [y/n] " && read SPOTIFY && [ "$SPOTIFY" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install Node.js? [y/n] " && read NODE && [ "$NODE" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install gimp? [y/n] " && read GIMP && [ "$GIMP" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install Steam? [y/n] " && read STEAM && [ "$STEAM" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install Dropbox? [y/n] " && read DROPBOX && [ "$DROPBOX" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install Virtualbox? [y/n] " && read VIRTUALBOX && [ "$VIRTUALBOX" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install pip for Python? [y/n] " && read PIP && [ "$PIP" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install irssi IRC client? [y/n] " && read IRSSI && [ "$IRSSI" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
if [ "$PIP" == y ] ; then echo -n "Install numpy for Python? [y/n] " && read NUMPY && [ "$NUMPY" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL)) ; fi
if [ "$PIP" == y ] ; then echo -n "Install scipy for Python? [y/n] " && read SCIPY && [ "$SCIPY" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL)) ; fi

if [ "$NUM_INSTALLS" -eq 0 ] ; then
  echo -e "\nNone of the programs will be installed. Why are you running this script?\n"
  exit 1
fi

echo
echo "####################################"
echo "Starting! This might take a while."
echo "Go get a cup of coffee or something."
echo "Installing $NUM_INSTALLS program(s)."
echo "####################################"
echo
echo "Adding repositories and keys"
if [ "$SPOTIFY" == y ] ; then
  apt-add-repository -y "deb http://repository.spotify.com stable non-free"
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D2C19886
fi

if [ "$CHROME" == y ] ; then
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
  sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
fi

echo "Updating repository list..."
apt-get update -qq

# Install Node.js using NVM
if [ "$NODE" == y ] ; then
  echo "Installing Node..."
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
  source ~/.profile
  nvm install 4.2.1
  npm install -g express
  npm install -g nodemon
  npm install -g bower
fi

# Install Dropbox
if [ "$DROPBOX" == y ] ; then
  echo "Installing Dropbox..."
  wget "https://www.dropbox.com/download?plat=lnx.x86_64"
  mv dropbox-lnx.x86_64* ~
  tar xzf /home/$USER/dropbox-lnx.x86_64*
  /home/$USER/.dropbox-dist/dropboxd
  cat > /home/$USER/.config/autostart/dropboxd.desktop << EOM
[Desktop Entry]
Type=Application
Exec=/home/$USER/.dropbox-dist/dropboxd
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=Dropbox
Name=Dropbox
Comment[en_US]=Start Dropbox
Comment=Start Dropbox
EOM
fi

if [ "$CHROME" == y ] ; then echo "Installing Chrome..." && apt-get install -qqy google-chrome-stable ; fi
if [ "$SPOTIFY" == y ] ; then echo "Installing Spotify..." && apt-get install -qqy spotify-client ; fi
if [ "$GIMP" == y ] ; then echo "Installing gimp..." && apt-get install -qqy gimp ; fi
if [ "$STEAM" == y ] ; then echo "Installing Steam..." && apt-get install -qqy steam ; fi
if [ "$VIRTUALBOX" == y ] ; then echo "Installing Virtualbox..." && apt-get install -qqy virtualbox-qt ; fi
if [ "$PIP" == y ] ; then echo "Installing pip..." && apt-get install -qqy python-pip python3-pip python-setuptools; fi
if [ "$NUMPY" == y ] ; then echo "Installing numpy..." && pip install numpy && pip3 install numpy ; fi
if [ "$SCIPY" == y ] ; then echo "Installing scipy..." && pip install scipy && pip3 install scipy ; fi
if [ "$IRSSI" == y ] ; then echo "Installing irssi..." && apt-get install -qq irssi ; fi

echo "...done!"
