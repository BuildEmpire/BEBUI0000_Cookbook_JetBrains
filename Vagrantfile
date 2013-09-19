# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'berkshelf/vagrant'

Vagrant.configure("2") do |global_config|
  global_config.berkshelf.enabled = true
  global_config.vm.box = "precise64"
  global_config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  global_config.vm.network :forwarded_port, guest: 8111, host: 8111
  global_config.vm.provision :shell, :path => "configure.sh"
  global_config.vm.provision :chef_solo do |chef|
	chef.json = {
		"run_list" => ["cookbook_jetbrains"],
		"appbox" => {
			"deploy_keys"=> ["ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAv91lIF2IuMmslGLltkI5VKVSgEP522ByyQfnydvQ+figGY0nl0NpN7Vb/4aowydU/p29/0U7seJS8PP3FAPhOgTsusTd+8XBPnBRbGck45+89xNXbEVtP2+2T6LVP9LU2F8aYT8BlFFbdUykgc7TiLt8aiD1dgSFTg5hOwsc56lAkL3g4LQ7v5A2aa7mRNml2U5X7NAcZO4ues9jLzsT6k1mZdsgxDHTBmh4XBf+oNXvNWgDEzxB46WxN+AJj2EkE6k9Us2uEcAklGDMZS+rapCVuecGBFdbGIIs+stWJJZ5JGBiRkD2GtY81A18XZbMpS5+HYB+0/rXudxq26Z6nQ== ToMo@User-PC"],
			"admin_keys"=> ["ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAv91lIF2IuMmslGLltkI5VKVSgEP522ByyQfnydvQ+figGY0nl0NpN7Vb/4aowydU/p29/0U7seJS8PP3FAPhOgTsusTd+8XBPnBRbGck45+89xNXbEVtP2+2T6LVP9LU2F8aYT8BlFFbdUykgc7TiLt8aiD1dgSFTg5hOwsc56lAkL3g4LQ7v5A2aa7mRNml2U5X7NAcZO4ues9jLzsT6k1mZdsgxDHTBmh4XBf+oNXvNWgDEzxB46WxN+AJj2EkE6k9Us2uEcAklGDMZS+rapCVuecGBFdbGIIs+stWJJZ5JGBiRkD2GtY81A18XZbMpS5+HYB+0/rXudxq26Z6nQ== ToMo@User-PC"]
		},
    "cookbook_jetbrains" => {
      "teamcity" => {
        "database_name" => "app1_production",
        "username" => "app1",
        "password" => "app1_pass"
      }
    },
    "databox" => {
      "db_root_password" => "testpass",
      "databases" => {
        "postgresql" => [
          {
            "database_name" => "app1_production",
            "username" => "app1",
            "password" => "app1_pass"
          }
        ]
      }
    }
	}
  end
end




