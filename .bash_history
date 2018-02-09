systemctl status docker
cd /usr/local/bin
ls
cat open-init.sh 
cd /etc/pki/
ls
cd product
ls
ls ../product-default/
diff 69.pem ../product-default/69.pem 
ls
pwd
ps -ef
tail /var/log/yum.log
file /var/tmp/rpm-tmp.J8rUDI 
tail /var/tmp/rpm-tmp.J8rUDI 
cd /var/log
ls -altr
tail messages
date
tail -f /var/log/messages
ssh master1.example.com
ssh node1.example.com
ssh infranode.example.com
ssh infranode1.example.com
ssh node3.example.com
ssh node2.example.com
ssh idm.example.com
poweroff
vi /etc/ssh/sshd_config 
yum -y install ipa-client
cat /etc/yum.repos.d/redhat.repo 
cat /etc/yum.repos.d/open.repo 
systemctl restart sshd
cat /etc/yum.repos.d/open.repo 
mv /etc/yum.repos.d/open.repo /etc/yum.repos.d/open.disabled
rpm -Uvh http://labsat.opentlc.com/pub/katello-ca-consumer-latest.noarch.rpm
subscription-manager register --org="Red_Hat_GPTE_Labs" --activationkey="ocp-setup"
yum repolist
 subscription-manager repos   --enable rhel-7-server-rpms   --enable rhel-7-server-rh-common-rpms   --enable rhel-7-server-extras-rpms   --enable rhel-7-server-optional-rpms   --enable rhel-7-server-ose-3.5-rpms
yum update
subscription-manager status
cp /etc/pki/product/69.pem /etc/pki/product/69.old
cat /etc/pki/product-default/69.pem > /etc/pki/product/69.pem 
subscription-manager status
subscription-manager refresh
subscription-manager status
subscription-manager unregister
subscription-manager clean
subscription-manager register --org="Red_Hat_GPTE_Labs" --activationkey="ocp-setup"
subscription-manager status
diff /etc/pki/product*/69.pem
subscription-manager unregister
subscription-manager clean
rpm -e katello-ca-consumer-latest
rpm -qa |grep katell
rpm -e katello-ca-consumer-labsat.opentlc.com-1.0-4.noarch
vi /etc/ssh/sshd_config 
vi /etc/cloud/cloud.cfg
tmux
tmux attach -t 0
ls
ssh master1.example.com 
ssh-keygen -f /root/.ssh/id_rsa -N ''
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
echo StrictHostKeyChecking no >> /etc/ssh/ssh_config
ssh master1.example.com "echo StrictHostKeyChecking no >> /etc/ssh/ssh_config"
for node in   master1.example.com                                     infranode1.example.com                                     node1.example.com                                     node2.example.com;                                     do                                     ssh-copy-id root@$node ;                                     done
export OWN_REPO_PATH=http://admin.na.shared.opentlc.com/repos/ocp/3.6
cat << EOF > /etc/yum.repos.d/open.repo
[rhel-7-server-rpms]
name=Red Hat Enterprise Linux 7
baseurl=${OWN_REPO_PATH}/rhel-7-server-rpms
enabled=1
gpgcheck=0

[rhel-7-server-rh-common-rpms]
name=Red Hat Enterprise Linux 7 Common
baseurl=${OWN_REPO_PATH}/rhel-7-server-rh-common-rpms
enabled=1
gpgcheck=0

[rhel-7-server-extras-rpms]
name=Red Hat Enterprise Linux 7 Extras
baseurl=${OWN_REPO_PATH}/rhel-7-server-extras-rpms
enabled=1
gpgcheck=0

[rhel-7-server-optional-rpms]
name=Red Hat Enterprise Linux 7 Optional
baseurl=${OWN_REPO_PATH}/rhel-7-server-optional-rpms
enabled=1
gpgcheck=0

[rhel-7-fast-datapath-rpms]
name=Red Hat Enterprise Linux 7 Fast Datapath
baseurl=${OWN_REPO_PATH}/rhel-7-fast-datapath-rpms
enabled=1
gpgcheck=0
EOF

cat << EOF >> /etc/yum.repos.d/open.repo

[rhel-7-server-ose-3.6-rpms]
name=Red Hat Enterprise Linux 7 OSE 3.6
baseurl=${OWN_REPO_PATH}/rhel-7-server-ose-3.6-rpms
enabled=1
gpgcheck=0
EOF

