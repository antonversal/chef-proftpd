default[:proftpd][:version] = "1.3.4b"

set[:proftpd][:dir]     = "/etc/proftpd"
set[:proftpd][:binary]  = "/usr/sbin/proftpd"
set[:proftpd][:log_dir] = "/var/log/proftpd"

set[:proftpd][:user] = "proftpd"
set[:proftpd][:ftp_user] = "ftp"
