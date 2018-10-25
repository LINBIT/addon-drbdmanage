#!/bin/bash

###
# cleanup environment
###

unset _eXtract_DS_CONF
unset _eXtract_VM_CONF

DRIVER_PATH=$(dirname "$0")
XPATH="${DRIVER_PATH}/../../datastore/xpath.rb --stdin"

###
# caching helper
#################

###
# _eXtract_from [ds|vm] id
#
# get XML config of datastore or vm once
###

function _eXtract_from () {

  local _eXtract_XML=${1^^}
  local _eXtract_ID=$2
  local _cmd=" show -x"
  declare -n _eXtract_VAR=_eXtract_${_eXtract_XML}_CONF

  case $_eXtract_XML in
    VM)
      _cmd=onevm$_cmd
      ;;
    DS)
      _cmd=onedatastore$_cmd
      ;;
  esac

  if [ -z ${_eXtract_VAR+x} ]; then
    _eXtract_VAR=$($_cmd $_eXtract_ID 2>/dev/null)
  fi

  echo $_eXtract_VAR
}

###
# DISK
#######

###
# eXtract_disk_count vmid
#
# return (echo) number of attached disks
###

function eXtract_disk_count () {

  local _eXtract_VM=$1
  local _eXtract_count=$(_eXtract_from vm $_eXtract_VM | $XPATH "count(//VM/TEMPLATE/DISK)")

  echo $_eXtract_count
}

###
# eXtract_disk_number vmid diskid
#
# return (echo) number (place) of disk in XML
###

function eXtract_disk_number () {

  local _eXtract_VM=$1
  local _eXtract_DISKID=$2
  local _eXtract_disk_N=$(_eXtract_from vm $_eXtract_VM | $XPATH "count(//VM/TEMPLATE/DISK[DISK_ID=$_eXtract_DISKID]/preceding-sibling::DISK)")

  echo $((++_eXtract_disk_N))
}

###
# eXtract_disk_source vmid disk_by_number
# 
# return (echo) source of disk by XML order
###

function eXtract_disk_source () {

  local _eXtract_VM=$1
  local _eXtract_DISKN=$2
  local _eXtract_SOURCE=$(_eXtract_from vm $_eXtract_VM | $XPATH "/VM/TEMPLATE/DISK[$_eXtract_DISKN]/SOURCE")

  echo $_eXtract_SOURCE
}


###
# eXtract_disk_param vmid disk_id param_name
#
# return (echo) param value of disk by XML order
###

function eXtract_disk_param () {

  local _eXtract_VM=$1
  local _eXtract_DISKID=$2
  local _eXtract_PARAMNAME=$3
  local _eXtract_PARAM_VALUE=$(_eXtract_from vm $_eXtract_VM | $XPATH "/VM/TEMPLATE/DISK[DISK_ID=$_eXtract_DISKID]/$_eXtract_PARAMNAME")

  echo $_eXtract_PARAM_VALUE
}

###
# eXtract_disk_id_from_path path
#
# return (echo) disk or empty string
###

function eXtract_disk_id_from_path () {

  local _eXtract_PATH=$1
  local _eXtract_REGEXP="\.([0-9]+)$"

  if [[ $_eXtract_PATH =~ $_eXtract_REGEXP ]]
  then
    echo "${BASH_REMATCH[1]}"
  else
    echo ""
  fi
}

###
# eXtract_disk_ids vmid
#
# return (echo) list of disks
###

function  eXtract_disk_ids () {
  local _eXtract_VM=$1
  local _eXtract_DISK_IDS=$(_eXtract_from vm $_eXtract_VM | $XPATH "%m%/VM/TEMPLATE/DISK/DISK_ID")

  echo $_eXtract_DISK_IDS
}

###
# DATASTORE
############

###
# eXtract_datastore_param dsid param_name
#
# return (echo) param value of datastore
###

function eXtract_datastore_param ()  {

  local _eXtract_DS=$1
  local _eXtract_PARAMNAME=$2
  local _eXtract_PARAM_VALUE=$(_eXtract_from ds $_eXtract_DS | $XPATH "/DATASTORE/$_eXtract_PARAMNAME")

  echo $_eXtract_PARAM_VALUE
}

###
# eXtract_datastore_type dsid
#
# return (echo) type of datastore
###

function eXtract_datastore_type ()  {

  local _eXtract_DS=$1
  local _eXtract_TYPE=$(_eXtract_from ds $_eXtract_DS | $XPATH "/DATASTORE/TYPE")

  echo $_eXtract_TYPE
}

###
# eXtract_datastore_path dsid
#
# return (echo) basepath of datastore
###

function eXtract_datastore_path () {

  local _eXtract_DS=$1
  local _eXtract_PATH=$(_eXtract_from ds $_eXtract_DS | $XPATH "/DATASTORE/BASE_PATH")

  echo $_eXtract_PATH
}

###
# eXtract_datastore_redundancy dsid
#
# return (echo) redundancy of datastore
###

function eXtract_datastore_redundancy () {

  local _eXtract_DS=$1
  local _eXtract_REDUNDANCY=$(_eXtract_from ds $_eXtract_DS | $XPATH "/DATASTORE/BASE_PATH")

  echo $_eXtract_REDUNDANCY
}

###
# eXtract_datastore_deployment_site dsid
# 
# return (echo) locality of datastore (site)
###

function eXtract_datastore_deployment_site () {

  local _eXtract_DS=$1
  local _eXtract_SITE=$(_eXtract_from ds $_eXtract_DS | $XPATH "/DATASTORE/TEMPLATE/DRBD_DEPLOYMENT_SITE")

  echo $_eXtract_SITE
}

###
# eXtract_datastore_deployment_nodes dsid
#
# return (echo) locality of datastore (nodes)
###

function eXtract_datastore_deployment_nodes () {

  local _eXtract_DS=$1
  local _eXtract_NODES=$(_eXtract_from ds $_eXtract_DS | $XPATH "/DATASTORE/TEMPLATE/DRBD_DEPLOYMENT_NODES")

  echo $_eXtract_NODES
}

