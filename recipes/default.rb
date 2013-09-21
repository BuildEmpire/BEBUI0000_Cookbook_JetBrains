#
# Cookbook Name:: cookbook_jetbrains
# Recipe:: default
#

include_recipe "appbox"
include_recipe "databox::postgresql"

# Install Java
include_recipe "java"

include_recipe "cookbook_jetbrains::teamcity"
include_recipe "cookbook_jetbrains::youtrack"
include_recipe "cookbook_jetbrains::configure"