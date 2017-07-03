const {pickBy} = require('lodash');

const {create, readAll, readOne, updateOne, deleteOne} = require('../../mongo/ops');
const {objectFromBsonId, objectToBsonId, toBsonId, nonNull} = require('../misc');

const postCollection = 'posts';

const createPostResolver = (_root, args, context) =>
  create(context.db.collection(postCollection), args.post)
    .then(post => {
      console.log('post', post);
      return !post ? {} : objectFromBsonId(post);
    })
    .catch((error) => { throw error; });

const getPostsResolver = (_root, args, context) =>
  readAll(context.db.collection(postCollection), args)
    .then(posts => !posts ? [] : posts.map(objectFromBsonId))
    .catch((error) => { throw error; });

const getPostResolver = (_root, args, context) =>
  readOne(context.db.collection(postCollection), objectToBsonId(args))
    .then(post => !post ? {} : objectFromBsonId(post))
    .catch((error) => { throw error; });

const updatePostResolver = (_root, {id, post}, context) =>
  updateOne(
    context.db.collection(postCollection),
    {_id: toBsonId(id)},
    pickBy(post, nonNull)
  )
    .then(post => !post ? {} : objectFromBsonId(post))
    .catch((error) => { throw error; });

const deletePostResolver = (_root, args, context) =>
  deleteOne(context.db.collection(postCollection), objectToBsonId(args))
    .then(post => !post ? {} : objectFromBsonId(post))
    .catch((error) => { throw error; });

module.exports = {
  createPostResolver,
  getPostsResolver,
  getPostResolver,
  updatePostResolver,
  deletePostResolver,
};
