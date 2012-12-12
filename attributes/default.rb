default[:proftpd][:version] = "1.3.4b"

set[:proftpd][:dir]     = "/etc/proftpd"
set[:proftpd][:binary]  = "/usr/sbin/proftpd"
set[:proftpd][:log_dir] = "/var/log/proftpd"

default[:proftpd][:user] = "proftpd"
default[:proftpd][:ftp_user] = "ftp"

default[:proftpd][:port]                 = 21
default[:proftpd][:default_address]      = ipaddress
default[:proftpd][:max_instances]        = 30
default[:proftpd][:umask]                = "022"