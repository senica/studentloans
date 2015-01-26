 # Card.coffee
 #

module.exports =
  schema: true
  attributes:
  	id:
  		type: 'string'
  		primaryKey: true
  		required: true
  		unique: true
  	address_city:
  		type: 'string'
  	address_country:
  		type: 'string'
  	address_line1:
  		type: 'string'
  	address_line1_check:
  		type: 'string'
  	address_line2:
  		type: 'string'
  	address_state:
  		type: 'string'
  	address_zip:
  		type: 'string'
  	address_zip_check:
  		type: 'string'
  	brand:
  		type: 'string'
  	address_country:
  		type: 'string'
  	cvc_check:
  		type: 'string'
  	dynamic_last_4:
  		type: 'string'
  	exp_month:
  		type: 'integer'
  	exp_year:
  		type: 'integer'
  	funding:
  		type: 'string'
  	last4:
  		type: 'string'
  	name:
  		type: 'string'
  	object:
  		type: 'string'
