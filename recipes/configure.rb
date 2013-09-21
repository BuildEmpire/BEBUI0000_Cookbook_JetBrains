#
# Cookbook Name:: cookbook_jetbrains
# Recipe:: configure
#

# Configure TeamCity TomCat server
server_directory = "/opt/teamcity/#{node["cookbook_jetbrains"]["teamcity"]["version"]}"
config_directory = "#{server_directory}/TeamCity/conf"
template "#{config_directory}/server.xml" do
  source "server.xml.erb"
  variables(
    :teamcity_address => node["cookbook_jetbrains"]["teamcity"]["address"],
    :youtrack_address => node["cookbook_jetbrains"]["youtrack"]["address"]
  )
end

# Start TeamCity Service
service "teamcity-server" do
  provider Chef::Provider::Service::Upstart
  action :restart
end