#!/usr/bin/env bash

# Check if user is running as root (sudo)
if [ "$(id -u)" != "0" ] ; then
  echo "Sorry, you need to run this script as root, else it will not do much good."
  echo -e "Try the following command:\n"
  echo -e "sudo ./instrulator.sh\n"
  exit 1
fi

CURR_USER=$(who | awk '{print $1}')

NUM_INSTALLS=0

echo -n "Install Google Chrome? [y/N] " && read CHROME && [ "$CHROME" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install Spotify? [y/N] " && read SPOTIFY && [ "$SPOTIFY" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install Node.js? [y/N] " && read NODE && [ "$NODE" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install MongoDB? [y/N] " && read MONGODB && [ "$MONGODB" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install gimp? [y/N] " && read GIMP && [ "$GIMP" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install Steam? [y/N] " && read STEAM && [ "$STEAM" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install Dropbox? [y/N] " && read DROPBOX && [ "$DROPBOX" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install Virtualbox? [y/N] " && read VIRTUALBOX && [ "$VIRTUALBOX" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install pip for Python? [y/N] " && read PIP && [ "$PIP" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
if [ "$PIP" == y ] ; then echo -n "Install numpy for Python? [y/N] " && read NUMPY && [ "$NUMPY" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL)) ; fi
if [ "$PIP" == y ] ; then echo -n "Install scipy for Python? [y/N] " && read SCIPY && [ "$SCIPY" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL)) ; fi
echo -n "Install irssi IRC client? [y/N] " && read IRSSI && [ "$IRSSI" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install IntelliJ 15 Ultimate Edition? [y/N] " && read INTELLIJ && [ "$INTELLIJ" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install compiz config manager? [y/N] " && read COMPIZ && [ "$COMPIZ" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install QEMU machine emulator? [y/N] " && read QEMU && [ "$QEMU" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install Meteor.js? [y/N] " && read METEOR && [ "$METEOR" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install git? [y/N] " && read GIT && [ "$GIT" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install Atom editor? [y/N] " && read ATOM && [ "$ATOM" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install BOINC? [y/N] " && read BOINC && [ "$BOINC" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))
echo -n "Install Java 8 JDK? [y/N] " && read JAVA8 && [ "$JAVA8" != "y" ] ; BOOL=$? && NUM_INSTALLS=$((NUM_INSTALLS+BOOL))

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
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
  echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
fi

if [ "$CHROME" == y ] ; then
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
  sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
fi

if [ "$MONGODB" == y ] ; then
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
  echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
fi

if [ "$JAVA8" == y ] ; then
  add-apt-repository ppa:webupd8team/java
fi

echo "Updating repository list..."
apt-get update -qq

# Install Node.js using NVM
if [ "$NODE" == y ] ; then
  echo "Installing Node..."
  apt-get install build-essential libssl-dev
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | sudo -u $CURR_USER bash
  export NVM_DIR=/home/$CURR_USER/.nvm
  source /home/$CURR_USER/.nvm/nvm.sh
  source /home/$CURR_USER/.profile
  source /home/$CURR_USER/.bashrc
  nvm install node
  nvm use node
  nvm alias default node
fi

# Install Dropbox
if [ "$DROPBOX" == y ] ; then
  echo "Installing Dropbox..."
  cd /home/$CURR_USER && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
  wget https://raw.githubusercontent.com/draperunner/instrulator/master/dropboxd.desktop
  sudo -u $CURR_USER mkdir -p /home/$CURR_USER/.config/autostart
  sudo -u $CURR_USER touch /home/$CURR_USER/.config/autostart/dropboxd.desktop
  envsubst < dropboxd.desktop > /home/$CURR_USER/.config/autostart/dropboxd.desktop
  rm dropboxd.desktop
fi

if [ "$ATOM" == y ] ; then
  echo "Installing Atom..."
  wget "https://atom.io/download/deb"
  dkpg -i atom-amd64.deb
  rm atom-amd64.deb
fi

if [ "$CHROME" == y ] ; then echo "Installing Chrome..." && apt-get install -qqy google-chrome-stable ; fi
if [ "$SPOTIFY" == y ] ; then echo "Installing Spotify..." && apt-get install -qqy spotify-client ; fi
if [ "$GIMP" == y ] ; then echo "Installing gimp..." && apt-get install -qqy gimp ; fi
if [ "$STEAM" == y ] ; then echo "Installing Steam..." && apt-get install -qqy steam ; fi
if [ "$VIRTUALBOX" == y ] ; then echo "Installing Virtualbox..." && apt-get install -qqy virtualbox-qt ; fi
if [ "$PIP" == y ] ; then echo "Installing pip..." && apt-get install -qqy python-pip python3-pip python-setuptools; fi
if [ "$NUMPY" == y ] ; then echo "Installing numpy..." && pip install numpy && pip3 install numpy ; fi
if [ "$SCIPY" == y ] ; then echo "Installing scipy..." && pip install scipy && pip3 install scipy ; fi
if [ "$IRSSI" == y ] ; then echo "Installing irssi..." && apt-get install -qqy irssi ; fi
if [ "$METEOR" == y ] ; then echo "Installing Meteor.js..." && curl https://install.meteor.com/ | sudo -u $CURR_USER sh ; fi

if [ "$MONGODB" == y ] ; then
  echo "Installing MongoDB..."
  apt-get install -y mongodb-org
  touch /etc/systemd/system/mongodb.service
  echo "[Unit]" >> /etc/systemd/system/mongodb.service
  echo "Description=High-performance, schema-free document-oriented database" >> /etc/systemd/system/mongodb.service
  echo "After=network.target" >> /etc/systemd/system/mongodb.service
  echo "" >> /etc/systemd/system/mongodb.service
  echo "[Service]" >> /etc/systemd/system/mongodb.service
  echo "User=mongodb" >> /etc/systemd/system/mongodb.service
  echo "ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf" >> /etc/systemd/system/mongodb.service
  echo "" >> /etc/systemd/system/mongodb.service
  echo "[Install]" >> /etc/systemd/system/mongodb.service
  echo "WantedBy=multi-user.target" >> /etc/systemd/system/mongodb.service
  systemctl start mongodb
  systemctl enable mongodb
fi

if [ "$JAVA8" == y ] ; then
  echo "Installing Java 8 JDK..."
  apt-get install oracle-java8-installer
  echo 'JAVA_HOME="/usr/lib/jvm/java-8-oracle"' >> /etc/environment
  . /etc/environment
fi

if [ "$INTELLIJ" == y ] ; then
  echo "Installing IntelliJ 15..."
  wget https://d1opms6zj7jotq.cloudfront.net/idea/ideaIU-15.0.tar.gz
  tar -zxf ideaIU-15.0.tar.gz
  rm ideaIU-150.tar.gz
  mv idea-IU-143.381.42 /opt/
fi

if [ "$COMPIZ" == y ] ; then echo "Installing compiz..." && apt-get install -qqy compiz-config-manager ; fi
if [ "$QEMU" == y ] ; then echo "Installing QEMU..." && apt-get install -qqy qemu-kvm qemu virt-manager virt-viewer libvirt-bin ; fi
if [ "$GIT" == y ] ; then echo "Installing git..." && apt-get install -qqy git ; fi
if [ "$BOINC" == y ] ; then echo "Installing BOINC..." && apt-get install -qqy boinc-client boinc-manager ; fi

echo -e "...done!\n"
if [ "$DROPBOX" == y ] ; then echo "PS! Use the command '~/.dropbox-dist/dropboxd' to run Dropbox for the first time. It will automatically start on boot" ; fi
if [ "$INTELLIJ" == y ] ; then echo "PS! Use the command '/opt/ideaIU*/bin/idea.sh' to run IntelliJ for the first time." ; fi
