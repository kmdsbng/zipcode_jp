const request = require('superagent');
const zeropad = require('zeropad');

const ZipCodeJp = {}

ZipCodeJp.setZipCodeBaseUrl = (url) => {
  ZipCodeJp.zip_code_base_url = url;
};

ZipCodeJp.setCityBaseUrl = (url) => {
  ZipCodeJp.city_base_url = url;
};

// zipCode: zip code string.
// cb : (err, addresses) => {...}
ZipCodeJp.getAddressesOfZipCode = (zipCode, cb) => {
  const prefix = zipCode.slice(0, 3);
  request
    .get(`${ZipCodeJp.zip_code_base_url}/${prefix}/${zipCode}.json`)
    .end((err, res) => {
      if (err) {
        if (err.status === 404) {
          cb(null, []);
        } else {
          cb(err, []);
        }
      } else {
        cb(null, res.body);
      }
    });
}

ZipCodeJp.getCitiesOfPrefecture = (prefectureJisCode, cb) => {
  request
    .get(`${ZipCodeJp.city_base_url}/${zeropad(prefectureJisCode, 2)}.json`)
    .end((err, res) => {
      if (err) {
        if (err.status === 404) {
          cb(null, []);
        } else {
          cb(err, []);
        }
      } else {
        cb(null, res.body);
      }
    });
}

ZipCodeJp.setZipCodeBaseUrl('/zip_code');
ZipCodeJp.setCityBaseUrl('/city');
module.exports = ZipCodeJp;

