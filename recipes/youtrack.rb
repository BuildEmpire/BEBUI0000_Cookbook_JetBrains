#
# Cookbook Name:: cookbook_jetbrains
# Recipe:: youtrack
#

# Decipher the locations
youtrack_war_name = "youtrack-#{node["cookbook_jetbrains"]["youtrack"]["version"]}.war"
server_directory = "/opt/teamcity/#{node["cookbook_jetbrains"]["teamcity"]["version"]}"
webapps_directory = "#{server_directory}/TeamCity/webapps"
youtrack_directory = "#{webapps_directory}/youtrack"
youtrack_war_path = "#{youtrack_directory}/ROOT.war"

# Create the youtrack directory
directory youtrack_directory do
  owner "root"
  group "root"
  mode 0755
  action :create
end

# Download youtrack into place
remote_file youtrack_war_path do
  backup false
  source "http://download.jetbrains.com/charisma/#{youtrack_war_name}"
  action :create_if_missing
end