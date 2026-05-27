namespace :registration do
  desc "TODO"
  task create: :environment do
    Company.all.each do |company|
      Registration.create!(company: company, user: User.first, status: Registration::STATUSES.sample)
    end
  end
end
