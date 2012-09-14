# = Definition: shopware::repo
#
# This definition clones a specific version from a Shopware
# repository into the specified directory.
#
# == Parameters: 
#
# $directory::     The Shopware repository will be checked out/cloned into this 
#                  directory.
# $version::       The Shopware version. Defaults to 'trunk'. 
#                  Valid values: For example 'HEAD', 'tags/1.8.3' or 'branch/whatever'.
# $repository::    Whether to checkout the SVN or Git reporitory. Defaults to svn. 
#                  Valid values: 'svn' and 'git'.  
# $svn_username::  Your svn username. Defaults to false.
# $svn_password::  Your svn password. Defaults to false.
#
# == Actions:
#
# == Requires: 
#
# == Sample Usage:
#
#  shopware::repo { 'shopware_repo_simple': }
#
#  shopware::repo { 'shopware_repo_full':
#    directory    => '/var/www/',
#    version      => 'trunk',
#    repository   => 'svn',
#    svn_username => 'svn username',
#    svn_password => 'svn password'
#  }
#
define shopware::repo(
  $directory    = $shopware::params::docroot,
  $version      = $shopware::params::shopware_version,
  $repository   = $shopware::params::repository,
  $svn_username = false,
  $svn_password = false
) {

  if ! defined(File[$directory]) {
    file { "${directory}": }
  }

  if $repository == 'svn' {
    vcsrepo { "${directory}":
      ensure   => present,
      provider => svn,
      source   => "${shopware::params::svn_repository}/${version}",
      owner    => $shopware::params::user,
      group    => $shopware::params::group,
      require  => [ User["${shopware::params::user}"], Package['subversion'] ],
      basic_auth_username => $svn_username,
      basic_auth_password => $svn_password,
    }
  }

  if $repository == 'git' {
    vcsrepo { "${directory}":
      ensure   => present,
      provider => git,
      source   => $shopware::params::git_repository,
      revision => $version,
      owner    => $shopware::params::user,
      group    => $shopware::params::group,
      require  => [ User["${shopware::params::user}"], Class['git'] ],
    }
  }

  file { "${directory}/config":
    ensure    => directory,
    mode      => '0777',
    subscribe => Vcsrepo["${directory}"],
  }

  file { "${directory}/tmp":
    ensure    => directory,
    mode      => '0777',
    subscribe => Vcsrepo["${directory}"],
  }

}
