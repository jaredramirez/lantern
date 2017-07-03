const {
  graphql,
  GraphQLSchema,
} = require('graphql');
const {graphqlHapi, graphiqlHapi} = require('graphql-server-hapi');

const query = require('./query');
const mutation = require('./mutation');

const schema = new GraphQLSchema({
  query,
  mutation,
});

const getGraphqlPlugin = server => ({
  register: graphqlHapi,
  options: {
    path: '/graphql',
    graphqlOptions: {
      schema,
      context: {
        db: server.mongo.db,
      },
    },
    route: {
      cors: true,
    }
  },
});

const graphiqlPlugin = {
  register: graphiqlHapi,
  options: {
    graphiqlOptions: {
      endpointURL: '/graphql',
      schema,
    },
  },
};

module.exports = {
  getGraphqlPlugin,
  graphiqlPlugin,
};
