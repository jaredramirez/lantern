const {get, pickBy} = require('lodash');

const {create, readAll, readOne, updateOne, deleteOne} = require('../../mongo/ops');
const {
  objectFromBsonId,
  objectToBsonId,
  toBsonId,
  nonNull,
  authenticateUserAction,
} = require('../misc');

const postCollection = 'posts';

// PRIVATE - Requires an authed user
const createPostResolver = (_root, args, {db, token}) =>
  token ? (
    create(db.collection(postCollection), args.post)
      .then(post => post ? objectFromBsonId(post) : null)
      .catch((error) => { throw error; })
  ) : null;

// PUBLIC
const getPostsResolver = (_root, args, context) =>
  readAll(context.db.collection(postCollection), args)
    .then(posts => posts ? posts.map(objectFromBsonId) : null)
    .catch((error) => { throw error; });

// PUBLIC
const getPostResolver = (_root, args, context) =>
  readOne(context.db.collection(postCollection), objectToBsonId(args))
    .then(post => post ? objectFromBsonId(post) : null)
    .catch((error) => { throw error; });

// PRIVATE - Requires an authed user, and the user most own the post
const updatePostResolver = (_root, {id, post}, {db, token, tokenPayload}) =>
  token ? (
    readOne(db.collection(postCollection), objectToBsonId({id}))
      .then((existingPost) => existingPost ? (
        authenticateUserAction(token, existingPost.author, get(tokenPayload, 'id'),
          () => (updateOne(
              db.collection(postCollection),
              {_id: toBsonId(id)},
              pickBy(post, nonNull)
            )
              .then(oldPost => oldPost ? objectFromBsonId(oldPost) : null)
              .catch((error) => { throw error; })
          )
        )
      ) : null)
  ) : null;

// PRIVATE - Requires an authed user, and the user most own the post
const deletePostResolver = (_root, {id}, {db, token, tokenPayload}) =>
  token ? (
    readOne(db.collection(postCollection), objectToBsonId({id}))
      .then((existingPost) => existingPost ? (
        authenticateUserAction(token, existingPost.author, get(tokenPayload, 'id'),
          () => (
            deleteOne(db.collection(postCollection), objectToBsonId({id}))
              .then(post => post ? objectFromBsonId(post) : null)
              .catch((error) => { throw error; })
          )
        )
      ) : null)
  ) : null;

module.exports = {
  createPostResolver,
  getPostsResolver,
  getPostResolver,
  updatePostResolver,
  deletePostResolver,
};
