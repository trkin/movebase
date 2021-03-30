namespace :upload do
  desc <<~HERE_DOC
    Upload files

    cap production upload:files README.md
    cap production ROLES=db upload:files README.md
  HERE_DOC
  task :files do
    on roles(:all) do
      index = ARGV.index 'upload:files'
      ARGV[index + 1..-1].each do |file_name|
        puts "Uploading #{file_name} to #{current_path}/#{file_name}"
        begin
          upload! file_name, "#{current_path}/#{file_name}"
        rescue StandardError => e
          puts e.message
          puts 'Try to run cap upload:files_f to create folder first and upload files (slower version)'
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
      ARGV[index + 1..-1].each do |file_name|
        puts "Create folders #{File.dirname("#{current_path}/#{file_name}")} and upload #{file_name}"
        execute :mkdir, '-p', File.dirname("#{current_path}/#{file_name}")
        upload! file_name, "#{current_path}/#{file_name}"
      end
      exit # so we do no proccess filename arguments as cap tasks
    end
  end
end
