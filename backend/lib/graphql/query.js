const {
  GraphQLObjectType,
  GraphQLList,
  GraphQLNonNull,
  GraphQLString,
} = require('graphql');
const {PostType, getPostResolver, getPostsResolver} = require('./post');
const {UserType, getUserResolver} = require('./user');

const query = new GraphQLObjectType({
  name: 'RootQueryField',
  fields: {
    posts: {
      type: new GraphQLList(PostType),
      description: 'Retrieve all posts',
      resolve: getPostsResolver,
    },
    post: {
      type: PostType,
      description: 'Retrieve a sinlge post, via id.',
      args: {
        id: {
          type: new GraphQLNonNull(GraphQLString),
          description: 'Identifier of a post.',
        }
      },
      resolve: getPostResolver,
    },
    user: {
      type: UserType,
      description: 'Retrieve a sinlge user, via id.',
      args: {
        id: {
          type: new GraphQLNonNull(GraphQLString),
          description: 'Identifier of a user.',
        }
      },
      resolve: getUserResolver,
    },
  },
});


module.exports = query;
