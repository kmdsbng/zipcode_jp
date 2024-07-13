# -*- encoding: utf-8 -*-
require 'open-uri'
require 'nokogiri'
# require 'pry'
require 'fileutils'
require 'digest/sha2'
require File.expand_path(File.dirname(__FILE__) + '/parse_csv_and_generate_json')

def main
  download_x_ken_all_csv

  unless File.exist?('tmp/x-ken-all.csv')
    raise "tmp/x-ken-all.csv not exists"
  end

  new_hash = Digest::SHA256.hexdigest(File.read('tmp/x-ken-all.csv'))
  old_hash = Digest::SHA256.hexdigest(File.read('./x-ken-all.csv'))

  if new_hash != old_hash
    puts "x-ken-all.csv is updated. replace it."
    FileUtils.mv('tmp/x-ken-all.csv', './x-ken-all.csv')
    puts "generate json file."
    ParseCsvAndGenerateJson.new.main('./x-ken-all.csv', './docs')
  else
    puts "x-ken-all.csv not updated."
  end

  #system('git', 'add', '.')
  #system('git', 'commit', '-a', '-m', 'update data')
  #system('git', 'push', 'origin', 'master')
end

def download_x_ken_all_csv
  charset = nil
  html = URI.open('http://zipcloud.ibsnet.co.jp/') {|f|
    charset = f.charset
    f.read
  }

  doc = Nokogiri::HTML.parse(html, nil, charset)

  dl_entry_node = doc.xpath('//div[@class="dlEntry"]')[2]
  url = dl_entry_node.css('div[class="dlButton"] a').attribute('href').value
  puts url

  if url !~ /\A\/zipcodedata\/download\?di\=[0-9]+\z/
    raise "invalid url: #{url}"
  end

  zip_url = "http://zipcloud.ibsnet.co.jp#{url}"

  system('curl', zip_url, '-o', 'tmp/x-ken-all.zip')

  unless $?.success?
    raise "curl failed"
  end

  system('unzip', '-o', 'tmp/x-ken-all.zip', '-d', 'tmp/')
end

case $PROGRAM_NAME
when __FILE__
  main
when /spec[^\/]*$/
  # {spec of the implementation}
end

