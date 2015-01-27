 # Comment.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =
	schema: true
	attributes:
		id:
			type: 'integer'
			primaryKey: true
			unique: true
			autoIncrement: true
		name:
			type: 'string'
			required: true
		email:
			type: 'email'
			required: true
		comment:
			type: 'text'
			required: true

