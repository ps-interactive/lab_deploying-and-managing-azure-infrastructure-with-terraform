sudo apt-get update -y
sudo apt-get install -y gnupg software-properties-common curl

curl -fsSL https://apt.releases.hashicorp.com/gpg | \
sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(. /etc/os-release && echo $VERSION_CODENAME) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update -y
sudo apt-get install terraform -y
