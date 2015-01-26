 # CommentController
 #
 # @description :: Server-side logic for managing comments
 # @help        :: See http://links.sailsjs.org/docs/controllers

captcha = null

module.exports =
	start: (req, res)->
		captcha = require('visualcaptcha')(req.session)
		captcha.generate(req.query.howmany)
		res.json 200, captcha.getFrontendData()

	image: (req, res)->
		if not captcha
			return res.json 400, {}
		retina = false
		if req.query.retina
			retina = true

		captcha.streamImage req.query.id, res, retina
