const hapi = require('hapi');

const {graphqlPlugin, graphiqlPlugin} = require('./graphql');
const mongoPlugin = require('./mongo');

const server = new hapi.Server();

const HOST = 'localhost';
const PORT = 3000;

server.connection({host: HOST, port: PORT});

server.register(mongoPlugin, (pluginError) => {
  if (pluginError) {
    throw pluginError;
  }

  // graphql plugins need mongo to be finished registering before they can start
  const graphqlPlugins = [graphqlPlugin, graphiqlPlugin];
  server.register(graphqlPlugins);

  console.info('Starting server...');
  server.start((err) => {
    if (err) {
      console.info('Failed!');
      throw err;
    }

    console.info(`Server running at: ${server.info.uri}`);
  });
});
