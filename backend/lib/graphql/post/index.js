const {PostType, PostCreateInputType, PostUpdateInputType} = require('./definition');
const {
  createPostResolver,
  getPostsResolver,
  getPostResolver,
  updatePostResolver,
  deletePostResolver,
} = require('./resolvers');

module.exports = {
  PostType,
  PostCreateInputType,
  PostUpdateInputType,

  createPostResolver,
  getPostsResolver,
  getPostResolver,
  updatePostResolver,
  deletePostResolver,
};