mv /etc/yum.repos.d/redhat.{repo,disabled}
yum clean all ; yum repolist
for node in master1.example.com                                       infranode1.example.com                                       node1.example.com                                       node2.example.com; do                                   echo Copying open repos to $node;                                   scp /etc/yum.repos.d/open.repo ${node}:/etc/yum.repos.d/open.repo;                                   ssh ${node} 'mv /etc/yum.repos.d/redhat.{repo,disabled}';                                   ssh ${node} yum clean all;                                   ssh ${node} yum repolist;                       done
yum -y install bind bind-utils
echo GUID is $GUID and guid is $guid
host infranode1-$GUID.oslab.opentlc.com ipa.opentlc.com |grep infranode | awk '{print $4}'
HostIP=`host infranode1-$GUID.oslab.opentlc.com  ipa.opentlc.com |grep infranode | awk '{print $4}'`
domain="cloudapps-$GUID.oslab.opentlc.com"
echo $HostIP $domain
mkdir /var/named/zones
echo "\$ORIGIN  .
\$TTL 1  ;  1 seconds (for testing only)
${domain} IN SOA master.${domain}.  root.${domain}.  (
  2011112904  ;  serial
  60  ;  refresh (1 minute)
  15  ;  retry (15 seconds)
  1800  ;  expire (30 minutes)
  10  ; minimum (10 seconds)
)
  NS master.${domain}.
\$ORIGIN ${domain}.
test A ${HostIP}
* A ${HostIP}"  >  /var/named/zones/${domain}.db
cat /var/named/zones/${domain}.db
echo "// named.conf
options {
  listen-on port 53 { any; };
  directory \"/var/named\";
  dump-file \"/var/named/data/cache_dump.db\";
  statistics-file \"/var/named/data/named_stats.txt\";
  memstatistics-file \"/var/named/data/named_mem_stats.txt\";
  allow-query { any; };
  recursion yes;
  /* Path to ISC DLV key */
  bindkeys-file \"/etc/named.iscdlv.key\";
  forwarders {
   192.168.0.1;
  };
  allow-recursion { 192.168.0.0/16; };
};
logging {
  channel default_debug {
    file \"data/named.run\";
    severity dynamic;
  };
};
zone \"${domain}\" IN {
  type master;
  file \"zones/${domain}.db\";
  allow-update { key ${domain} ; } ;
};" > /etc/named.conf
chgrp named -R /var/named ;  chown named -Rv /var/named/zones ;  restorecon -Rv /var/named ;  chown -v root:named /etc/named.conf ;  restorecon -v /etc/named.conf ;
systemctl enable named &&  systemctl start named
iptables -I INPUT 1 -p tcp --dport 53 -s 0.0.0.0/0 -j ACCEPT ; iptables -I INPUT 1 -p udp --dport 53 -s 0.0.0.0/0 -j ACCEPT ; iptables-save > /etc/sysconfig/iptables
systemctl status firewalld
yum -y install firewalld
systemctl enable firewalld
systemctl start firewalld
systemctl status iptables
host test.cloudapps-$GUID.oslab.opentlc.com 127.0.0.1
host test.cloudapps-$GUID.oslab.opentlc.com 8.8.8.8
firewall-cmd --list-all
firewall-cmd --list-services 
firewall-cmd --get-services
firewall-cmd --add-service=dns
firewall-cmd --add-service=dns --permanent 
firewall-cmd --reload
host test.cloudapps-$GUID.oslab.opentlc.com 8.8.8.8
firewall-cmd --list-all
yum -y install ansible
cat << EOF > /etc/ansible/hosts
[masters]
master1.example.com

[nodes]
master1.example.com
infranode1.example.com
node1.example.com
node2.example.com
EOF

cat /etc/ansible/hosts
ansible nodes -m ping
ansible nodes -a "yum -y install NetworkManager"
yum -y install wget git net-tools bind-utils iptables-services bridge-utils
ansible all -a "yum -y update"
ansible nodes -m yum -a "name=docker"
ansible nodes -m shell -a "systemctl stop docker ; rm -rf /var/lib/docker/*"
cat <<EOF > /etc/sysconfig/docker-storage-setup
DEVS=/dev/vdb
VG=docker-vg
EOF

 docker-storage-setup
ansible nodes -a "yum install -y firewalld"
ansibles nodes -a "systemctl disable iptables"
ansible nodes -a "systemctl disable iptables"
ansible nodes -a "systemctl enable firewalld"
ansible nodes -a "systemctl start firewalld"
ansible nodes -a "firewall-cmd --add-service=dns --permanent"
ansible nodes -a "firewall-cmd --reload"
ansible nodes -m copy -a 'dest=/etc/sysconfig/docker-storage-setup content="DEVS=/dev/vdb\nVG=docker-vg"' ; ansible nodes -m shell -a "docker-storage-setup; systemctl enable docker; systemctl start docker"
ansible nodes -m shell -a "systemctl status docker | grep Active"
REGISTRY="registry.access.redhat.com";PTH="openshift3"
OSE_VERSION=$(yum info atomic-openshift | grep Version | awk '{print $3}')
REGISTRY="registry.access.redhat.com";PTH="openshift3"; OSE_VERSION=$(yum info atomic-openshift | grep Version | awk '{print $3}'); ansible 'nodes:!masters:!infranode1.example.com' -m shell -a " docker pull $REGISTRY/$PTH/ose-deployer:v$OSE_VERSION ; docker pull $REGISTRY/$PTH/ose-sti-builder:v$OSE_VERSION ; docker pull $REGISTRY/$PTH/ose-pod:v$OSE_VERSION ; docker pull $REGISTRY/$PTH/ose-keepalived-ipfailover:v$OSE_VERSION ; docker pull $REGISTRY/$PTH/ruby-20-rhel7 ; docker pull $REGISTRY/$PTH/mysql-55-rhel7 ; docker pull openshift/hello-openshift:v1.2.1 ;
"
yum -y install atomic-openshift-utils
export OSE_VERSION=3.6
cat << EOF > /etc/ansible/hosts
[OSEv3:children]
masters
nodes
nfs

