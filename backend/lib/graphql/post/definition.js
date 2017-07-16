const {
  GraphQLObjectType,
  GraphQLInputObjectType,
  GraphQLList,
  GraphQLNonNull,
  GraphQLString,
  GraphQLInt,
} = require('graphql');

const {UserType} = require('../user');

const createNonNull = type => new GraphQLNonNull(type);

const getFields = (shouldBeNonNull = true) => ({
  title: {
    type: shouldBeNonNull ? createNonNull(GraphQLString) : GraphQLString,
    description: 'Title of the post.',
  },
  body: {
    type: shouldBeNonNull ? createNonNull(GraphQLString) : GraphQLString,
    description: 'Body of the post.',
  },
});

const PostType = new GraphQLObjectType({
  name: 'Post',
  fields: Object.assign({}, getFields(), {
    id: {
      type: new GraphQLNonNull(GraphQLString),
      description: 'Identifier of the post.',
    },
    author: {
      type: new GraphQLNonNull(UserType),
      description: 'Author who wrote the post.',
    },
    stars: {
      type: new GraphQLNonNull(new GraphQLList(GraphQLString)),
      description: 'List of users that have starred the post.',
    },
  }),
});

const PostCreateInputType = new GraphQLInputObjectType({
  name: 'PostCreateInputType',
  fields: getFields(),
});

const PostUpdateInputType = new GraphQLInputObjectType({
  name: 'PostUpdateInputType',
  fields: Object.assign({}, getFields(false), {
    stars: {
      type: new GraphQLNonNull(new GraphQLList(GraphQLString)),
      description: 'List of users that have starred the post.',
    },
  }),
});

module.exports = {
  PostType,
  PostCreateInputType,
  PostUpdateInputType,
};
