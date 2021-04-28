# Assessment Script

## Usage:

### For Openstack

Login to Openstack, for example reading the correct RC file for admin project.

```
$ source admin-rc.sh 
```

Then execute the Openstack assessment script (the script includes read only commands):
```
time  ./osp-sizing.sh
```


### For Openshift

Login to Openshift/Origin:

```
oc login
```

Cluster admin access required, read only commands, this script will not perform any modifications.


Execute the Openshift assessment:
```
time ./ocp-assessment.sh
```

Then perform an Openshift cluster-dump:
```
oc cluster-info dump > cluster.dump
```

## Results

Three report files will be created:
* output="openstack-assessment.md"
* output="rs-ocp-assessment.md"
* y la salida de cluster-info: cluster.dump

