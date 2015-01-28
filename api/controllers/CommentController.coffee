 # CommentController
 #
 # @description :: Server-side logic for managing comments
 # @help        :: See http://links.sailsjs.org/docs/controllers

mailer = require('nodemailer')
transporter = mailer.createTransport(sails.config.email)


comment = (res, comment)->
	Comment.create comment
	.exec (err, msg)->
		if err
			return res.send 400, {error: 'Could not save comment'}
		
		mail_options =
			to: 'senica@gmail.com'
			from: comment.email or 'senica@gmail.com'
			subject: 'You received a new comment about student loans'
			text: comment.comment

		transporter.sendMail mail_options, (err, info)->
			console.log 'Saved!', err, info

		sails.sockets.blast('new_comment', msg)
		return res.send 200, msg

module.exports =
	start: (req, res)->
		captcha = require('visualcaptcha')(req.session, req.sessionID)
		captcha.generate(req.query.howmany)
		res.json 200, captcha.getFrontendData()

	# Send in the index of the array (1, 2, 3)
	image: (req, res)->
		captcha = require('visualcaptcha')(req.session, req.sessionID)
		retina = false
		if req.query.retina
			retina = true

		captcha.streamImage req.param('id'), res, retina

	# Get audio
	audio: (req, res)->
		captcha = require('visualcaptcha')(req.session, req.sessionID)
		if req.query.type isnt 'ogg'
			req.query.type = 'mp3'

		captcha.streamAudio res, req.query.type

	validate: (req, res)->
		if not req.body.src
			return res.send 403

		captcha = require('visualcaptcha')(req.session, req.sessionID)
		valid = captcha.getFrontendData()
		if not valid
			return res.send 403

		if req.body.src is 'image'
			answer = req.body[valid.imageFieldName]
			if captcha.validateImage answer
				return comment(res, req.body.comment)
			else
				return res.send 403

		else if req.body.src is 'audio'
			answer = req.body[valid.audioFieldName]
			if captcha.validateAudio answer
				return comment(res, req.body.comment)
			else
				return res.send 403

		else
			return res.send 403


