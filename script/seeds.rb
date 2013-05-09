# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
# 
crawlers = [
  { :name => 'GoogleAdExchange',
    :username => 'eric.hockeybuzz@gmail.com', 
    :password => 'recchi5567'
  },

  { :name => 'AdvertisingDotCom',
    :username => 'theo46216',
    :password => 'og755w'
  }
]


crawlers.each do |crawler|
  user = User.find_or_create_by_email('ale@zam.com')

  ad_server  = AdServer.create!({
    :crawler => crawler[:name]
  })

  ad_network = AdNetwork.create!({
    :name      => crawler[:name],
    :crawler   => crawler[:name],
    :time_zone => "America/New_York",
    :has_geo   => false,
    :ad_server => ad_server
  })

  publisher_ad_network = PublisherAdNetwork.new({
    :ad_network            => ad_network,
    :username              => crawler[:username],
    :password              => crawler[:password],
    :thirdparty_account_id => crawler[:thirdparty_account_id]
  })

  publisher_ad_network.encrypt_password
  publisher_ad_network.save!

  campaign_advertiser = CampaignAdvertiser.create!({
    :name => "#{crawler[:name]} User Created Advertiser",
    :user_id => user.id,
    :publisher_ad_network_id => publisher_ad_network.id
  })

  campaign = Campaign.new
  campaign.campaign_advertiser = campaign_advertiser
  campaign.account_id = 1
  campaign.name = "Some Campaign"
  campaign.save!
  #campaign.sites << Site.create(account_id: 1, name: "foo", url: "foo.com")
end
