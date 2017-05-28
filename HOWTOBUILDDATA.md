# How to build API data.

```
curl "http://zipcloud.ibsnet.co.jp/zipcodedata/download?di=1493367051289" -o x-ken-all.zip
unzip x-ken-all.zip
ruby parse_csv_and_generate_json.rb x-ken-all.csv ./data/
```




