const {GraphQLObjectType, GraphQLNonNull, GraphQLString} = require('graphql');
const {
  PostType,
  PostCreateInputType,
  PostUpdateInputType,

  createPostResolver,
  updatePostResolver,
  deletePostResolver,
} = require('./post');
const {
  UserType,
  UserInputType,
  UserUpdateInputType,
  AuthenticationType,

  authenticateUserResolver,
  createUserResolver,
  updateUserResolver,
  deleteUserResolver,
} = require('./user');

const mutation = new GraphQLObjectType({
  name: 'RootMutationField',
  fields: {
    // post mutations
    createPost: {
      type: PostType,
      description: 'Create a new post.',
      args: {
        post: {
          type: PostCreateInputType,
          description: "Values to create post, does not include 'id' field",
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
          description: 'id of post to update.',
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
          description: 'id of post to delete',
        },
      },
      resolve: deletePostResolver,
    },

    // user mutations
    authenticate: {
      type: AuthenticationType,
      description: 'Authenticate user',
      args: {
        user: {
          type: UserInputType,
          description: 'Contains email and password, to validate the user.',
        },
      },
      resolve: authenticateUserResolver,
    },
    createUser: {
      type: AuthenticationType,
      description: 'Create user and return new user with auth token.',
      args: {
        user: {
          type: UserUpdateInputType,
          description: "Values to create user, does not include 'id' field",
        },
      },
      resolve: createUserResolver,
    },
    updateUser: {
      type: UserType,
      description: 'Create user and return new user with auth token.',
      args: {
        id: {
          type: GraphQLString,
          description: 'id of user to update.',
        },
        user: {
          type: UserUpdateInputType,
          description: "Values to update user, does not include 'id' field",
        },
      },
      resolve: updateUserResolver,
    },
    deleteUser: {
      type: UserType,
      description: 'Create user and return new user with auth token.',
      args: {
        id: {
          type: new GraphQLNonNull(GraphQLString),
          description: 'id of the user to delete.',
        },
      },
      resolve: deleteUserResolver,
    },
  },
});

module.exports = mutation;
