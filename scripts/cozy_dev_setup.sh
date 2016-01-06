#!/bin/bash

apt-get -y -qq install couchdb curl git imagemagick python openssl wget sqlite3 build-essential python-dev python-setuptools python-pip libssl-dev libxml2-dev libxslt1-dev supervisor

# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get -y -qq install nodejs

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/couchdb/default.ini
service couchdb restart

useradd -M cozy
useradd -M cozy-data-system
useradd -M cozy-home

mkdir /etc/cozy
chown -hR cozy /etc/cozy

npm install -g coffee-script cozy-monitor
npm install -g git://github.com/nono/cozy-controller#node4

cat >/etc/supervisor/conf.d/cozy-controller.conf <<'EOF'
[program:cozy-controller]
autorestart=true
command=cozy-controller
environment=HOST="0.0.0.0", NODE_ENV="development"
redirect_stderr=true
user=root
EOF

service supervisor restart

COUNT=0; MAX=20
while ! curl -s 127.0.0.1:9002 >/dev/null; do
	let "COUNT += 1"
	echo "Waiting for Cozy Controller to start... ($COUNT/$MAX)"
	if [[ $COUNT -gt $MAX ]]; then
		echo "Cozy Controller is too long to start"
		exit 1
	fi
	sleep 5
done

cozy-monitor install data-system
cozy-monitor install home -r https://github.com/nono/cozy-home.git -b node4
cozy-monitor install proxy -r https://github.com/nono/cozy-proxy.git -b node4

apt-get -y -qq install libsqlite3-dev ruby ruby-dev gem
gem install --no-document mailcatcher

cat >/etc/supervisor/conf.d/mailcatcher.conf <<'EOF'
[program:mailcatcher]
autorestart=true
command=/usr/local/bin/mailcatcher
    --http-ip=0.0.0.0
    --smtp-port=25
    --no-quit
    --foreground
redirect_stderr=true
user=root
EOF

mv /tmp/update-devenv.sh /home/vagrant/update-devenv.sh
chown vagrant:vagrant /home/vagrant/update-devenv.sh
chmod +x /home/vagrant/update-devenv.sh
