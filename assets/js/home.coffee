studentLoans.controller 'AnnihilateCtrl', ['$scope', '$element', '$http',
'$window',
($scope, $element, $http, $window)->
	
	csrf = $('html').attr('csrf')
	console.log csrf

	$scope.safeApply = (fn)->
		phase = @$root.$$phase
		if(phase == '$apply' or phase == '$digest')
			if(fn and (typeof(fn) is 'function'))
				fn()
		else
			@$apply(fn)

	$scope.thanks = false
	$scope.name = ''
	$scope.amount = 100
	$scope.total = 110000
	$scope.end = 0
	$scope.current_due = $scope.total
	$scope.contributors = []

	$scope.finish = (token)->
		token.display_name = $scope.name
		token.amount = $scope.amount
		$http.post '/gift/create', {token: token, _csrf:csrf}
		.success (data)->
			$scope.thanks = true
		.error (data)->
			$scope.thanks = true
			console.log 'error', data

	stripe = StripeCheckout.configure
		key: 'pk_test_flg8p6jcpeJAytkqu4PqUOqI'
		image: '/images/senicaamy.jpg'
		token: (token)->
			$scope.finish(token)

	# Get current total
	$http.get '/gift/total'
	.success (data)->
		$scope.current_due -= data.amount
	.error (data)->
		console.log 'error', data

	# Get latest contributors
	limit = 100
	offset = -100
	$scope.get_contributors = ->
		offset += limit
		$http.get '/gift/list?limit='+limit+'&offset='+offset
		.success (data)->
			console.log data
			$scope.contributors = data.rows or []
	$scope.get_contributors()

	# When a new gift is added
	io.socket.on 'new_gift', (msg)->
		$scope.safeApply ->
			$scope.current_due -= parseFloat(msg.amount)
			$scope.contributors.unshift msg

	$scope.stripe = ($event, valid)->
		$event.preventDefault()
		if not valid
			return false

		stripe.open
			name: 'Senica & Amy'
			description: 'Annihilate our student loans!'
			amount: parseFloat($scope.amount) * 100

		return false

	$scope.barStyle = ->
		width = $('#bar-wrapper', $element).width()
		dif = width / $scope.total
		new_width = $scope.current_due * dif

		return {
			width: new_width
		}

	$scope.indicatorStyle = ()->
		left = ($('#indicator', $element).outerWidth() / 2) + 4
		return {
			left: -left
		}

	$scope.range = (amount)->
		range = [1]
		if amount >= 25
			range.push(2)
		if amount >= 50
			range.push(3)
		if amount >= 75
			range = [1]
		if amount >= 100
			range.push(2)
		if amount >= 125
			range.push(3)
		range

	$scope.photos = []
	for i in [0..100]
		$scope.photos.push i

	$scope.comment =
		name: null
		email: null
		comment: null
	$scope.captcha = null
	$scope.getCaptcha = ->
		$http.post 'comment/start?howmany=5&_csrf='+encodeURIComponent(csrf)
		.success (data)->
			$scope.captcha = data
			$scope.captcha.src = 'image'
		.error (data)->
			console.log 'error captcah', data
	$scope.getCaptcha()

	$scope.playCaptcha = ->
		$scope.captcha.answer = null
		$scope.captcha.src = 'audio'
		# We need this for refreshing
		$('#captchaAudio', $element)[0].load()
		$('#captchaAudio', $element)[0].play()

	$scope.postComment = (event, valid)->
		event.preventDefault()
		$scope.captcha.error = false
		$scope.commentForm.error = false
		if not valid
			return false

		if not $scope.captcha.answer
			$scope.captcha.error = true
			return false


		reply =
			src: $scope.captcha.src
			comment: $scope.comment
		if $scope.captcha.src is 'image'
			reply[$scope.captcha.imageFieldName] = $scope.captcha.answer or false
		else if $scope.captcha.src is 'audio'
			reply[$scope.captcha.audioFieldName] = $scope.captcha.answer or false
		else
			return $scope.captcha.error = true

		$scope.commentForm.sending = true
		reply._csrf = csrf
		$.post '/comment/validate', reply
		.done (data)->
			$scope.safeApply ->
				# reset everything
				$scope.commentForm.thanks = true
				$scope.captcha.error = false
				$scope.commentForm.sending = false
				$scope.commentForm.$setPristine()
				$scope.commentForm.$setUntouched()
				$scope.getCaptcha()
				$scope.comment =
					name: null
					email: null
					comment: null
		.fail (data)->
			$scope.safeApply ->
				if data.status is 403
					$scope.captcha.error = true
				else
					$scope.captcha.error = false
					$scope.commentForm.error = true
				$scope.commentForm.sending = false

	$scope.comments = []
	$http.get '/comment'
	.success (data)->
		$scope.comments = data
		console.log 'comment', $scope.comments
	# When a new comment is added
	io.socket.on 'new_comment', (msg)->
		$scope.safeApply ->
			$scope.comments.unshift(msg)

	$scope.goTo = (id)->
		$('html, body').animate
			scrollTop: $('#'+id).offset().top
		, 500

	# video
	$('#splashvideo').on 'canplaythrough', ->
		$scope.safeApply ->
			$scope.canPlay = true
	.on 'timeupdate', ->
		if this.currentTime > 122.750841
			this.currentTime = 0
			this.pause()
			$scope.safeApply ->
				$scope.playing = false

	$scope.play = ->
		$scope.playing = true
		$('#splashvideo')[0].play()

	$($window).on 'scroll', ->
		if $($window).scrollTop() > $($window).height() / 2
			$('#splashvideo')[0].pause()
		else if $scope.playing
			$('#splashvideo')[0].play()

		
]