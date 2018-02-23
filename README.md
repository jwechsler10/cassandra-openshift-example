# cassandra-openshift-configuration
yml files for running cassandra on openshift

Make sure CASSANDRA_SEEDS environmenet variable is set to cassandra-0.{hostname from cassandra service}.svc.cluster.local.

Make sure to apply to all app nodes for SELinux  "chcon -Rt svirt_sandbox_file_t /tmp/nfs                                                                                                             -provisioner"
