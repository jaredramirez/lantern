const mongojs = require('mongojs');

const toBsonId = id => mongojs.ObjectId(id);

const fromBsonId = id => id.toString();

const objectToBsonId = value =>
  Object.assign({}, value, {_id: mongojs.ObjectId(value.id), id: undefined});

const objectFromBsonId = value =>
  Object.assign({}, value, {id: value._id.toString(), _id: undefined});

const nonNull = value => value !== null;

module.exports = {
  toBsonId,
  fromBsonId,
  objectToBsonId,
  objectFromBsonId,
}
