# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def updatePollution(site)
  pollution = Pollution.find_or_initialize_by(site_code: site['@SiteCode'])
  pollution.latitude = site['@Latitude']
  pollution.longitude = site['@Longitude']
  species = site['Species']
  if(species.class == Array)
    pollution.index = species.map {|specie| specie['@AirQualityIndex']}.max
  elsif(species.class == Hash)
    pollution.index = species['@AirQualityIndex'].to_f + 1
  end
  if Pollution.where(latitude: pollution.latitude, longitude: pollution.longitude).size == 0
    pollution.save!
  end
end

def fetchData(host)
  jobPath = ('/AirQuality/Hourly/MonitoringIndex/GroupName=London/Json')
  json_response = Net::HTTP.get_response(host, jobPath, 80)

  json_hash = JSON.parse(json_response.body)
  # puts json_hash
  local_authority = json_hash['HourlyAirQualityIndex']['LocalAuthority']
  # puts local_authority
  # # jobs.delete_if {|a| a['color'] == 'disabled' or a['name'].include? 'overall'}
  # # jobs.keep_if {|a| a['name'] =~ /.*aminet.*|.*test.*/}
  # # return jobs.collect {|a| a['name']
  local_authority.each do |authority|
    if(authority['Site'])
      # puts authority['Site'].class
      if(authority['Site'].class == Array)
        authority['Site'].each do |site|
          updatePollution(site)
        end
      elsif (authority['Site'].class == Hash)
        updatePollution(authority['Site'])
      end
    end
  end
end

host = 'api.erg.kcl.ac.uk'
fetchData(host)
