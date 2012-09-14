repo_url = node['ariadne']['repo_url']
repo = node['ariadne']['project']
site_url = "#{repo}.dev"
branch = node['ariadne']['branch']

web_app site_url do
  cookbook "ariadne"
  template "sites.conf.erb"
  server_name site_url
  server_aliases [ "*.#{site_url}" ]
  docroot "/mnt/www/html/#{repo}"
  port node['apache']['listen_ports'].to_a[0]
end

if node['ariadne']['clean']
  execute "chmod -R 777 /mnt/www/html/#{repo}"
  %W{
    /vagrant/data/profiles/#{repo}
    /mnt/www/html/#{repo}
  }.each do |dir|
    directory dir do
      recursive true
      action :delete
      only_if "test -d #{dir}"
    end
  end
end

git "/vagrant/data/profiles/#{repo}" do
  user "vagrant"
  repository repo_url
  reference branch
  enable_submodules true
  action :sync
end

bash "Building site..." do
  user "vagrant"
  group "vagrant"
  cwd "/vagrant/data/profiles/#{repo}"
  code <<-"EOH"
    tmp/scripts/rerun/rerun 2ndlevel:build \
      --build-file build-#{repo}.make \
      --destination /mnt/www/html/#{repo} \
      --revision #{branch} \
      --project #{repo}
  EOH
  not_if "test -d /mnt/www/html/#{repo}"
  environment({
    'HOME' => '/home/vagrant',
    'RERUN_MODULES' => "/vagrant/data/profiles/#{repo}/tmp/scripts/rerun-modules",
  })
  notifies :reload, "service[apache2]"
  notifies :restart, "service[varnish]"
end
