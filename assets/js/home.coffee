studentLoans.controller 'AnnihilateCtrl', ['$scope', '$element', '$http'
($scope, $element, $http)->
	
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
		$http.post '/gift/create', {token: token}
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
		$http.post '/gift/list', {limit:limit, offset: offset}
		.success (data)->
			console.log data
			$scope.contributors = data.rows or []
	$scope.get_contributors()

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

	io.socket.on 'new_gift', (msg)->
		$scope.safeApply ->
			$scope.current_due -= parseFloat(msg.amount)
			$scope.contributors.unshift msg

	$scope.photos = []
	for i in [0..100]
		$scope.photos.push i

		
]