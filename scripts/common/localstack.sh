echo "Downloading Localstack and associated tooling"

pip3 install localstack
pip3 install terraform-local
pip3 install awscli-local
brew install leapp 
brew install Noovolari/brew/leapp-cli
brew install saml2aws 

curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /