def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    template 'sources.list.erb', '/tmp/sources.list'
    run "#{sudo} mv /tmp/sources.list /etc/apt/sources.list"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config libcurl3 libcurl3-gnutls libcurl4-openssl-dev unzip"

    # apt-add-repository script
    run "#{sudo} wget http://blog.anantshri.info/wp-content/uploads/2010/09/add-apt-repository.sh.txt"
    run "#{sudo} mv add-apt-repository.sh.txt /usr/sbin/add-apt-repository"
    run "#{sudo} chmod o+x /usr/sbin/add-apt-repository"
  end

  # /home/user/apps directory has wrong owner - root
  task :change_owner do
    run "#{sudo} chown -hR #{user} /home/#{user}/apps"
  end
  before 'deploy:cold', 'deploy:change_owner'
end

# создан пользователь
# добавлен в группы
# созданы ключи
# свои ключи добавлены в доверенные
# cap deploy:install
