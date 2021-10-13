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

function desnodes {
    nodes=$(oc get nodes -o jsonpath="{.items[*].metadata.name}")
    spacedel
    outlabel "\`\`\`"
    for i in $nodes
    do
        echo >> $output
        echo "**Node ${i}**" >> $output
        echo >> $output
        oc describe node $i >> $output
    done        
    outlabel "\`\`\`"
}

function pvcs {
    namespaces=$(oc get ns -o jsonpath="{.items[*].metadata.name}")
    spacedel
    outlabel "\`\`\`"
    for i in $namespaces
    do
        echo "**Namespace ${i}**" >> $output
        oc get pvc -n $i >> $output
    done
    outlabel "\`\`\`"
}

function crashedpods {
	crashed=$(oc get pods -n $1 | egrep -i "(loop|error|pending|waiting)")
	spacedel
	outlabel "*Failed pods in namespace: $1*"
	spacedel
	outlabel "\`\`\`"
	for i in $crashed
	do
		echo "Pod $i"
		oc logs $i >> $output
	done		
	outlabel "\`\`\`"
}

echo "Starting..."

outlabel "# OPENSHIFT ASSESSMENT - RACKSPACE"
spacedel
outlabel "\`\`\` "
oc whoami -c >> $output
outlabel "\`\`\` "
spacedel
outlabel "## OCP get nodes"
spacedel
outlabel "### NODES"
spacedel
outlabel "\`\`\` "
oc get nodes -o wide >> $output
outlabel "\`\`\` "
spacedel

desnodes

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

outlabel "### Kubernetes Services"
spacedel
outlabel "\`\`\`"
oc get service -o wide --all-namespaces >> $output
outlabel "\`\`\`"
spacedel

outlabel "### Openshift Routes"
spacedel
outlabel "\`\`\`"
oc get routes -o wide --all-namespaces >> $output
outlabel "\`\`\`"
spacedel

outlabel "### Persistent Volumes"
spacedel
outlabel "\`\`\`"
oc get pv -o wide >> $output
outlabel "\`\`\`"
spacedel

outlabel "### Openshift ImageStreams"
spacedel
outlabel "\`\`\`"
oc get is --all-namespaces >> $output
outlabel "\`\`\`"
spacedel

outlabel "### Openshift Build Templates (S2I)"
spacedel
outlabel "\`\`\`"
oc new-app -L >> $output
outlabel "\`\`\`"
spacedel

outlabel "### Openshift BuildConfigs"
spacedel
outlabel "\`\`\`"
oc get bc --all-namespaces >> $output
outlabel "\`\`\`"
spacedel

outlabel "### Failed Pods per NS"
spacedel
projects=$(oc get ns -o jsonpath="{.items[*].metadata.name}")
for i in $projects
do
	crashedpods $i	
done
