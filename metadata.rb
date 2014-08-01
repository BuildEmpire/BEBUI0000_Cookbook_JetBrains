name             'cookbook_jetbrains'
maintainer       'Fred Thompson'
maintainer_email 'fred.thompson@buildempire.co.uk'
license          'Apache 2.0'
description      'TeamCity and YouTrack on one server.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.9'

recipe 'cookbook_jetbrains', 'TeamCity and YouTrack on one server.'

%w{ ubuntu }.each do |os|
  supports os
end

%w{build-essential appbox databox java}.each do |cb|
  depends cb
end