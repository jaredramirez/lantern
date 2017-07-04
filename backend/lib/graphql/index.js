const {
  graphql,
  GraphQLSchema,
} = require('graphql');
const {graphqlHapi, graphiqlHapi} = require('graphql-server-hapi');

const {decodeToken} = require('../auth');
const query = require('./query');
const mutation = require('./mutation');

const schema = new GraphQLSchema({
  query,
  mutation,
});

const getGraphqlOptions = (db, token = null) => ({
  schema,
  context: {
    db,
    token,
  }
});

const graphqlPlugin = {
  register: graphqlHapi,
  options: {
    path: '/graphql',
    graphqlOptions: request =>
      decodeToken(request)
        .then(token => getGraphqlOptions(request.mongo.db, token))
        .catch(() => getGraphqlOptions(request.mongo.db)),
    route: {
      cors: true,
    }
  },
};

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
  graphqlPlugin,
  graphiqlPlugin,
};
