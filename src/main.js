const request = require('superagent');

const ZipCodeJp = {}

// zipCode: zip code string.
// cb : (err, addresses) => {...}
ZipCodeJp.getAddressesOfZipCode = (zipCode, cb) => {
  const prefix = zipCode.slice(0, 3);
  request
    .get(`/zip_code/${prefix}/${zipCode}.json`)
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

window.ZipCodeJp = ZipCodeJp;





