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
		["abm.com", "acev.io", "aciworldwide.com", "axcelis.com", "acmrcsh.com", "acvauctions.com", "aerocentury.com", "analog.com", "advantagesolutions.net", "aercap.com", "audioeye.com", "agmprime.com", "agilysys.com", "c3.ai", "airgain.com", "airleasecorp.com", "alfi.com", "allegromicro.com", "alkami.com", "astronovainc.com", "alarm.com", "altaequipment.com", "altair.com", "alithya.com", "ambarella.com", "amkor.com", "amesite.com", "amsoftware.com", "americanwellcorp.com", "arista.com", "ansys.com", "airnettechnology.com", "aosmd.com", "investor.agora.io", "applovin.com", "appian.com", "digitalturbine.com", "apexacquisitioncorp.com", "ir.arraytechinc.com", "arrow.com", "asgn.com", "asml.com", "asuresoftware.com", "aseglobal.com", "amtechsystems.com", "a10networks.com", "atkore.com", "atomera.com", "activisionblizzard.com", "auddia.com", "broadcom.com", "avid.com", "avnet.com", "avaya.com", "aware-inc.org", "axt.com", "alteryx.com", "aspentech.com", "blackberry.com", "bbsi.com", "brightcove.com", "beamforall.com", "bgsf.com", "bench.com", "adchina.io", "bilibili.com", "bktechnologies.com", "blackline.com", "ir.blue-city.com", "ballard.com", "bridgeline.com", "blackbaud.com", "ir.bmtxinc.com", "benefitfocus.com", "bostonomaha.com", "boscom.com", "brooks.com", "bsquare.com", "bentley.com", "investors.billtrust.com", "caci.com", "capps.com", "calix.com", "canaaninc.org", "ir.cangoonline.com", "casa-systems.com", "cmcmaterials.com", "clearchanneloutdoor.com", "crosscountryhealthcare.com", "ceridian.com", "cardlytics.com", "cadence.com", "cemtrex.com", "cevalogistics.com", "cognyte.com", "checkpoint.com", "changehealthcare.com", "ir.chinaindexholdings.com", "cloudera.com", "clearsign.com", "ir.clpsglobal.com", "clearone.com", "cleanspark.com", "clarivate.com", "cambiumnetworks.com", "cmcm.com", "comtechtel.com", "zdat.com", "concentrix.com", "pcconnection.com", "commscope.com", "compass.state.pa.us", "coupa.com", "cree.com", "cri.com", "cerence.com", "ceragon.com", "corsair.com", "cirrus.com", "crowdstrike.com", "csgi.com", "cornerstoneondemand.com", "cynergistek.com", "ctg.com", "cootek.com", "cantaloupe.com", "customtruck.com", "cognizant.com", "citrix.com", "cuentas.com", "commvault.com", "cvdequipment.com", "cyberark.com", "cyren.com", "endava.com", "dieboldnixdorf.com", "duckcreek.com", "3dsystems.com", "delltechnologies.com", "digi.com", "digitalallyinc.com", "dhigroupinc.com", "diodes.com", "dolby.com", "dlhcorp.com", "deluxe.com", "desktopmetal.com", "digimarc.com", "digitalmediasolutions.com", "digitalocean.com", "domo.com", "amdocs.com", "ir.douyu.com", "dqsolar.com", "viantinc.com", "dspg.com", "dynatrace.com", "datasea.com", "datastoragecorp.com", "ir.fangdd.com", "duostechnologies.com", "doubleverify.com", "ebix.com", "ir.ebang.com.cn", "euronetworldwide.com", "investor.emeraldx.com", "egain.com", "nisteceltek.com", "emcore.com", "entegris.com", "envestnet.com", "eosenergystorage.com", "epam.com", "bottomline.com", "ericsson.com", "energyrecovery.com", "elastic.co", "e2open.com", "everbridge.com", "everquote.com", "evolving.com", "evopayments.com", "evertecinc.com", "exlservice.com", "exterran.com", "web.facebook.com", "factset.com", "fireeye.com", "f5.com", "fico.com", "fiserv.com", "flex.com", "getfluent.com", "fleetcor.com", "flyleasing.com", "flywire.com", "forian.com", "formfactor.com", "formulasystems.com", "shift4.com", "jfrog.com", "foresightauto.com", "firstsolar.com", "fastly.com", "fedsig.com", "ftandi.com", "ftcsolar.com", "ftftex.com", "gan.com", "globalblue.com", "greenboxpos.com", "greendot.com", "gdsholdingsltd.gcs-web.com", "griddynamics.com", "gigamedia.com.tw", "gilat.com", "global-e.com", "td-holdings.co.jp", "alphabet.com", "gsitechnology.com", "greensky.com", "ir.yaoshixinghui.com", "chartindustries.com", "gtytechnology.com", "gses.com", "guidewire.com", "investor.hayward.com", "thehackettgroup.com", "he-equipment.com", "hgpauction.com", "investor.hh.ru", "himax.com.tw", "harmonicinc.com", "hirequest.com", "heidrick.com", "hudsonglobalscholars.com", "ibex.co", "ichorsystems.com", "i-click.com", "intellicheck.com", "iec-electronics.com", "igcinc.us", "isg-one.com", "i3verticals.com", "immersion.com", "chipmos.com", "corporate.intermexonline.com", "ihsmarkit.com", "infosys.com", "innodata.com", "inovalon.com", "inpixon.com", "intelsys.com", "intest.com", "inuvo.com", "identiv.com", "prodivnet.com", "interpublic.com", "ipgphotonics.com", "iq.com", "issuerdirect.com", "insigniasystems.com", "isunenergy.com", "ituranusa.com", "izea.com", "jamf.com", "jabil.com", "j2global.com", "jackhenry.com", "jinkosolar.com", "juniper.net", "geegroup.com", "ir.51job.com", "ir.jianpu.ai", "kadant.com", "karooooo.com", "kubient.com", "en.ksyun.com", "kellyservices.com", "kforce.com", "kornferry.com", "kns.com", "kaleyra.com", "keytronic.com", "kvh.com", "nlight.net", "lydall.com", "leidos.com", "semileds.com", "littelfuse.com", "linx.com.br", "lumentum.com", "lizhiinc.com", "ir.logitech.com", "liveperson.com", "lamresearch.com", "latticesemi.com", "manpowergroup.com", "manh.com", "mantech.com", "microchip.com", "moodys.com", "mongodb.com", "mdc-partners.com", "allscripts.com", "manulife.com", "microfocus.com", "mercurity.com", "magicsoftware.com", "magnite.com", "mgrc.com", "mict.com.ph", "mind-technology.com", "miteksystems.com", "mixtelematics.com", "mindcti.com", "manitexinternational.com", "modeln.com", "ir.immomo.com", "mosys.com", "moxianglobal.com", "monolithicpower.com", "everspin.com", "marinsoftware.com", "marvell.com", "msci.com", "forzamotorsport.net", "motorolasolutions.com", "datto.com", "microstrategy.com", "materialise.com", "macom.com", "micron.com", "magnachip.com", "maximintegrated.com", "maxlinear.com", "mysizeid.com", "ni.com", "ncm.com", "ncino.com", "the9.com", "netelement.com", "newrelic.com", "nice.com", "nortonlifelock.com", "nano-di.com", "nokia.com", "servicenow.com", "neophotonics.com", "insight.com", "netapp.com", "netscout.com", "nutanix.com", "netsoltech.com", "nuance.com", "nve.com", "nxp.com", "oblong.com", "ocft.com.sg", "orbitalenergygroup.com", "o2micro.com", "olb.com", "oled.com", "olo.com", "omnicomgroup.com", "onsemi.com", "onemedical.com", "ontoinnovation.com", "investor.opera.com", "onespan.com", "onestopsystems.com", "opentext.com", "investors.pagseguro.com", "paloaltonetworks.com", "partech.com", "uipath.com", "paya.com", "paycom.com", "powerbridge.com", "pctel.com", "parkcitygroup.com", "pagerduty.com", "pdf.com", "pega.com", "perion.com", "proofpoint.com", "phunware.com", "shiftpixy.com", "photronics.com", "playtika.com", "palantir.com", "eplus.com", "plexus.com", "power.com", "pragroup.com", "porchgroup.com", "perficient.com", "investor.progleasing.com", "progress.com", "pros.com", "prth.com", "purestorage.com", "pintec.com", "ptc.com", "pubmatic.com", "qad.com", "qualcomm.com", "ir.qudian.com", "qualys.com", "quantum.com", "quinstreet.com", "ir.qutoutiao.net", "investors.q2ebanking.com", "quicklogic.com", "qumu.com", "quotient.com", "ir.yuntongxun.com", "liveramp.com", "ribboncommunications.com", "rubicontechnology.com", "redcatholdings.com", "rentacenter.com", "radcom.com", "radware.com", "rekor.ai", "rell.com", "renren-inc.com", "resonant.com", "rambus.com", "riministreet.com", "realnetworks.com", "rollins.edu", "repay.com", "rapid7.com", "researchsolutions.investorroom.com", "rexnordcorporation.com", "sabre.com", "saic.com", "sailpoint.com", "sanmina.com", "money.tmx.com", "echostar.com", "socketmobile.com", "sciplay.com", "scansource.com", "secureworks.com", "schrodinger.com", "sealimited.com", "seachange.com", "solaredge.com", "safe-t.com", "ir.fang.com", "signifyhealth.com", "ir.smartm.com", "sigmalabsinc.com", "sigmatronintl.com", "sgocogroup.com", "investors.shoals.com", "sharpspring.com", "silicom-usa.com", "siliconmotion.com", "sitime.com", "skillz.com", "skywatertechnology.com", "silabs.com", "sunlife.com", "simulations-plus.com", "supermicro.com", "smithmicro.com", "semtech.com", "fns.usda.gov", "synchronoss.com", "synopsys.com", "synnexcorp.com", "investors.sohu.com", "renesola.com", "supercom.com", "spigroupsinfo.com", "splunk.com", "sapiens.com", "support.com", "sproutsocial.com", "us.sunpower.com", "sequans.com", "srax.com", "servicesource.com", "eagleequityptnrs.com", "silversuntech.com", "shotspotter.com", "stratasys.com", "staffing360solutions.com", "stem.com", "st.com", "stone.co", "streamlinehealth.net", "seagate.com", "sumologic.com", "sunworksusa.com", "solarwinds.com", "skyworksinc.com", "sykes.com", "synaptics.com", "systemax.com", "transact-tech.com", "taitroncomponents.com", "trueblue.jetblue.com", "tucows.com", "teradata.com", "tenable.com", "tessco.com", "textainer.com", "talend.com", "telos.com", "tpicomposites.com", "triterras.com", "thetmgrp.com", "transcat.com", "trimascorp.com", "triotech.com", "tritoninternational.com", "trivago.com", "towersemi.com", "tsmc.com", "townsquaremedia.com", "thesimsresource.com", "ttec.com", "ttm.com", "take2games.com", "tufin.com", "ti.com", "tylertech.com", "travelzoo.com", "uct.com", "net1.com", "unisys.com", "ultralifecorporation.com", "umc.com", "uplandsoftware.com", "unitedrentals.com", "usio.com", "valueline.com", "veeco.com", "verb.tech", "veritone.com", "vrtx.com", "viavisolutions.com", "voxxintl.com", "varonis.com", "verint.com", "verisign.com", "viasat.com", "energous.com", "ir.weibo.com", "westerndigital.com", "wherefoodcomesfrom.com", "ir.wimiar.com", "summitwireless.com", "wipro.com", "workiva.com", "wisekey.com", "willscot.com", "waysidetechnology.com", "investors.waitrapp.com", "widepoint.com", "exelatech.com", "xilinx.com", "xunlei.com", "xperi.com", "xerox.com", "yallatech.ae", "yandex.com", "ir.joyy.sg", "zebra.com", "zepp.com", "zix.com", "zscaler.com", "zuora.com"]
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
