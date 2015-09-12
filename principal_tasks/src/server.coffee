VALID_CURRENCIES = ['EUR', 'USD', 'GBP', 'CZK', 'JPY']
CURRENCIES_RATES_TO_EUR = {'EUR': 1,  'USD': 1.1139, 'GBP': 0.7251, 'CZK': 27.057, 'JPY': 134.65}

Hapi = require('hapi')
Joi = require('joi')

server = new Hapi.Server()
server.connection({ port: 3000 })

calculateExchangeRates = (base_currency, amount) -> 
							baseCurrenyRateToEuro = CURRENCIES_RATES_TO_EUR[base_currency]
							currenciesRatestoBase = []
							VALID_CURRENCIES.forEach (currency, index) -> 
								rate = (CURRENCIES_RATES_TO_EUR[currency] / baseCurrenyRateToEuro) * amount
								tempCurrency = {}
								tempCurrency[currency] = rate
								currenciesRatestoBase.push tempCurrency if not (tempCurrency[currency] is 1)
							return currenciesRatestoBase

exchangeRatesRouteOptions = 
	method: 'GET'
	path: '/exchange-rates/{base_currency}'
	handler: (request, reply) -> 
		currenciesRates = calculateExchangeRates request.params.base_currency,1
		reply 
			status:"success"
			data:{results: currenciesRates}
			message:"Currency rate was successfuly exchanged"
	config:
		validate:
			params:
				base_currency: Joi.any().valid(VALID_CURRENCIES)
		response:
			schema: Joi.object().keys
									status: Joi.any().valid ['success','fail']
									data: Joi.object()    # needs more refinement (schema of an object that contain an array of objects ...)
									message: Joi.string().max(100)
				
server.route exchangeRatesRouteOptions

server.start () -> console.log('Server running at:', server.info.uri)