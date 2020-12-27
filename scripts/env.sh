# Company
#MYIP=10.2.7.11
# Home
MYIP=192.168.3.4  

export HTTPS_PROXY=http://${MYIP}:10809
export HTTP_PROXY=http://${MYIP}:10809
export NO_PROXY=localhost,127.0.0.1

export GOOGLE_APPLICATION_CREDENTIALS=$PWD/terraform/terraform-sa-key.json