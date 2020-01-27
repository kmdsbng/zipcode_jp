var assert = require('assert');
var ZipCodeJp = require('../src/zip_code_jp.js');

describe('ZipCodeJp', () => {
  beforeEach(() => {
    ZipCodeJp.setZipCodeBaseUrl('https://kmdsbng.github.io/zipcode_jp/zip_code');
  });

  describe('#getAddressesOfZipCode()', () => {
    context('invalid zip code', () => {
      it('should return empty address', () => {
        ZipCodeJp.getAddressesOfZipCode(
          '0010011',
           (err, addresses) => {
             assert.equal(0, addresses.length);
           }
        );
      });
    });

    context('valid zip code', () => {
      it('should detect valid address', () => {
        ZipCodeJp.getAddressesOfZipCode(
          '0010013',
           (err, addresses) => {
             assert.equal(1, addresses.length);
           }
        );
      });

      it('should return valid name', () => {
        ZipCodeJp.getAddressesOfZipCode(
          '0010013',
           (err, addresses) => {
             const addr = addresses[0];
             assert.equal("北海道札幌市北区北十三条西", addr.prefecture_name + addr.city_name + addr.town_name);
           }
        );
      });

    });
  });

  describe('#getCity()', () => {
    it('should return city', () => {
      ZipCodeJp.getCity(
        '20220',
         (err, city) => {
           assert.equal(true, city != null);
           assert.equal("安曇野市", city.city_name);
         }
      );
    });

    it('should return null', () => {
      ZipCodeJp.getCity(
        '20221',
         (err, city) => {
           assert.equal(true, null);
         }
      );
    });
  });
});

