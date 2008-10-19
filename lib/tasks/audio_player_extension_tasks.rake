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
      task :install => [:create_config_file, :environment, :update, :migrate] do
        puts "Audio Player extension has been installed."
      end
      
      desc "Create an example Audio page, with sample mp3."
      task :demo => :environment do
        require 'highline/import'
        say("Choose an available title for your audio page (suggestions: 'Music', 'Songs' or 'Podcasts')")
        audio_page = title = nil
        while !audio_page
          say "* '#{title}' is not available, please choose another title." if title
          title = prompt_for_title
          audio_page = create_page_from_title(title)
        end
        # Add a body part to the Audio page
        f = File.new(File.join(File.dirname(__FILE__), '../../', 'lib', "audio_body.html"))
        body = PagePart.create(:name => "body", :page_id => audio_page.id, :content => f.read)
        
        # Create some Audio models, with demo MP3s attached
        demo = File.new(File.join(File.dirname(__FILE__), '../../', 'demo', "becool.mp3"))
        Audio.create(:title => "Be cool", :track => demo)
        
        say "A demo Audio Page has been created. Check it out: http://localhost:3000/#{audio_page.slug}"
      end
      
      private
      
      def prompt_for_title
        title = ask("Audio page title (Audio): ") do |q|
          q.whitespace = :strip
        end
        title = "Audio" if title.blank?
        title
      end
      
      def create_page_from_title(title)
        p = Page.new
        p.title = p.breadcrumb = title
        p.slug = title.gsub(/[^-_.a-zA-Z0-9\s]/,"").downcase.split.join("-")
        p.status_id = 100
        p.class_name = "AudioPage"
        p.created_by_id = User.find(:first)
        p.parent_id = Page.roots.first.id
        p.save ? p : nil
      end
      
    end
  end
end
