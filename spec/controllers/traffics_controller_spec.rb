require "rails_helper"
require "pry"

RSpec.describe TrafficsController, type: :controller do
	def save_into_file(ranks, engagements, engagement_string)
		sitename, country, country_rank, start_rank, end_rank = ranks
		daily_page_views, daily_page_views_percentage, daily_time_on_site, daily_time_on_site_percentage, bounce_rate, bounce_rate_percentage = engagements
		data = {
			:sitename => sitename,
			:country => country,
			:country_rank => country_rank,
			:start_rank => start_rank,
			:end_rank => end_rank,
			:daily_page_views => daily_page_views,
			:daily_page_views_percentage => daily_page_views_percentage,
			:daily_time_on_site => daily_time_on_site,
			:daily_time_on_site_percentage => daily_time_on_site_percentage,
			:bounce_rate => bounce_rate,
			:bounce_rate_percentage => bounce_rate_percentage,
			:engagement_string => engagement_string,
		}

		open(Rails.root.join("spec/controllers/history.txt"), 'a') do |f|
  			f.puts data.to_json
		end		
	end

	def fetch_traffic(sitename)
		visit "https://alexa.com/siteinfo/#{sitename}#section_traffic"
		country_tag       = find("#CountryRank").text.split("\n")
		country           = country_tag.first
		country_rank      = country_tag.last.gsub(",", "")
		start_rank        = find(".start-rank .rank").text.gsub(",", "")
		end_rank          = find(".end-rank .rank").text.gsub(",", "")
		engagement_string = find(".engagement").text
		engagements       = engagement_string.split("\n").select { |a| !a.scan(/\d/).empty? }[1..-1]
		ranks             = [sitename, country, country_rank, start_rank, end_rank]
		save_into_file(ranks, engagements, engagement_string)
	end

	def sites_to_import
		[
			'veeco.com',
			'forian.com',
			'wherefoodcomesfrom.com',
			'cuentas.com',
			'tpicomposites.com',
			'cvdequipment.com',
			'spigroupsinfo.com',
			'silicom-usa.com',
			'clearone.com',
			'renren-inc.com',
			'crosscountryhealthcare.com',
			'rubicontechnology.com',
			'intest.com',
			'nlight.net',
			'seachange.com',
			'o2micro.com',
			'gses.com',
			'investors.pagseguro.com',
			'everspin.com',
			'chartindustries.com',
			'cemtrex.com',
			'orbitalenergygroup.com',
			'axt.com',
			'comtechtel.com',
			'ituranusa.com',
			'pcconnection.com',
			'usio.com',
			'ir.wimiar.com',
			'safe-t.com',
			'ir.bmtxinc.com',
			'prth.com',
			'skywatertechnology.com',
			'abm.com',
			'realnetworks.com',
			'emcore.com',
			'ocft.com.sg',
			'oblong.com',
			'ftcsolar.com',
			'smithmicro.com',
			'cirrus.com',
			'intelsys.com',
			'rexnordcorporation.com',
			'semileds.com',
			'ir.cangoonline.com',
			'hudsonglobalscholars.com',
			'aercap.com',
			'waysidetechnology.com',
			'duostechnologies.com',
			'investors.q2ebanking.com',
			'tritoninternational.com',
			'mind-technology.com',
			'ir.qudian.com',
			'triotech.com',
			'umc.com',
			'amsoftware.com',
			'datastoragecorp.com',
			'entegris.com',
			'appian.com',
			'i-click.com',
			'rambus.com',
			'rell.com',
			'datasea.com',
			'simulations-plus.com',
			'dlhcorp.com',
			'stone.co',
			'foresightauto.com',
			'bostonomaha.com',
			'mosys.com',
			'ir.fangdd.com',
			'apexacquisitioncorp.com',
			'photronics.com',
			'mysizeid.com',
			'gsitechnology.com',
			'cerence.com',
			'transact-tech.com',
			'formulasystems.com',
			'geegroup.com',
			'silversuntech.com',
			'towersemi.com',
			'amtechsystems.com',
			'staffing360solutions.com',
			'canaaninc.org',
			'thetmgrp.com',
			'hgpauction.com',
			'resonant.com',
			'isunenergy.com',
			'kadant.com',
			'widepoint.com',
			'nve.com',
			'ceragon.com',
			'textainer.com',
			'asgn.com',
			'mict.com.ph',
			'dhigroupinc.com',
			'alfi.com',
			'summitwireless.com',
			'quicklogic.com',
			'td-holdings.co.jp',
			'boscom.com',
			'capps.com',
			'karooooo.com',
			'pctel.com',
			'ir.arraytechinc.com',
			'kns.com',
			'aerocentury.com',
			'aosmd.com',
			'olb.com',
			'taitroncomponents.com',
			'ftftex.com',
			'agmprime.com',
			'zdat.com',
			'ir.smartm.com',
			'mercurity.com',
			'shotspotter.com',
			'brooks.com',
			'linx.com.br',
			'greenboxpos.com',
			'cmcmaterials.com',
			'sitime.com',
			'ontoinnovation.com',
			'macom.com',
			'net1.com',
			'triterras.com',
			'gtytechnology.com',
			'renesola.com',
			'nisteceltek.com',
			'gigamedia.com.tw',
			'airnettechnology.com',
			'americanwellcorp.com',
			'sigmatronintl.com',
			'redcatholdings.com',
			'ir.chinaindexholdings.com',
			'gan.com',
			'acmrcsh.com',
			'beamforall.com',
			'mgrc.com',
			'nano-di.com',
			'ichorsystems.com',
			'alphabet.com',
			'cri.com',
			'eosenergystorage.com',
			'cleanspark.com',
			'digitalallyinc.com',
			'yallatech.ae',
			'atomera.com',
			'insigniasystems.com',
			'pintec.com',
			'lizhiinc.com',
			'cootek.com',
			'chipmos.com',
			'ir.jianpu.ai',
			'moxianglobal.com',
			'pragroup.com',
			'sequans.com',
			'supercom.com',
			'ir.yuntongxun.com',
			'jinkosolar.com',
			'dqsolar.com',
			'neophotonics.com',
			'auddia.com',
			'eagleequityptnrs.com',
			'immersion.com',
			'keytronic.com',
			'i3verticals.com',
			'he-equipment.com',
			'energous.com',
			'lumentum.com',
			'dspg.com',
			'atkore.com',
			'aware-inc.org',
			'investor.hayward.com',
			'bktechnologies.com',
			'amkor.com',
			'srax.com',
			'acev.io',
			'mindcti.com',
			'the9.com',
			'bsquare.com',
			'ir.clpsglobal.com',
			'investors.shoals.com',
			'ir.blue-city.com',
			'cynergistek.com',
			'clearsign.com',
			'manitexinternational.com',
			'radcom.com',
			'lydall.com',
			'pdf.com',
			'echostar.com',
			'ftandi.com',
			'ultralifecorporation.com',
			'streamlinehealth.net',
			'cmcm.com',
			'siliconmotion.com',
			'igcinc.us',
			'leidos.com',
			'ambarella.com',
			'sgocogroup.com',
			'euronetworldwide.com',
			'onestopsystems.com',
			'amesite.com',
			'gilat.com',
			'ir.yaoshixinghui.com',
			'mdc-partners.com',
			'netelement.com',
			'synchronoss.com',
			'airleasecorp.com',
			'maxlinear.com',
			'powerbridge.com',
			'flyleasing.com',
			'hirequest.com',
			'ir.joyy.sg',
			'oled.com',
			'himax.com.tw',
			'rekor.ai',
			'radware.com',
			'trimascorp.com'
		]
	end

	it "records Alexa history" do
		arr = (2..5).to_a
		(sites_to_import.shuffle).each do |sitename|
			begin
				fetch_traffic(sitename)
				puts "Finished fetching data for #{sitename}"
			rescue => e
				puts "===== had an issue with #{sitename}"
			end
			interval = arr.sample
			sleep interval
		end
	end

	def fetch_website_name(name)			
		name = name.gsub("Common Stock", "")
		visit "https://www.bing.com/search?q=#{name} Website"
		website = all("#b_results .b_algo").first.find(".b_attribution").text
		data = {
			name: name,
			website: website
		}
		open(Rails.root.join("spec/controllers/website_mapping.txt"), 'a') do |f|
  			f.puts data.to_json
		end
	end

	def company_names
		file_path = Rails.root.join("spec/controllers/tech_stock_names.txt")
		companies = []
		File.open(file_path, "r") do |f|
			f.each_line do |line|
				companies << line.strip
			end
		end
		companies[1..-1]
	end

	xit "records stocks with it's website" do
		arr = (2..5).to_a
		(company_names.uniq[6..-1]).each do |company_name|
			begin
				fetch_website_name(company_name)				
			rescue => e
				puts "===== had an issue with #{company_name}"
			end
			interval = arr.sample
			sleep interval
		end
	end
end
