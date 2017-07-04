const hapi = require('hapi');

const {graphqlPlugin, graphiqlPlugin} = require('./graphql');
const mongoPlugin = require('./mongo');

const server = new hapi.Server();

const HOST = 'localhost';
const PORT = 3000;

server.connection({host: HOST, port: PORT});

console.info('Connecting to mongo...');
server.register([mongoPlugin], (pluginErr1) => {
  if (pluginErr1) {
    console.info('Failed!');
    throw pluginErr1;
  }
  console.info('Done!');

  // graphql plugins need mongo to be finished registering before they can start
  const graphqlPlugins = [graphqlPlugin, graphiqlPlugin];
  server.register(graphqlPlugins, (pluginErr2) => {
    console.info('Starting server...');
    server.start((err) => {
      if (err) {
        console.info('Failed!');
        throw err;
      }

      console.info(`Server running at: ${server.info.uri}`);
    });
  });
});
