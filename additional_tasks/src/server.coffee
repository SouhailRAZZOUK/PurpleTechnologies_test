# Bcrypt = require('bcrypt');
# Hapi = require('hapi');
# Basic = require('hapi-auth-basic');
# Joi = require('joi')
# 
# server = new Hapi.Server()
# server.connection  port: 3000

# users = 
#     john: 
#         username: 'john'
#         password: '$2a$10$iqJSHD.BGr0E2IxQwYgJmeP3NvhPrXAeLSaGCj6IR/XU5QtjVu5Tm'   # 'secret'
#         name: 'John Doe'
#         id: '2133d32a'
#     James:
#         username: 'james'
#         password: '$2a$10$iqJSHD.BGr0E2IxQwYgJmeP3NvhPrXAeLSaGCj6IR/XU5QtjVu5Tm'   # 'secret'
#         name: 'James Frank'
#         id: '55136bf2'
#     Tom:
#         username: 'tom'
#         password: '$2a$10$iqJSHD.BGr0E2IxQwYgJmeP3NvhPrXAeLSaGCj6IR/XU5QtjVu5Tm'   # 'secret'
#         name: 'Tom Hardy'
#         id: '7556e3aa'
#     Jack:
#         username: 'jack'
#         password: '$2a$10$iqJSHD.BGr0E2IxQwYgJmeP3NvhPrXAeLSaGCj6IR/XU5QtjVu5Tm'   # 'secret'
#         name: 'Jack Mahon'
#         id: '41268d5a'


validate =  (request, username, password, callback) ->
    user = users[username]
    return callback null,false if not user

    Bcrypt.compare password, user.password, (err, isValid) ->
        callback(err, isValid, { id: user.id, name: user.name });


server.register Basic,(err) ->
    server.auth.strategy('simple', 'basic', { validateFunc: validate });
    server.route
        method: 'GET'
        path: '/login'
        config: 
            auth: 'simple'
            handler: (request, reply) ->
                reply 'hello, ' + request.auth.credentials.name
    
server.start () ->
	console.log 'server running at: ' + server.info.uri