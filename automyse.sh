mkdir /data/qh
mkdir /data/qh/uploads
cd /var/automyse/portal/queryhub
bash ./activator -mem 30g "run -Dhttp.address=0.0.0.0 -Dhttp.port=80"
  
