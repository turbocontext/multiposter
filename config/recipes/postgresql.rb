set_default(:postgresql_host, "localhost")
set_default(:postgresql_user) { application }
set_default(:postgresql_password) { Capistrano::CLI.password_prompt "PostgreSQL Password: " }
set_default(:postgresql_database) { "#{application}_production" }

namespace :postgresql do
  desc "Install the latest stable release of PostgreSQL."
  task :install, roles: :db, only: {primary: true} do
    # run "#{sudo} add-apt-repository ppa:pitti/postgresql"
    # run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install postgresql libpq-dev"
  end
  after "deploy:install", "postgresql:install"

  desc "Create a database for this application."
  task :create_database, roles: :db, only: {primary: true} do
    run %Q{#{sudo} -u postgres psql -c "drop database if exists #{postgresql_database};"}
    run %Q{#{sudo} -u postgres psql -c "drop user if exists #{postgresql_user};"}
    run %Q{#{sudo} -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
    run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
  end
  after "deploy:setup", "postgresql:create_database"

  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "postgresql:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "postgresql:symlink"

  desc "Install russian dictionaries"
  task :install_dictionaries, roles: :db, only: {primary: true} do
    # run "rm -rf #{shared_path}/ru_dict"
    # run "rm -rf #{shared_path}/ru_RU-pack.zip"

    # run "wget -O #{shared_path}/ru_RU-pack.zip http://ftp5.gwdg.de/pub/openoffice/contrib/dictionaries/ru_RU-pack.zip"
    # run "unzip #{shared_path}/ru_RU-pack.zip -d #{shared_path}/ru_dict"
    # run "unzip #{shared_path}/ru_dict/ru_RU.zip -d #{shared_path}/ru_dict/dict"

    # run  "#{sudo} touch /usr/share/postgresql/9.1/tsearch_data/russian.affix"
    # run  "#{sudo} chmod 777 /usr/share/postgresql/9.1/tsearch_data/russian.affix"
    # run  "#{sudo} touch /usr/share/postgresql/9.1/tsearch_data/russian.dict"
    # run  "#{sudo} chmod 777 /usr/share/postgresql/9.1/tsearch_data/russian.dict"


    # run "#{sudo} iconv -f koi8-r -t utf-8 < #{shared_path}/ru_dict/dict/ru_RU.aff > /usr/share/postgresql/9.1/tsearch_data/russian.affix"
    # run "#{sudo} iconv -f koi8-r -t utf-8 < #{shared_path}/ru_dict/dict/ru_RU.dic > /usr/share/postgresql/9.1/tsearch_data/russian.dict"

    # run %Q{#{sudo} -u postgres psql -c "CREATE TEXT SEARCH DICTIONARY russian_ispell (
    #     TEMPLATE = ispell,
    #     DictFile = russian,
    #     AffFile = russian,
    #     StopWords = russian
    # );"}
    # run %Q{#{sudo} -u postgres psql -c "CREATE TEXT SEARCH CONFIGURATION ru (COPY=russian);"}
    # run %Q{#{sudo} -u postgres psql -c "ALTER TEXT SEARCH CONFIGURATION ru ALTER MAPPING FOR hword, hword_part, word WITH russian_ispell, russian_stem;"}

    template "postgresql.conf.erb", "/tmp/postgresql.conf"
    run %Q{#{sudo} mv -f /tmp/postgresql.conf /etc/postgresql/9.1/main/postgresql.conf}
  end
  after "deploy:setup", "postgresql:install_dictionaries"
end
