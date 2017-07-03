const mongoBase = (
  method,
  collection,
  object,
  returnRawResult = false
) => new Promise((resolve, reject) => {
  collection[method](object, (err, result) => {
    if (err) {
      reject(err);
    }

    if (returnRawResult) {
      resolve(result);
    } else if (result && result.value) {
      resolve(result.value);
    } else {
      resolve();
    }
  });
});

const create = (collection, object) =>
  mongoBase('insert', collection, object, true);

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

const updateOne = (collection, condition = {}, values = {}) =>
  new Promise((resolve, reject) => {
    collection.findAndModify({query: condition, update: {
      $set: values,
    }, new: false}, (err, result) => {
      if (err) {
        reject(err);
      }
      resolve(result);
    });
  });

const deleteOne = (collection,  condition = {}) => new Promise((resolve, reject) => {
  collection.findAndModify({query: condition, remove: true, new: false}, (err, result) => {
    if (err) {
      reject(err);
    }
    resolve(result);
  });
});

module.exports = {
  create,
  readAll,
  readOne,
  updateOne,
  deleteOne,
};
