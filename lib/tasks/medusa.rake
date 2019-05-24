namespace :medusa do

  desc 'Import content from Medusa'
  task :import => :environment do |task, args|
    MedusaImporter.new.import(true)
    puts "\nDone"
  end

  desc 'Import content from Medusa, removing old content first'
  task :fresh_import => [:clear_content, :import] do |task, args|
    #just do required tasks
  end

  desc 'Remove current imported content'
  task clear_content: :environment do
    VirtualRepository.destroy_all
    Collection.destroy_all
    Repository.destroy_all
    AccessSystem.destroy_all
    ResourceType.destroy_all
  end


end
