# -*- encoding: utf-8 -*-
require 'open-uri'
require 'nokogiri'
require 'pry'
require 'fileutils'

def main
  charset = nil
  html = open('http://zipcloud.ibsnet.co.jp/') {|f|
    charset = f.charset
    f.read
  }

  doc = Nokogiri::HTML.parse(html, nil, charset)
  
  dl_entry_node = doc.xpath('//div[@class="dlEntry"]')[2]
  p dl_entry_node
  url = dl_entry_node.css('div[class="dlButton"] a').attribute('href').value
  puts url

  if url !~ /\A\/zipcodedata\/download\?di\=[0-9]+\z/
    raise "invalid url: #{url}"
  end

  zip_url = "http://zipcloud.ibsnet.co.jp#{url}"

  system('curl', zip_url, '-o', 'x-ken-all.zip')

  unless $?.success?
    raise "curl failed"
  end

  system('unzip', '-o', 'x-ken-all.zip')

  FileUtils.rm('x-ken-all.zip')

  system('git', 'add', '.')
  system('git', 'commit', '-a', '-m', 'update data')
  system('git', 'push', 'origin', 'master')
end

case $PROGRAM_NAME
when __FILE__
  main
when /spec[^\/]*$/
  # {spec of the implementation}
end

