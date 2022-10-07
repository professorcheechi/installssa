#!/usr/bin/zsh

# references
# https://gist.github.com/mrpeardotnet/a9ce41da99936c0175600f484fa20d03
# https://askubuntu.com/questions/1295102/how-do-i-add-repo-gpg-keys-as-apt-key-is-deprecated
# https://askubuntu.com/questions/1286545/what-commands-exactly-should-replace-the-deprecated-apt-key

usage()
{
  printf "This script will pull the pub keys from HP, create a keyring & trusted repo, and install ssacli \n"
  printf "for managing HP Smart Array storage controllers. It is intended to be run with sudo or as root. \n\n"
}


sudo_check(){
  if [ "$(id -u)" -ne 0 ]; then
    printf "\n\t$0 must be run as root or sudo\n\n"
    usage && exit 3
  else
    sudook=1
  fi
}

getkeys()
{
  url=http://downloads.linux.hpe.com/SDR/

  for key in hpPublicKey1024.pub hpPublicKey2048.pub hpPublicKey2048_key1.pub hpePublicKey2048_key1.pub ; do
    wget -q -O - "$url$key" |
    sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/hp-mcp.gpg --import -
  done

  sudo chmod 644 /etc/apt/trusted.gpg.d/hp-mcp.gpg
}

sourcelist()   
{
  #some systems sudo cannot write the file automated
  #if we get permission denied have to write it with nano
  if [ ! -f /etc/apt/sources.list.d/hp-mcp.list ]; then

  addrepo=$(sudo echo "deb [ signed-by=/etc/apt/trusted.gpg.d/hp-mcp.gpg ] http://downloads.linux.hpe.com/SDR/repo/mcp stretch/current non-free" > /etc/apt/sources.list.d/hp-mcp.list)

    if [ $(echo "$addrepo" | grep -i denied) ]; then
      sudo touch /etc/apt/sources.list.d/hp-mcp.list
      printf "\nPlease do: \n sudo nano /etc/apt/sources.list.d/hp-mcp.list and paste the line \n"
      printf " >> deb [signed by=/etc/apt/trusted.gpg.d/hp-mcp.gpg ] http://downloads.linux.hpe.com/SDR/repo/mcp stretch/current non-free << \n\n"
      printf "(must be all on one line, without the >> << of course) \n "
      printf "as the script has not been successful it must be done manually \n\n"
      printf "Afterward you should be ready to sudo apt update && sudo apt install ssacli -y \n\n" && exit 2
    fi

  fi
}

update()
{
  sudo apt update
  sudo apt install ssacli -y
}
####### Main #########
sudocheck

getkeys 
sourcelist $@
update 


