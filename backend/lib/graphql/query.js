const {
  GraphQLObjectType,
  GraphQLList,
  GraphQLNonNull,
  GraphQLString,
} = require('graphql');
const {PostType, getPostResolver, getPostsResolver} = require('./post');

const query = new GraphQLObjectType({
  name: 'RootQueryField',
  fields: {
    posts: {
      type: new GraphQLList(PostType),
      resolve: getPostsResolver,
    },
    post: {
      type: PostType,
      args: {
        id: {
          type: new GraphQLNonNull(GraphQLString),
          description: 'Identifier of a post.',
        }
      },
      resolve: getPostResolver,
    },
  },
});


module.exports = query;
