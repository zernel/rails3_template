# remove files
run "rm README.rdoc"
run "rm public/index.html"
run "rm app/assets/images/rails.png"
run "cp config/database.yml config/database.yml.example"

# install gems
run "rm Gemfile"
file 'Gemfile', File.read("#{File.dirname(rails_template)}/resources/Gemfile")

# init sites_controller
route "root :to => 'sites#index'"
file 'app/controllers/sites_controller.rb', File.read("#{File.dirname(rails_template)}/resources/app/controllers/sites_controller.rb")
run "mkdir app/views/sites"
file 'app/views/sites/index.html.erb', File.read("#{File.dirname(rails_template)}/resources/app/views/sites/index.html.erb")

# bundle install
run "bundle install"

# generate rspec
generate "rspec:install"
gsub_file '.rspec', /--colour/, <<-CODE
--colour
--drb
--format doc
CODE

# copy files
file 'Guardfile', File.read("#{File.dirname(rails_template)}/resources/Guardfile")
run "rm spec/spec_helper.rb"
file 'spec/spec_helper.rb', File.read("#{File.dirname(rails_template)}/resources/spec/spec_helper.rb")
file 'lib/tasks/dev.rake', File.read("#{File.dirname(rails_template)}/resources/lib/tasks/dev.rake")

# remove active_resource and test_unit
gsub_file 'config/application.rb', /require 'rails\/all'/, <<-CODE
require 'rails'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'factory_girl_rails'
CODE

# add time format
environment 'Time::DATE_FORMATS.merge!(:default => "%Y/%m/%d %I:%M %p", :ymd => "%Y/%m/%d")'

# .gitignore
append_file '.gitignore', <<-CODE
config/database.yml
Thumbs.db
.DS_Store
tmp/*
coverage/*
.sass-cache/
public/assets/
public/uploads/
.sass-cache/
.rvmrc
clean_dirs.sh
config/setup_load_paths.rb
CODE

# keep tmp and log
run "touch tmp/.gitkeep"
run "touch log/.gitkeep"

file 'VERSION', File.read("#{File.dirname(rails_template)}/resources/VERSION")

# git commit
git :init
git :add => '.'
git :add => 'tmp/.gitkeep -f'
git :add => 'log/.gitkeep -f'
git :commit => "-a -m 'initial commit'"
