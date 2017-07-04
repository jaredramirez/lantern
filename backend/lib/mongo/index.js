const mongoPlugin = require('hapi-mongodb');

// const url = 'mongodb://localhost:27017/lantern';
const url = 'mongodb://root:root@ds145892.mlab.com:45892/lantern-blog';

module.exports = {
  register: mongoPlugin,
  options: {
    url,
    settings: {
      poolSize: 10,
    },
    decorate: true,
  },
};
