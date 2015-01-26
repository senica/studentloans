studentLoans = angular.module('studentLoans', [])

# Select text
studentLoans.directive 'select', ->
	return {
		restrict: 'A'
		link: (scope, element, attrs)->
			element.on 'click', ->
				this.select()
	}