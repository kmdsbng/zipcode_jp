const request = require('superagent');
const zeropad = require('zeropad');

const ZipCodeJp = {}

ZipCodeJp.setZipCodeBaseUrl = (url) => {
  ZipCodeJp.zip_code_base_url = url;
};

ZipCodeJp.setCityBaseUrl = (url) => {
  ZipCodeJp.city_base_url = url;
};

ZipCodeJp.setRootUrl = (url) => {
  ZipCodeJp.root_url = url;
};

ZipCodeJp.getRootUrl = (url) => {
  const root_url = ZipCodeJp.root_url || "";
  if (root_url == "") {
    return "";
  }
  if (root_url[root_url.length - 1] == "/") {
    return root_url;
  }
  return root_url + "/";
}

ZipCodeJp.getZipCodeBaseUrl = (url) => {
  if (ZipCodeJp.zip_code_base_url != null) {
    return ZipCodeJp.zip_code_base_url;
  } else {
    return ZipCodeJp.getRootUrl() + "zip_code";
  }
}

ZipCodeJp.getCityBaseUrl = (url) => {
  if (ZipCodeJp.city_base_url != null) {
    return ZipCodeJp.city_base_url;
  } else {
    return ZipCodeJp.getRootUrl() + "city";
  }
}

ZipCodeJp.getTownBaseUrl = (url) => {
  return ZipCodeJp.getRootUrl() + "town";
}

ZipCodeJp.getPrefectureJsonUrl = (url) => {
  return ZipCodeJp.getRootUrl() + "prefecture.json";
}

// zipCode: zip code string.
// cb : (err, addresses) => {...}
ZipCodeJp.getAddressesOfZipCode = (zipCode, cb) => {
  const prefix = zipCode.slice(0, 3);
  request
    .get(`${ZipCodeJp.getZipCodeBaseUrl()}/${prefix}/${zipCode}.json`)
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
    .get(`${ZipCodeJp.getCityBaseUrl()}/${zeropad(prefectureJisCode, 2)}.json`)
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

ZipCodeJp.getTownsOfCity = (orgCityJisCode, cb) => {
  const cityJisCode = zeropad(orgCityJisCode, 5);
  const prefectureJisCode = cityJisCode.slice(0, 2);

  request
    .get(`${ZipCodeJp.getTownBaseUrl()}/${prefectureJisCode}/${cityJisCode}.json`)
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

ZipCodeJp.getPrefectures = (cb) => {
  request
    .get(`${ZipCodeJp.getPrefectureJsonUrl()}`)
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

//ZipCodeJp.setZipCodeBaseUrl('/zip_code');
//ZipCodeJp.setCityBaseUrl('/city');
//ZipCodeJp.setTownBaseUrl('/town');
ZipCodeJp.setRootUrl('/');
module.exports = ZipCodeJp;

