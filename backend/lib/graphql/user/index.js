const {
  UserType,
  UserInputType,
  UserUpdateInputType,
  AuthenticationType,
} = require('./definition');
const {
  authenticateUserResolver,
  createUserResolver,
  getUserResolver,
  updateUserResolver,
  deleteUserResolver,
} = require('./resolvers');

module.exports = {
  UserType,
  UserInputType,
  UserUpdateInputType,
  AuthenticationType,

  authenticateUserResolver,
  createUserResolver,
  getUserResolver,
  updateUserResolver,
  deleteUserResolver,
};
