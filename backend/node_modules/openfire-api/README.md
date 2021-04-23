## node-openfire-restapi

A simple Node plugin designed to work with Openfire Rest Api plugin. It is used to remote manage the Openfire server.

## How to use

```js
const openfire = new Openfire({
  apiUrl: '<ip>/plugins/restapi/v1',
  secret: '<secret>',
});
```

### 1.1.0 Changes

- Covered all chatroom workspace

## TODO

- [ ] cover all user api end point
- [ ] Implement System related REST Endpoints
- [ ] Implement Group related REST Endpoints
- [ ] Implement Session related REST Endpoints
- [ ] Implement Message related REST Endpoints
- [ ] Implement Security Audit related REST Endpoints
