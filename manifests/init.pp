# = Class: shopware
# 
# This class installs all required packages and services in order to run Shopware. 
# It'll do a checkout of the Shopware repository as well. You only have to setup
# Apache and/or NGINX afterwards.
# 
# == Parameters: 
#
# $directory::         The Shopware repository will be checked out into this directory.
# $repository::        Whether to checkout the SVN or Git reporitory. Defaults to svn. 
#                      Valid values: 'svn' and 'git'. 
# $version::           The Shopware version. Defaults to 'trunk'. 
#                      Valid values: For example 'tags/1.8.3' or 'branch/whatever'. 
# $db_user::           If defined, it creates a MySQL user with this username.
# $db_password::       The MySQL user's password.
# $db_root_password::  A password for the MySQL root user.
# $log_analytics::     Whether log analytics will be used. Defaults to true. 
#                      Valid values: true or false
# $svn_username::      Your svn username. Defaults to false.
# $svn_password::      Your svn password. Defaults to false.
# 
# == Requires: 
# 
# See README
# 
# == Sample Usage:
#
#  class {'shopware': }
#
#  class {'shopware':
#    db_root_password => '123456',
#    repository => 'git',
#  }
#
class shopware(
  $directory   = $shopware::params::apachedocroot,
  $repository  = $shopware::params::repository,
  $version     = $shopware::params::shopware_version,
  $db_user     = $shopware::params::db_user,
  $db_password = $shopware::params::db_password,
  $db_root_password = $shopware::params::db_password,
  $svn_username     = false,
  $svn_password     = false
) inherits shopware::params {

  include shopware::base

  # mysql / db
  class { 'shopware::db':
    username      => $db_user,
    password      => $db_password,
    root_password => $db_root_password,
    require       => Class['shopware::base'],
  }

  class { 'shopware::php':
     require => Class['shopware::db'],
  }

  class { 'shopware::user': }

  # repo checkout
  shopware::repo { 'shopware_repo_setup':
    directory    => $directory,
    version      => $version,
    repository   => $repository,
    svn_username => $svn_username,
    svn_password => $svn_password,
    require      => Class['shopware::base'],
  }

}

