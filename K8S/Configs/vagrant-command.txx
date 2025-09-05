vagrant global-status --prune

id       name         provider   state   directory
-----------------------------------------------------------------------------
ec29a05  k8s-master-1 virtualbox running D:/K8S/Configs
d1196d5  k8s-master-2 virtualbox running D:/K8S/Configs


vagrant ssh k8s-master-1
vagrant ssh k8s-master-2