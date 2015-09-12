# VALID_CURRENCIES = ['EUR', 'USD', 'GBP', 'CZK', 'JPY']
# CURRENCIES_RATES_TO_EUR = {'EUR': 1,  'USD': 1.1139, 'GBP': 0.7251, 'CZK': 27.057, 'JPY': 134.65}

# Hapi = require('hapi')
Bcrypt = require('bcrypt');
Hapi = require('hapi');
Basic = require('hapi-auth-basic');
Joi = require('joi')

# server = new Hapi.Server()
# server.connection({ port: 3000 })
# 
# calculateExchangeRates = (base_currency, amount) -> 
# 							baseCurrenyRateToEuro = CURRENCIES_RATES_TO_EUR[base_currency]
# 							currenciesRatestoBase = []
# 							VALID_CURRENCIES.forEach (currency, index) -> 
# 								rate = (CURRENCIES_RATES_TO_EUR[currency] / baseCurrenyRateToEuro) * amount
# 								tempCurrency = {}
# 								tempCurrency[currency] = rate
# 								currenciesRatestoBase.push tempCurrency if not (tempCurrency[currency] is 1)
# 							return currenciesRatestoBase
# 
# exchangeRatesRouteOptions = 
# 	method: 'GET'
# 	path: '/exchange-rates/{base_currency}'
# 	handler: (request, reply) -> 
# 		currenciesRates = calculateExchangeRates request.params.base_currency,1
# 		reply 
# 			status:"success"
# 			data:{results: currenciesRates}
# 			message:"Currency rate was successfuly exchanged"
# 	config:
# 		validate:
# 			params:
# 				base_currency: Joi.any().valid(VALID_CURRENCIES)
# 		response:
# 			schema: Joi.object().keys
# 									status: Joi.any().valid ['success','fail']
# 									data: Joi.object()
# 									message: Joi.string()
# 				
# server.route exchangeRatesRouteOptions
# 
# server.start () -> console.log('Server running at:', server.info.uri)

server = new Hapi.Server()
server.connection  port: 3000

users = 
    john: 
        username: 'john'
        password: '$2a$10$iqJSHD.BGr0E2IxQwYgJmeP3NvhPrXAeLSaGCj6IR/XU5QtjVu5Tm'   # 'secret'
        name: 'John Doe'
        id: '2133d32a'
    James:
        username: 'james'
        password: '$2a$10$iqJSHD.BGr0E2IxQwYgJmeP3NvhPrXAeLSaGCj6IR/XU5QtjVu5Tm'   # 'secret'
        name: 'James Frank'
        id: '55136bf2'
    Tom:
        username: 'tom'
        password: '$2a$10$iqJSHD.BGr0E2IxQwYgJmeP3NvhPrXAeLSaGCj6IR/XU5QtjVu5Tm'   # 'secret'
        name: 'Tom Hardy'
        id: '7556e3aa'
    Jack:
        username: 'jack'
        password: '$2a$10$iqJSHD.BGr0E2IxQwYgJmeP3NvhPrXAeLSaGCj6IR/XU5QtjVu5Tm'   # 'secret'
        name: 'Jack Mahon'
        id: '41268d5a'


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