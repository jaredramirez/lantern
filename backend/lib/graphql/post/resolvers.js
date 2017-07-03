const {pickBy} = require('lodash');
const hapiMongojs = require('hapi-mongojs');

const {create, readAll, readOne, updateOne, deleteOne} = require('../../mongo/ops');
const {objectFromBsonId, objectToBsonId, toBsonId, nonNull} = require('../misc');

const postCollection = 'posts';

const createPostResolver = (_root, args) =>
  create(hapiMongojs.db().collection(postCollection), args.post)
    .then(post => !post ? {} : objectFromBsonId(post))
    .catch((error) => { throw error; });

const getPostsResolver = (_root, args) =>
  readAll(hapiMongojs.db().collection(postCollection), args)
    .then(posts => !posts ? [] : posts.map(objectFromBsonId))
    .catch((error) => { throw error; });

const getPostResolver = (_root, args) =>
  readOne(hapiMongojs.db().collection(postCollection), objectToBsonId(args))
    .then(post => !post ? {} : objectFromBsonId(post))
    .catch((error) => { throw error; });

const updatePostResolver = (_root, {id, post}) =>
  updateOne(
    hapiMongojs.db().collection(postCollection),
    toBsonId(id),
    pickBy(post, nonNull)
  )
    .then(post => !post ? {} : objectFromBsonId(post))
    .catch((error) => { throw error; });

const deletePostResolver = (_root, args) =>
  deleteOne(hapiMongojs.db().collection(postCollection), objectToBsonId(args))
    .then(post => !post ? {} : objectFromBsonId(post))
    .catch((error) => { throw error; });

module.exports = {
  createPostResolver,
  getPostsResolver,
  getPostResolver,
  updatePostResolver,
  deletePostResolver,
};
