# = Class: shopware::user
# 
# Makes sure the user exists which is used by Apache and NGINX.
# 
# == Parameters: 
# 
# == Requires: 
# 
# == Sample Usage:
#
#  include shopware::user
#
class shopware::user {
    
  # user for apache / nginx
  user { "${shopware::params::user}":
    ensure  => present,
    comment => $shopware::params::user,
    shell   => '/bin/false',
  }

}
