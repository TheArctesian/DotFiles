# Install using sudo powershell 
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# for chocalty and restart 


cd /
cd /Users/steph/Desktop
# Utils
# choco install vscode
choco install git.install -y
choco install 7zip.install -y
choco install putty.install -y
choco install microsoft-windows-terminal -y
choco install postman -y

# RW
choco install brave -y
choco install libreoffice-fresh -y
choco install onenote -y
# Languages 
choco install rust -y
choco install python -y
choco install pip -y
choco install nodejs -y
npm i -g npm 
npn i -g yarn
choco install jre8 -y
choco install jdk8 -y
choco install golang -y

# Art / Fun
choco install blender -y
choco install spotify -y
choco install audacity -y
choco install youtube-dl -y


# Setup 
git clone https://github.com/TheArctesian/SchoolFiles.git

# wsl
wsl --install 



# When you relise that windows is a shit os and want to go back to linux here https://github.com/linux-surface/linux-surface/wiki/Installation-and-Setup
