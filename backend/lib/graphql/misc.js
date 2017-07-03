const ObjectId = require('bson-objectid');

const toBsonId = id => ObjectId(id);

const fromBsonId = id => id.toString();

const objectToBsonId = value =>
  Object.assign({}, value, {_id: ObjectId(value.id), id: undefined});

const objectFromBsonId = value =>
  Object.assign({}, value, {id: value._id.toString(), _id: undefined});

const nonNull = value => value !== null;

module.exports = {
  toBsonId,
  fromBsonId,
  objectToBsonId,
  objectFromBsonId,
}
