 # GiftController
 #
 # @description :: Server-side logic for managing gifts
 # @help        :: See http://links.sailsjs.org/docs/controllers


mailer = require('nodemailer')
transporter = mailer.createTransport(sails.config.email)
mail_options = {}
	# from:
	# to: 'senica@gmail.com'
	# subject: 'Error processing'
	# text:
	# html:

module.exports =
	total: (req, res)->
		Gift.query 'SELECT SUM(amount) as amount FROM gift', (err, results)->
			if err
				return res.json {amount:0}
			amount = (((results or {}).rows or [])[0] or {}).amount or 0
			res.json { amount: amount }

	list: (req, res)->
		limit = req.query.limit or 10
		offset = req.query.offset or 0
		Gift.query 'SELECT id, display_name, amount FROM gift LIMIT ' + limit +
		' OFFSET ' + offset, (err, results)->
			if err
				return res.status(400).json({ error: 'Could not get list.'})
			res.json results

	create: (req, res)->
		token = req.param('token')
		mail_options.to = 'senica@gmail.com'
		mail_options.from = token.email or 'noreply@example.com'
		Card.findOrCreate({id: token.card.id}, token.card).exec (err, card)->
			if err
				mail_options.subject = 'Error saving card'
				mail_options.text = JSON.stringify(err) + JSON.stringify(token)
				transporter.sendMail mail_options, (err, info)->
					console.log 'Error saving card', err, info

			token.card = (card or {}).id
			Gift.create(token).exec (err, gift)->
				if err
					mail_options.subject = 'Error saving gift'
					mail_options.text = JSON.stringify(err) + JSON.stringify(token)
					transporter.sendMail mail_options, (err, info)->
						console.log 'Error saving gift', err, info
				
				mail_options =
					from: 'senica@gmail.com'
					to: token.email or 'senica@gmail.com'
					subject: 'Thank you for your generosity!'
					text: 'Thank you so much for taking the time out of your day \
						and life to share with us and help us get out from under \
						the pressure of student loan debt. Amy and I could never \
						fully express our appreciation to you. Thank you! \
						\r\n\r\n\
						This email is auto generated. We\'ll thank you personally \
						later.'

				transporter.sendMail mail_options, (err, info)->
					console.log 'Saved!', err, info

				mail_options =
					to: 'senica@gmail.com'
					from: token.email or 'senica@gmail.com'
					subject: 'You received a new student loan gift'
					text: 'Transmission' + JSON.stringify(token)

				transporter.sendMail mail_options, (err, info)->
					console.log 'Saved!', err, info

				sails.sockets.blast('new_gift', gift)

				res.json gift


