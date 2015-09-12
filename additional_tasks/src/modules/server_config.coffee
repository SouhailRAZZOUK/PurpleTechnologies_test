Bcrypt = require('bcrypt');
Hapi = require('hapi');
Basic = require('hapi-auth-basic');
Joi = require('joi')

server = new Hapi.Server()
server.connection  port: 3000