const hapi = require('hapi');

const {getGraphqlPlugin, graphiqlPlugin} = require('./graphql');
const mongoPlugin = require('./mongo');

const server = new hapi.Server();

const HOST = 'localhost';
const PORT = 3000;

server.connection({host: HOST, port: PORT});

server.register(mongoPlugin, (pluginError) => {
  if (pluginError) {
    throw pluginError;
  }

  const graphqlPlugins = [getGraphqlPlugin(server), graphiqlPlugin];
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
