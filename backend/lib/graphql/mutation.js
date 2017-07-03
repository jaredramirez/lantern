const {
  GraphQLObjectType,
  GraphQLString,
} = require('graphql');
const {
  PostType,
  PostCreateInputType,
  PostUpdateInputType,

  createPostResolver,
  updatePostResolver,
  deletePostResolver,
} = require('./post');

const mutation = new GraphQLObjectType({
  name: 'RootMutationField',
  fields: {
    createPost: {
      type: PostType,
      description: 'Create a new post.',
      args: {
        post: {
          type: PostCreateInputType,
          description: 'Values to create post, does not include \'id\' field',
        },
      },
      resolve: createPostResolver,
    },
    updatePost: {
      type: PostType,
      description: 'Update an existing post.',
      args: {
        id: {
          type: GraphQLString,
          description: 'Id of post to update.',
        },
        post: {
          type: PostUpdateInputType,
          description: 'Values to update post.',
        },
      },
      resolve: updatePostResolver,
    },
    deletePost: {
      type: PostType,
      description: 'Delete a post',
      args: {
        id: {
          type: GraphQLString,
          description: 'Id of post to delete',
        },
      },
      resolve: deletePostResolver,
    },
  },
});


module.exports = mutation;
