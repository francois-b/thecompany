'use strict';

// Basic auth credentials - injected at deploy time
const USERNAME = '{{USERNAME}}';
const PASSWORD = '{{PASSWORD}}';

exports.handler = async (event) => {
  const request = event.Records[0].cf.request;
  const headers = request.headers;

  const authHeader = headers.authorization || headers.Authorization;

  if (!authHeader || !authHeader[0]) {
    return unauthorized();
  }

  const authValue = authHeader[0].value;
  const encoded = authValue.split(' ')[1];

  if (!encoded) {
    return unauthorized();
  }

  const decoded = Buffer.from(encoded, 'base64').toString('utf-8');
  const [user, pass] = decoded.split(':');

  if (user === USERNAME && pass === PASSWORD) {
    return request;
  }

  return unauthorized();
};

function unauthorized() {
  return {
    status: '401',
    statusDescription: 'Unauthorized',
    headers: {
      'www-authenticate': [{ key: 'WWW-Authenticate', value: 'Basic realm="Documentation"' }],
      'content-type': [{ key: 'Content-Type', value: 'text/html' }],
    },
    body: '<html><body><h1>401 Unauthorized</h1><p>Authentication required.</p></body></html>',
  };
}
