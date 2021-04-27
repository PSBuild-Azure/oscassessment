#!/bin/bash
# ******************************************************
#
# (C) Rackspace 2020, fabian.salamanca@rackspace.com
#
# ******************************************************


output="rhosp-assessment.out"
echo > $output

function spacedel {
    echo >> $output
}

function outlabel {
    echo $1 >> $output
}


outlabel "# Red Hat Openstack Assessment" 
spacedel
outlabel "## Openstack projects/tenants"
outlabel "\`\`\`"
nice -n 19 openstack project list >> $output
sleep 2
outlabel "\`\`\`"
outlabel "\`\`\`"
nice -n 19 openstack usage list >> $output
sleep 2
outlabel "\`\`\`"

outlabel "## Cloud Instances" 
outlabel "\`\`\`"
nice -n 19 openstack server list --all-projects >> $output
sleep 2
outlabel "\`\`\`"

tenants=$(nice -n 19 openstack project list -f value | awk '/services/ {next} {print $2}')
outlabel "## Openstack Compute Flavors" 
outlabel "\`\`\`"
nice -n 19 openstack flavor list --all $i >> $output
sleep 2
outlabel "\`\`\`"

outlabel "## Cinder volumes"
outlabel "\`\`\`"
nice -n 19 openstack volume list --all-projects >> $output
sleep 2
outlabel "\`\`\`"

outlabel "## Redes (Neutron)"
outlabel "\`\`\`"
for i in $tenants
do
	outlabel "### Redes en proyecto: $i"
	nice -n 19 openstack network list --project $i >> $output
	sleep 2
done
outlabel "\`\`\`"

outlabel "\`\`\`"
spacedel
nice -n 19 openstack subnet list  >> $output
sleep 2
outlabel "\`\`\`"

outlabel "\`\`\`"
nice -n 19 openstack subnet pool list  >> $output
sleep 2
outlabel "\`\`\`"

outlabel "## Hosts"
outlabel "\`\`\`"
nice -n 19 openstack host list >> $output
sleep 2
nice -n 19 openstack hypervisor stats show >> $output
sleep 2
outlabel "\`\`\`"

outlabel "\`\`\`"
hosts=$(nice -n 19 openstack hypervisor list -f value | awk '{print $2}')
for i in $hosts
do
	nice -n 19 openstack hypervisor show $i -f json >> $output
	sleep 2
done
echo "" >> $output
outlabel "\`\`\`"
echo "" >> $output

vms=$(nice -n 19 openstack server list --all-projects -f value | awk '{print $2}')
sleep 2

outlabel "## Detalle de VMs"
outlabel "\`\`\`"
for i in $vms
do
	nice -n 19 openstack server show $i >> $output
	sleep 2
	nice -n 19 nova diagnostics $i >> $output
	sleep 2
done
outlabel "\`\`\`"
