require 'octokit'

client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
client.create_pull_request(
  'kmdsbng/zipcode_jp',  # 適当に変える
  'master',
  ENV['BRANCH'],
  'Zip data updated',  # Title
  ''                # Body
)

