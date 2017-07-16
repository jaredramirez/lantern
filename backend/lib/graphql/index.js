const {
  graphql,
  GraphQLSchema,
} = require('graphql');
const {maskErrors} = require('graphql-errors');
const {graphqlHapi, graphiqlHapi} = require('graphql-server-hapi');

const {decodeToken} = require('../auth');
const query = require('./query');
const mutation = require('./mutation');

const schema = new GraphQLSchema({
  query,
  mutation,
});

maskErrors(schema);

const getGraphqlOptions = (db, {token = null, tokenPayload = null}) => ({
  schema,
  context: {
    db,
    token,
    tokenPayload,
  }
});

const graphqlPlugin = {
  register: graphqlHapi,
  options: {
    path: '/graphql',
    graphqlOptions: request =>
      decodeToken(request)
        .then(values => getGraphqlOptions(request.mongo.db, values))
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
