default[:proftpd][:version] = "1.3.4b"

set[:proftpd][:dir]     = "/etc/proftpd"
set[:proftpd][:log_dir] = "/var/log/proftpd"

default[:proftpd][:user] = "proftpd"

default[:proftpd][:port]                 = 21
default[:proftpd][:max_instances]        = 30
default[:proftpd][:umask]                = "022"