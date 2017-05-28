# zipcode_jp

zipcode_jp provides Japan zip code database/API that is build by JSON file structure.
You can setup your own database/API on your Web storage.


## How to setup.

* Clone this repository.
* Publish /data directory.


## Directory structure

```
data/
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
  ZipCodeJp.getAddressesOfZipCode('6000000', function(err, res) {console.log(err); console.log(res)})
</script>
```


## Contribute
zipcode_jp uses z-ken-all.csv of zipcloud. http://zipcloud.ibsnet.co.jp/


