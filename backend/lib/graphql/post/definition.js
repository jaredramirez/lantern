const {
  GraphQLObjectType,
  GraphQLInputObjectType,
  GraphQLNonNull,
  GraphQLString,
  GraphQLInt,
} = require('graphql');

const createNonNull = type => new GraphQLNonNull(type);

const getFields = (shouldBeNonNull = true) => ({
  title: {
    type: shouldBeNonNull ? createNonNull(GraphQLString) : GraphQLString,
    description: 'Title of a post.',
  },
  body: {
    type: shouldBeNonNull ? createNonNull(GraphQLString) : GraphQLString,
    description: 'Body of a post.',
  },
  stars: {
    type: shouldBeNonNull ? createNonNull(GraphQLInt) : GraphQLInt,
    description: 'Number of stars a post has.',
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
      description: 'Identifier of a post.',
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
