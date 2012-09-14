# = Class: shopware::params
# 
# This class manages Shopware parameters
# 
# == Parameters: 
# 
# == Requires: 
# 
# == Sample Usage:
#
# This class file is not called directly
#
class shopware::params {
  $user    = 'www-data'
  $group   = 'www-data'
  $docroot = '/var/www/shopware'
  $apachedocroot = '/var/www/shopware'

  $repository     = 'git'
  $git_repository = 'https://github.com/ShopwareAG/shopware-4.git'
  $shopware_version  = 'master'

  $db_user     = 'shopware'
  $db_password = 'shopware'
}
