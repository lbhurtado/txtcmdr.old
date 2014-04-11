txtcmdr
=======

Text Commander

sudo apt-get update

sudo apt-get install ruby1.9.1-dev -y

sudo apt-get install build-essential -y

sudo apt-get install git -y

sudo gem install puppet --no-rdoc --no-ri

sudo gem install puppet-module --no-rdoc --no-ri

sudo gem install librarian-puppet --no-rdoc --no-ri

git clone https://github.com/lbhurtado/txtcmdr.git puppet

cd puppet

sudo librarian-puppet install --verbose

sudo puppet apply manifests/site.pp --modulepath=modules/ --verbose
