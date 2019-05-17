namespace :medusa do

  desc 'Import content from Medusa'
  task :import => :environment do |task, args|
    MedusaImporter.new.import(true)
    puts "\nDone"
  end

  desc 'Import content from Medusa, removing old content first'
  task :fresh_import => :environment do |task, args|
    Collection.destroy_all
    Repository.destroy_all
    MedusaImporter.new.import(true)
    puts "\nDone"
  end


end
