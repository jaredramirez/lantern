const {
  GraphQLObjectType,
  GraphQLInputObjectType,
  GraphQLList,
  GraphQLNonNull,
  GraphQLString,
  GraphQLInt,
} = require('graphql');

const createNonNull = type => new GraphQLNonNull(type);

const getFields = (shouldBeNonNull = true) => ({
  firstName: {
    type: shouldBeNonNull ? createNonNull(GraphQLString) : GraphQLString,
    description: 'First Naem of the user.',
  },
  lastName: {
    type: shouldBeNonNull ? createNonNull(GraphQLString) : GraphQLString,
    description: 'First Naem of the user.',
  },
  email: {
    type: shouldBeNonNull ? createNonNull(GraphQLString) : GraphQLString,
    description: 'Email of the user.',
  },
});

const UserType = new GraphQLObjectType({
  name: 'User',
  fields: Object.assign({}, getFields(), {
    id: {
      type: new GraphQLNonNull(GraphQLString),
      description: 'Identifier of the user.',
    },
  }),
});

const UserInputType = new GraphQLInputObjectType({
  name: 'UserInputType',
  fields: {
    email: {
      type: new GraphQLNonNull(GraphQLString),
      description: 'Email of the user.',
    },
    password: {
      type: new GraphQLNonNull(GraphQLString),
      description: 'Password of the user.',
    },
  },
});

const UserUpdateInputType = new GraphQLInputObjectType({
  name: 'UserUpdateInputType',
  fields: Object.assign({}, getFields(false), {
    password: {
      type: GraphQLString,
      description: 'Password of the user.',
    },
  }),
});

const AuthenticationType = new GraphQLObjectType({
  name: 'AuthenticationType',
  fields: {
    token: {
      type: new GraphQLNonNull(GraphQLString),
      description: 'JWT token generated for authenticated user.',
    },
    user: {
      type: UserType,
      description: 'User that the authentication was run for.',
    },
  },
});

module.exports = {
  UserType,
  UserInputType,
  UserUpdateInputType,
  AuthenticationType,
};
