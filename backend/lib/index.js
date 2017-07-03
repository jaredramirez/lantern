const hapi = require('hapi');

const {graphqlPlugin, graphiqlPlugin} = require('./graphql');
const mongoPlugin = require('./mongo');

const server = new hapi.Server();

const HOST = 'localhost';
const PORT = 3000;

server.connection({host: HOST, port: PORT});

const plugins = [graphqlPlugin, graphiqlPlugin, mongoPlugin];

console.info('Registering plugins...');
server.register(plugins, (pluginError) => {
  if (pluginError) {
    console.info('Failed!');
    throw pluginError;
  }
  console.info('Success!');

  console.info('Starting server...');
  server.start((err) => {
    if (err) {
      console.info('Failed!');
      throw err;
    }

    console.info(`Server running at: ${server.info.uri}`);
  });
});
