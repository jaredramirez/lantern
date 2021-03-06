const bcrypt = require('bcrypt');
const {get, pickBy} = require('lodash');

const {issueToken} = require('../../auth');
const {create, readOne, updateOne, deleteOne} = require('../../mongo/ops');
const {
  throwError,
  objectFromBsonId,
  objectToBsonId,
  toBsonId,
  nonNull,
  authenticateUserAction,
} = require('../misc');

const userCollection = 'users';
const saltRounds = 10;

// PUBLIC
const authenticateUserResolver = (_root, args, context) => 
  readOne(context.db.collection(userCollection), {email: args.user.email})
    .then(user => {
      if (!user) { return null; }
      const transformedUser = objectFromBsonId(user);
      return bcrypt.compare(args.user.password, user.password)
        .then(passwordsMatch => passwordsMatch ? issueToken(transformedUser) : null)
        .then(token => token ? ({token, user: transformedUser}) : null);
    })
    .catch((error) => { throw error; });

// PUBLIC
const createUserResolver = (_root, args, context) =>
  bcrypt.hash(args.user.password, saltRounds)
    .then(hash => create(
      context.db.collection(userCollection),
      Object.assign({}, args.user, {password: hash})
    ))
    .then(user => {
      if (!user) { return null; }
      const transformedUser = objectFromBsonId(user);
      return issueToken(transformedUser)
        .then(token => token ? ({token, user: transformedUser}) : null);
    })
    .catch((error) => { throw error; });

// PRIVATE - Requires authed user, and user must be self
const getUserResolver = (_root, args, {db, token, tokenPayload}) =>
  authenticateUserAction(token, args.id, get(tokenPayload, 'id', null), () => (
    readOne(db.collection(userCollection), objectToBsonId(args))
      .then(user => user ? objectFromBsonId(user) : null)
      .catch((error) => { throw error; })
  ))

// PRIVATE - Requires authed user, and user must be self
const updateUserPromise = (id, user, db) =>
  updateOne(
    db.collection(userCollection),
    {_id: toBsonId(id)},
    pickBy(user, nonNull)
  )
    .then(user => user ? objectFromBsonId(user) : null)
    .catch((error) => { throw error; })

// HELPER
const updateUserResolver = (_root, {id, user}, {db, token, tokenPayload}) =>
  authenticateUserAction(token, id, get(tokenPayload, 'id', null), () => (
    user.password ? (
      bcrypt.hash(user.password, saltRounds).then(hash =>
        updateUserPromise(id, Object.assign({}, user, {password: hash}), db)
      )
    ) : updateUserPromise(id, user, db)
  ))

// PRIVATE - Requires authed user, and user must be self
const deleteUserResolver = (_root, args, {db, token, tokenPayload}) =>
  authenticateUserAction(token, args.id, get(tokenPayload, 'id', null), () => (
    deleteOne(db.collection(userCollection), objectToBsonId(args))
      .then(user => user ? objectFromBsonId(user) : null)
      .catch((error) => { throw error; })
  ))

module.exports = {
  authenticateUserResolver,
  createUserResolver,
  getUserResolver,
  updateUserResolver,
  deleteUserResolver,
};
