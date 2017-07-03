const mongoPlugin = require('hapi-mongodb');

module.exports = {
  register: mongoPlugin,
  options: {
    url: 'mongodb://root:root@ds145892.mlab.com:45892/lantern-blog',
    settings: {
      poolSize: 10,
    },
    decorate: true,
  },
};
