#
# Cookbook Name:: cookbook_jetbrains
# Recipe:: teamcity
#

archive_directory = Chef::Config[:file_cache_path]

# Install TeamCity Server
server_archive_name = "TeamCity-#{node["cookbook_jetbrains"]["teamcity"]["version"]}.tar.gz"
server_archive_path = "#{archive_directory}/#{server_archive_name}"
server_directory = "/opt/teamcity/#{node["cookbook_jetbrains"]["teamcity"]["version"]}"
webapps_directory = "#{server_directory}/TeamCity/webapps"
teamcity_directory = "#{webapps_directory}/teamcity"
remote_file server_archive_path do
  backup false
  source "http://download.jetbrains.com/teamcity/#{server_archive_name}"
  action :create_if_missing
  notifies :run, "bash[install-teamcity]", :immediately
end
bash "install-teamcity" do
  code <<-EOH
    mkdir -p #{server_directory}
    cd #{server_directory}
    tar -xvf #{server_archive_path}
    mkdir -p #{teamcity_directory}
    mv #{webapps_directory}/ROOT #{teamcity_directory}/ROOT
  EOH
  action :nothing
end

# Link to the current teamcity installation
link "/opt/teamcity/current" do
  to server_directory
end

# Download the postgres java driver
data_directory = "/root/.BuildServer"
jdbc_driver_filename = "postgresql-#{node["cookbook_jetbrains"]["teamcity"]["postgresql-driver-version"]}.jdbc4.jar"
jdbc_driver_directory = "#{data_directory}/lib/jdbc"
directory jdbc_driver_directory do
  recursive true
  action :create
end
remote_file "#{jdbc_driver_directory}/#{jdbc_driver_filename}" do
  backup false
  mode 00644
  source "http://jdbc.postgresql.org/download/#{jdbc_driver_filename}"
  action :create_if_missing
end

# Setup the database properties file for TeamCity
data_config_directory = "#{data_directory}/config"
directory data_config_directory do
  recursive true
  action :create
end
template "#{data_config_directory}/database.properties" do
  source "database.properties.erb"
  action :create_if_missing
  variables(
    :port => node["postgresql"]["config"]["port"],
    :database_name => node["cookbook_jetbrains"]["teamcity"]["database_name"],
    :user => node["cookbook_jetbrains"]["teamcity"]["username"],
    :password => node["cookbook_jetbrains"]["teamcity"]["password"]
  )
end

