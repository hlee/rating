pa_network = PublisherAdNetwork.first
CrawlerRun.perform Date.today.prev_month, pa_network.id
LineItem.perform "LineItems/#{pa_network.id}/#{Date.today.prev_month.strftime("%Y%m%d")}"