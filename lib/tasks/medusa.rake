namespace :medusa do

  desc 'Import content from Medusa'
  task :import => :environment do |task, args|
    MedusaImporter.new.import(true)
    puts "\nDone"
  end

end
