const mongoBase = (
  method,
  collection,
  object,
  returnOps = false
) => new Promise((resolve, reject) => {
  collection[method](object, (err, result) => {
    if (err) {
      reject(err);
    }

    if (returnOps) {
      resolve(result.ops[0]);
    } else if (result && result.value) {
      resolve(result.value);
    } else {
      resolve();
    }
  });
});

const create = (collection, object) =>
  mongoBase('insertOne', collection, object, true);

const readAll = (collection, condition = {}) => new Promise((resolve, reject) => {
  collection.find(condition).toArray((err, users) => {
      if (err) {
      reject(err);
    }
    resolve(users);
  });
});

const readOne = (collection, condition = {}) =>
  mongoBase('findOne', collection, condition, true);

const updateOne = (collection, condition = {}, values) =>
  new Promise((resolve, reject) => {
    collection.findAndModify(condition, [], {
      $set: values,
    }, {new: false}, (err, result) => {
      if (err) {
        reject(err);
      }
      console.log('result', result);
      resolve(result.value);
    });
  });

const deleteOne = (collection,  condition = {}) =>
  mongoBase('findOneAndDelete', collection, condition);

module.exports = {
  create,
  readAll,
  readOne,
  updateOne,
  deleteOne,
};
