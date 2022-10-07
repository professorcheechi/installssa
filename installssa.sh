#!/usr/bin/zsh

# references
# https://gist.github.com/mrpeardotnet/a9ce41da99936c0175600f484fa20d03
# https://askubuntu.com/questions/1295102/how-do-i-add-repo-gpg-keys-as-apt-key-is-deprecated
# https://askubuntu.com/questions/1286545/what-commands-exactly-should-replace-the-deprecated-apt-key

url=http://downloads.linux.hpe.com/SDR/



for key in hpPublicKey1024.pub hpPublicKey2048.pub hpPublicKey2048_key1.pub hpePublicKey2048_key1.pub ; do

  wget -q -O - "$url$key" |
#  wget "$url$key" |
    sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/hp-mcp.gpg --import -

done

sudo chmod 644 /etc/apt/trusted.gpg.d/hp-mcp.gpg

if [ ! -f /etc/apt/sources.list.d/hp-mcp.list ]; then

addrepo=$(sudo echo "deb [ signed-by=/etc/apt/trusted.gpg.d/hp-mcp.gpg ] http://downloads.linux.hpe.com/SDR/repo/mcp stretch/>

  if [ $(echo "$addrepo" | grep -i denied) ]; then
    sudo touch /etc/apt/sources.list.d/hp-mcp.list
    printf "\nPlease do: \n sudo nano /etc/apt/sources.list.d/hp-mcp.list and paste the line \n"
    printf " >> deb [signed by=/etc/apt/trusted.gpg.d/hp-mcp.gpg ] http://downloads.linux.hpe.com/SDR/repo/mcp stretch/curren>
    printf "(must be all on one line, without the >> << of course) \n "
    printf "as the script has not been successful it must be done manually \n\n"
  fi

fi

sudo apt update
sudo apt install ssacli -y
