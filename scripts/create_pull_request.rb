require 'octokit'

puts "BRANCH: #{ENV['BRANCH']}"
puts "GITHUB_ACCESS_TOKEN: #{ENV['GITHUB_ACCESS_TOKEN']}"

client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
client.create_pull_request(
  'kmdsbng/zipcode_jp',  # 適当に変える
  'master',
  ENV['BRANCH'],
  'Zip data updated',  # Title
  ''                # Body
)

