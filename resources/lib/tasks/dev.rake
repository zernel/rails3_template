namespace :dev do
  desc "Rebuild the system"
  task :build => ["tmp:clear", "log:clear", "db:drop", "db:create", "db:migrate", "db:seed", "db:test:prepare" ]
end
