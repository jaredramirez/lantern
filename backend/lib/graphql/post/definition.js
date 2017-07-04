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
  title: {
    type: shouldBeNonNull ? createNonNull(GraphQLString) : GraphQLString,
    description: 'Title of the post.',
  },
  body: {
    type: shouldBeNonNull ? createNonNull(GraphQLString) : GraphQLString,
    description: 'Body of the post.',
  },
  stars: {
    type: shouldBeNonNull
      ? createNonNull(new GraphQLList(GraphQLString)) : new GraphQLList(GraphQLString),
    description: 'List of users that have starred the post.',
  },
  author: {
    type: shouldBeNonNull ? createNonNull(GraphQLString) : GraphQLString,
    description: 'Author who wrote the post.',
  },
});

const PostType = new GraphQLObjectType({
  name: 'Post',
  fields: Object.assign({}, getFields(), {
    id: {
      type: new GraphQLNonNull(GraphQLString),
      description: 'Identifier of thie post.',
    },
  }),
});

const PostCreateInputType = new GraphQLInputObjectType({
  name: 'PostCreateInputType',
  fields: getFields(),
});

const PostUpdateInputType = new GraphQLInputObjectType({
  name: 'PostUpdateInputType',
  fields: getFields(false),
});

module.exports = {
  PostType,
  PostCreateInputType,
  PostUpdateInputType,
};
