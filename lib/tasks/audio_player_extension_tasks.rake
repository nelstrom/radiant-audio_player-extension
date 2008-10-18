namespace :radiant do
  namespace :extensions do
    namespace :audio_player do
      
      desc "Runs the migration of the Audio Player extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          AudioPlayerExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          AudioPlayerExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Audio Player to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[AudioPlayerExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(AudioPlayerExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end
      
      desc "Create audio_player.yml file"
      task :create_config_file do
        config_path = File.join(RAILS_ROOT, 'config', 'extensions', 'audio_player')
        mkdir_p(config_path)
        %w[audio_player].each do |name|
          default_config_file = File.join(File.dirname(__FILE__), '../../', 'config', "#{name}.yml.default")
          config_file = File.join(config_path, "#{name}.yml")
          if File.exists?(default_config_file) && !File.exists?(config_file)
            FileUtils.cp(default_config_file, config_file)
          end
        end
      end
      
      desc "Migrates and copies files in public/admin"
      task :install => [:create_config_file, :environment, :migrate, :update] do
        puts "Audio Player extension has been installed."
      end
      
    end
  end
end
