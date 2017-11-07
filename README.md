# zipcode_jp

[![CircleCI](https://circleci.com/gh/kmdsbng/zipcode_jp.svg?style=svg)](https://circleci.com/gh/kmdsbng/zipcode_jp)

zipcode_jp provides Japan zip code database/API that is build by JSON file structure.
You can setup your own database/API on your Web storage.


## How to setup.

* Clone this repository.
* Publish /docs directory.


## Directory structure

```
docs/
  zip_code/
    001/
      0010000.json
      0010010.json
      ...
```


## JavaScript API

```
<script type="text/javascript" src="https://your.api.server/api.js"></script>

<script type="text/javascript">
  ZipCodeJp.setZipCodeBaseUrl('https://your.api.server/zip_code');
  ZipCodeJp.getAddressesOfZipCode('6000000', function(err, addresses) {console.log(err); console.log(addresses)});
</script>
```

## Demo
https://jsfiddle.net/kmdsbng/jxratmsL/2/

## License
MIT

## Thanks
zipcode_jp uses x-ken-all.csv provided by [zipcloud](http://zipcloud.ibsnet.co.jp/).


