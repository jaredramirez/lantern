const jwt = require('jsonwebtoken');

const secret = 'daBOl18H4kdi68d&1';

const signOptions = {
  algorithm: 'HS256',
  issuer: 'lantern-internal',
  // expiresIn: '30d',
  expiresIn: '1s',
};

const issueToken = payload => new Promise((resolve, reject) =>
  jwt.sign(payload, secret, signOptions,  (err, token) => {
    if (err) {
      reject(err);
    }

    resolve(token);
  })
);

// if token is invalid, reolve to 'null'. actually verification of token
// validity is handled inside the graphql endpoint
const verifyToken = token => new Promise((resolve, reject) =>
  jwt.verify(token, secret, {issuer: signOptions.issuer}, (err, decoded) => {
    if (err) {
      resolve(null);
    }

    resolve(decoded);
  })
);

const decodeToken = (request) => new Promise((resolve, reject) => {
  const req = request.raw.req;

  const authHeader = req.headers.authorization;
  if (!authHeader) {
    resolve(null);
  }

  const parts = authHeader.split(' ');
  if (parts.length !== 2) {
    resolve(null);
  }
  if (parts[0].toLowerCase() !== 'bearer') {
    resolve(null);
  }

  verifyToken(parts[1])
    .then(token => resolve(token));
});

module.exports = {
  issueToken,
  decodeToken,
};
