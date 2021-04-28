#!/bin/bash
# ******************************************************
#
# (C) Rackspace 2020, fabian.salamanca@rackspace.com   
#
# ******************************************************


output="rs-ocp-assessment.md"
echo > $output

function spacedel {
	echo >> $output
}

function outlabel {
	echo $1 >> $output
}

function crashedpods {
	crashed=$(oc get pods -n $1 | egrep -i "(loop|error|pending|waiting)")
	spacedel
	outlabel "*Pods con fallas on $1*"
	spacedel
	outlabel "\`\`\`"
	for i in $crashed
	do
		echo "Pod $i"
		oc logs $i >> $output
	done		
	outlabel "\`\`\`"
}

echo "Iniciando..."

outlabel "# OPENSHIFT ASSESSMENT - RACKSPACE"
spacedel
outlabel "\`\`\` "
oc whoami -c >> $output
outlabel "\`\`\` "
spacedel
outlabel "## OCP get nodes"
spacedel
outlabel "### NODOS"
spacedel
oc get nodes -o wide >> $output
spacedel

outlabel "### Kubernetes config view"
spacedel
outlabel "\`\`\`"
oc config view >> $output
outlabel "\`\`\`"
spacedel

outlabel "### Kubernetes get pods"
spacedel
outlabel "\`\`\`"
oc get pods -o wide --all-namespaces >> $output
outlabel "\`\`\`"
spacedel

outlabel "### Kubernetes get deployment configs"
spacedel
outlabel "\`\`\`"
oc get dc  --all-namespaces >> $output
outlabel "\`\`\`"
spacedel

outlabel "### Kubernetes services"
spacedel
outlabel "\`\`\`"
oc get service -o wide --all-namespaces >> $output
outlabel "\`\`\`"
spacedel

outlabel "### Openshift ImageStreams"
spacedel
outlabel "\`\`\`"
oc get is --all-namespaces >> $output
outlabel "\`\`\`"
spacedel

outlabel "### Openshift BuildConfigs"
spacedel
outlabel "\`\`\`"
oc get bc --all-namespaces >> $output
outlabel "\`\`\`"
spacedel

outlabel "### Buscando fallas en pods"
spacedel
projects=$(oc get namespaces | awk '/NAME/ {next;} {print $1}')
for i in $projects
do
	crashedpods $i	
done
