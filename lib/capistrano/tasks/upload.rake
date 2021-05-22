namespace :upload do
  desc <<~HERE_DOC
    Upload files. Show full description with: cap -D upload:files
    Use 'restart' to restart the server
    Use 'all' to upload all changes files not staged for commit (git diff --name-only)

    cap production upload:files README.md
    cap production ROLES=db upload:files README.md config/routes.rb restart
    cap production upload:files all restart && git add .
  HERE_DOC
  task :files do
    on roles(:all) do
      index = ARGV.index 'upload:files'
      ARGV[index + 1..].each do |file_name|
        case file_name
        when 'restart'
          puts 'Restarting the server'
          invoke('passenger:restart')
        when 'all'
          puts 'Uploading all files $(git diff --name-only)'
          `git diff --name-only`.each_line do |all_file_name|
            all_file_name = all_file_name.strip
            puts "Uploading #{all_file_name} to #{current_path}/#{all_file_name}"
            begin
              upload! all_file_name, "#{current_path}/#{all_file_name}"
            rescue StandardError => e
              puts e.message
              puts 'Try to run cap upload:files_f to create folder first and upload files (slower version)'
            end
          end
        else
          puts "Uploading #{file_name} to #{current_path}/#{file_name}"
          begin
            upload! file_name, "#{current_path}/#{file_name}"
          rescue StandardError => e
            puts e.message
            puts 'Try to run cap upload:files_f to create folder first and upload files (slower version)'
          end
        end
      end
      exit # so we do no proccess filename arguments as cap tasks
    end
  end

  desc <<~HERE_DOC
    Create folder and upload files (this is slower than just upload)

    cap production upload:files_f README.md
  HERE_DOC
  task :files_f do
    on roles(:all) do
      index = ARGV.index 'upload:files_f'
      ARGV[index + 1..].each do |file_name|
        puts "Create folders #{File.dirname("#{current_path}/#{file_name}")} and upload #{file_name}"
        execute :mkdir, '-p', File.dirname("#{current_path}/#{file_name}")
        upload! file_name, "#{current_path}/#{file_name}"
      end
      exit # so we do no proccess filename arguments as cap tasks
    end
  end
end
