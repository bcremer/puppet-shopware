# = Definition: shopware::apache
#
# This definition installs Apache2 including some modules like
# mod_rewrite and creates a virtual host.
#
# == Parameters: 
#
# $name::      The name of the host
# $port::      The port to configure the host
# $priority::  The priority of the site
# $docroot::   The location of the files for this host
#
# == Actions:
#
# == Requires: 
#
# The shopware class
#
# == Sample Usage:
#
#  shopware::apache { 'apache.shopware': }
#
#  shopware::apache { 'apache.shopware':
#    port     => 80,
#    priority => '10',
#    docroot  => '/var/www/shopware',
#  }
#
define shopware::apache (
  $port     = '80',
  $docroot  = $shopware::params::apachedocroot,
  $priority = '20'
) {  

  host { "${name}":
    ip => "127.0.0.1";
  } 

  include apache

  include apache::mod::php
  include apache::mod::auth_basic
  # TODO move this to a class and include it. This allows us to define multiple apache hosts
  apache::mod {'vhost_alias': }
  apache::mod { 'rewrite': }

  apache::vhost { "${name}":
    priority   => $priority,
    vhost_name => '_default_',
    port       => $port,
    docroot    => $docroot,
    override   => 'all',
    require    => [ Host[$name], Shopware::Repo['shopware_repo_setup'], Class['shopware::php'] ],
    configure_firewall => true,
  }

}