[OSEv3:vars]
ansible_user=root

openshift_disable_check=memory_availability,disk_availability

openshift_clock_enabled=true

deployment_type=openshift-enterprise
openshift_release=v$OSE_VERSION

openshift_master_cluster_method=native
openshift_master_cluster_hostname=master1.example.com
openshift_master_cluster_public_hostname=master1-${GUID}.oslab.opentlc.com

os_sdn_network_plugin_name='redhat/openshift-ovs-multitenant'

openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}]

osm_default_node_selector='region=primary'
openshift_hosted_router_selector='region=infra'
openshift_hosted_router_replicas=1
openshift_hosted_registry_selector='region=infra'
openshift_hosted_registry_replicas=1

openshift_master_default_subdomain=cloudapps-${GUID}.oslab.opentlc.com


openshift_hosted_registry_storage_kind=nfs
openshift_hosted_registry_storage_access_modes=['ReadWriteMany']
openshift_hosted_registry_storage_host=bastion.example.com
openshift_hosted_registry_storage_nfs_directory=/exports
openshift_hosted_registry_storage_volume_name=registry
openshift_hosted_registry_storage_volume_size=5Gi

[nfs]
bastion.example.com

[masters]
master1.example.com openshift_hostname=master1.example.com openshift_public_hostname=master1-${GUID}.oslab.opentlc.com

[nodes]
master1.example.com openshift_hostname=master1.example.com openshift_public_hostname=master1-${GUID}.oslab.opentlc.com openshift_node_labels="{'region': 'infra'}"
infranode1.example.com openshift_hostname=infranode1.example.com openshift_public_hostname=infranode1-${GUID}.oslab.opentlc.com openshift_node_labels="{'region': 'infra', 'zone': 'infranodes'}"
node1.example.com openshift_hostname=node1.example.com openshift_public_hostname=node1-${GUID}.oslab.opentlc.com openshift_node_labels="{'region': 'primary', 'zone': 'east'}"
node2.example.com openshift_hostname=node2.example.com openshift_public_hostname=node2-${GUID}.oslab.opentlc.com openshift_node_labels="{'region': 'primary', 'zone': 'west'}"
EOF

vim /etc/ansible/hosts 
ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml
ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/openshift-cluster/openshift-logging.yml 
ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/openshift-cluster/openshift-metrics.yml 
ssh master1.example.com 
hostname
hostname -s
systemctl status nfs
firwall-cmd --list-services
firewall-cmd --list-services
firewall-cmd --add-service=nfs
firewall-cmd --add-service=nfs --permanent
firewall-cmd --add-service=nfs --reload
firewall-cmd  --reload
vim /etc/exports
ssh master1.example.com 
REGISTRY="registry.access.redhat.com"; OSE_VERSION=$(yum info atomic-openshift | grep Version | awk '{print $3}'); PTH="openshift3"; ansible infranode1.example.com -m shell -a " docker pull $REGISTRY/$PTH/ose-haproxy-router:v$OSE_VERSION ; docker pull $REGISTRY/$PTH/ose-deployer:v$OSE_VERSION ; docker pull $REGISTRY/$PTH/ose-pod:v$OSE_VERSION ; docker pull $REGISTRY/$PTH/ose-docker-registry:v$OSE_VERSION ;"
ssh master1.example.com firewall-cmd --list-all
ssh node1.example.com firewall-cmd --list-all
ssh master1.example.com 
mkdir -p /var/export/pvs
for i in {1..5}; do   mkdir -p /var/export/pvs/pv$i; done
ls /var/export/pvs/
vim /etc/exports
exportfs -r
showmount -e
systemctl status nfs
chown -R  nfsnobdy:nfsnobody /var/export/pvs
chown -R  nfsnobody:nfsnobody /var/export/pvs
ls -l /var/export/pvs
chmod 770 -R /var/export/pvs
ls -l /var/export/pvs/
tail /etc/passwd
whois
whoami
user
man user
man passwd
man useradd
chmod 777 -R /var/export/pvs
ssh master1.example.com 
tmux attach -t 0
tmux
tmux attach -t 90
tmux attach -t 0
ssh master1.example.com 
