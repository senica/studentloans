 # Gift.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =
  schema: true
  attributes:
  	id:
  		type: 'string'
  		required: true
  		primaryKey: true
  		unique: true
  	card:
  		model: 'card'
  	display_name:
  		type: 'string'
  	amount:
  		type: 'float'
  	client_ip:
  		type: 'string'
  	created:
  		type: 'integer'
  	email:
  		type: 'string'
  	livemode:
  		type: 'boolean'
  	object:
  		type: 'string'
  	type:
  		type: 'string'
  	used:
  		type: 'boolean'
  	verification_allowed:
  		type: 'boolean'
