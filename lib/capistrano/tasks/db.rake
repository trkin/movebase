namespace :db do
  desc 'Dump database'
  task :dump do
    on roles(:worker) do
      dump_file_name = 'tmp/db.dump'
      dump_folder = File.dirname dump_file_name
      dump_only_file = File.basename dump_file_name
      execute "cd #{current_path} && pg_dump --dbname `$HOME/.rbenv/bin/rbenv exec bundle exec rails credentials:show | grep database_url | awk '{print $2}'` > #{dump_file_name}" # rubocop:todo Metrics/LineLength
      execute "cd #{current_path} && cd #{dump_folder} && tar cvzf #{dump_only_file}.tar.gz #{dump_only_file}"
      download! "#{current_path}/#{dump_file_name}.tar.gz", dump_folder
      run_locally do
        puts 'Uncompressing'
        execute "tar -xvzf #{dump_file_name}.tar.gz -C #{dump_folder}"
        invoke 'db:load'
      end
    end
  end

  db_name = 'move_index_production'.freeze
  desc "Load dump to database #{db_name}. It will override any existing data"
  task :load do
    run_locally do
      dump_file_name = 'tmp/db.dump'
      puts "Loading #{dump_file_name} to #{db_name}"
      execute "dropdb #{db_name} || true"
      execute "createdb #{db_name}"
      execute "psql -d #{db_name} -f #{dump_file_name}"
    end
  end
end
