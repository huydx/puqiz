# config valid only for Capistrano 3.1
lock '3.2.1'
set :application, 'puqiz'
set :repo_url, 'git@github.com:huydx/puqiz.git'
set :scm, :git

set :rvm_ruby_string, 'ruby-2.0.0-p481'
set :rvm_type, :user
set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :user, 'deploy'
set :user_sudo, false
set :current_rev, `git show --format='%H' -s`.chomp
set :branch, "master"
set :linked_files, %w{config/database.yml initializers/secret_token.rb}
set :default_shell, '/bin/bash -l'

namespace :deploy do
  desc "Create database and database user"
  task :create_mysql_database do
    set :db_name, 'puqiz_production'
    set :db_user, 'deploy'
    set :db_pass, 'deploy'
    set :db_root_password, 'password'

    on primary fetch(:migration_role) do
      execute "mysql --user=root --password=#{fetch(:db_root_password)} -e \"CREATE DATABASE IF NOT EXISTS #{fetch(:db_name)}\""
      execute "mysql --user=root --password=#{fetch(:db_root_password)} -e \"GRANT ALL PRIVILEGES ON #{fetch(:db_name)}.* TO '#{fetch(:db_user)}'@'localhost' IDENTIFIED BY '#{fetch(:db_pass)}' WITH GRANT OPTION\""
    end
  end


  desc "Start unicorn server"
  task :start do
    on roles(:app) do
      execute "cd #{fetch(:current_path)} bundle exec unicorn_rails -c #{fetch(:unicorn_config)} -E #{fetch(:rails_env)} -D"
    end
  end

  desc "Restart unicorn server"
  task :restart do
    on roles(:app) do
      print execute "`cat #{fetch(:pid_file)}`"
      execute "kill -USR2 `cat #{fetch(:pid_file)}`"
    end
  end

  desc "Reload unicorn server"
  task :reload do
    on roles(:app) do
      execute "kill -HUP `cat #{fetch(:pid_file)}`"
    end
  end

  task :delete_old do
    on roles(:app) do
      set :keep_releases, 2
    end
  end
end
