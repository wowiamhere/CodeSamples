
/* AngularJs Factory
		Set's methods, rails backend source
		to serve data to frontend. --------------------------------Factory------------------- */

trendz_app.factory("getComFac",function($resource){

	var targetUrl = "/api/comments/:id";
	var params = { id: "@id" };
	var methods = 	{
		'create': {	method: 'POST' },
		'index': { 
				method: 'GET',
				isArray: true,
				cache: false,
			},
		'show': 	{ 
				method: 'GET',
				isArray: false,
				cache: false,
/*				transformResponse: 
					function(data, headersGetter){			
						return TransformFunction(data);
				}*/
		},
		'update': 	{ method: 'PUT' },
		'destroy': 	{ method: 'DELETE' }
	};

/* option for xml responses */		
	function TransformFunction(dt, b){
				var xmlDoc = $.parseXML(dt), 
						$xml = $(xmlDoc);

				var dt = {};
				dt.content = $xml.find('content').text();
				dt.creat = $xml.find('created-at').text();
				return dt;		
	};

	return $resource(targetUrl, params, methods);
});

/* AngularJs app.js 
		Prepares url routing, csrf header,..
		Injects ngResource, ngRoute and bootstrap for pagination
		--------------------------------------------------------------main .js file-----------------*/

/* directives to include templates */
#= depend_on_asset "show.html"
#= depend_on_asset "edit.html.erb"
#= depend_on_asset "index.html"

var trendz_app = angular.module('trendzDisplay', ['ngResource', 'ngRoute', 'ui.bootstrap']).
run(console.log("trendzDisplay loaded!"));

trendz_app.config(function($routeProvider, $locationProvider){

	$locationProvider.html5Mode({
		enabled: true,
/* base tag in application.html.erb : line 18-19 */
		requireBase: true,
		rewriteLinks: false
	});

	$routeProvider.
		when('/', {
			templateUrl: "<%= asset_path('show.html') %>",
			controller: 'commentShCtl'
		}).
		when('/comment/:id', {
			templateUrl: "<%= asset_path('show.html') %>",
			controller: 'commentShCtl'
		}).
		when('/comment/:id/post_id/:post_id/fashion_trendz_user_id/:fashion_trendz_user_id', {
			templateUrl: "<%= asset_path('edit.html.erb') %>",
			controller: 'commentsEditCtl2'
		}).
		when('/fashion_trendz_users/:id', {
			templateUrl: "<%= asset_path('index.html') %>",
			controller: 'commentsIndxCtl'

		});
});

trendz_app.config(function($httpProvider){
	$httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
});

/* -error factory as interceptor for response 
			and pushed into $httpProvider.interceptors
*/
trendz_app.config(function($provide, $httpProvider){
	$provide.factory('errorIntercept', function($q){
		return {
			responseError: function(rejection){
				console.log("this is the reason: ", rejection);
				return $q.reject(rejection);
			}
		};
	});

	$httpProvider.interceptors.push('errorIntercept');
});

/* AngularJs show postgresql data 
via rails backend (~/app/controller/api/) --------------------controller---------------------------- */

/*
	-get all coments from database
	-filter comments by date
	-link to edit/show comment
*/	


trendz_app.controller('commentsIndxCtl', 
	['$scope', '$timeout', '$interval', '$location', 'getComFac',
	function($scope, $timeout, $interval, $location, getComFac){
		console.log("commentsIndxCtl loaded!")

	// to validate date for filtering comments by date
		$scope.regex = /^(19|20)\d{2}-(0|1|2)\d-(0|1|2|3)\d$/;

	/* request object for date range */
		var datPar = new Object();

	/* bootstrap pagination variables */
		$scope.currentPage = 1;
		$scope.itemsPerPage = 7;
		$scope.pageChanged = function(){
			$log.log("Page changed to: " + $scope.currentPage);
		};
		$scope.setPage = function(pageNo){
			$scope.currentPage = pageNo;
		};

/* function to get comments */
		function getComments(dU, dL, uid){
				getComFac.index({
					'datUp': dU, 
					"datLow" : dL, 
					"usrid" : uid}, 
					function(data){
						$scope.coms = data;
					/* setting angular's pagination variable */
						$scope.totalItems = $scope.coms.length;
					});
		}

/* subimt function */
		$scope.submit = function(){
		if($scope.datUp && $scope.datLow){

			datPar.datUp = new Date($scope.datUp);
			datPar.datLow = new Date($scope.datLow + "T23:59:59");
		}			
			/* -$resource in action
				 -service in /trendz-app/services */
				getComments(datPar.datUp, datPar.datLow, $scope.usrid);
		};/* $scope.submit */


			/* -set $location.path to redirect to templates/edit via $routeProvider*/
			$scope.edt = function(id, post_id, fashion_trendz_user_id){
				$location.path("comment/" + id + "/post_id/" + post_id + "/fashion_trendz_user_id/" + fashion_trendz_user_id);
			};

			/* -delete comment
				 -pass comment id
				 -on success call submit() to refresh AngularJs
				 		and display success message
				 -on failure display reasons
			*/
			$scope.del = function(id){
				getComFac.destroy({id: id},
					function(data){
						console.log("Delete was successfull", data);
						$scope.succ = "Your comment was successfully deleted";

						// allowing for user to see success response 
						//	before re-rendering comments
						$timeout($scope.sub, 4000);

						// for counter to delete message dissapear
						$scope.sec = 4;
						$scope.angCount = function(){
							$scope.sec = $scope.sec - 1;
							if($scope.sec == 0){
								/* resetting for ng-if on partial:index.html */
								$scope.sec = null;
								$scope.succ = null;
							};
						};
						$interval($scope.angCount, 1000, 4);

					/* refreshing the view for comments */
					getComments(datPar.datUp, datPar.datLow, $scope.usrid);						

					}, function(data){
					console.log("Delete was unsuccessful!!!", data);
				});
			};

}]);

/* AngularJs Edit Postgresql rails database via AngularJs frontend	-----------
-----------------------------------------------------------------------------controller------------*/

/* for editing comments via AngularJs.
		-used  with edit.html.erb (angular template)
		-takes existing comment
		-pops it up in form for editing
		-saves back to backend database
		-displays success/error to user
		-resets $location for use with $route/ngView
*/		

trendz_app.controller("commentsEditCtl2", ["$scope", "$location", "$routeParams", "$timeout", "$interval", "getComFac",
	function($scope, $location, $routeParams, $timeout, $interval, getComFac){
		console.log("commentsEditCtl2 loaded! ");

//array for errors
		$scope.postComErr = [];

//to display cancel button on angularjs 
//	partial on profile page
		$scope.canbool = true;

//then show comment within form
			$scope.comment = getComFac.show({ id: $routeParams.id });

//if hit submit button do this
		$scope.submit = function(){
			console.log("submit pressed. ");

//updatind time strap in object
		$scope.comment.updated_at = new Date();

//function to handle successful response
			function succ(resp){
				console.log("successfully received response. ", resp);
				$scope.succ = "New comment Posted via AngularJs.\n(needs reload to display comment)";
				$scope.comment.content = "";

// setting $location to user page to render initial Angular
//		$resource template renderes				
				$scope.newLoc = function(){
					$location.path('/fashion_trendz_users/' + $scope.comment.fashion_trendz_user_id);
				};

// allowing for user to see success response 
//	before redirecting via $location.path
				$timeout($scope.newLoc, 4000);

// for counter to angular redirect
				$scope.sec = 4;
				$scope.angCount = function(){
					$scope.sec = $scope.sec - 1;
				};
				$interval($scope.angCount, 1000);

			}

			//function to handle error
			function err(errResp){
				console.log("error in response. ", errResp['data']);

				angular.forEach(errResp['data'], function(val, key){
					this.push(key + "->" + val);
				}, $scope.postComErr );			
			}

			//if comment blank
			if(!$scope.comment['post_id']){
				$scope.postComErr.push("comment Cant' be blank!");
			}
			else{
				//if not, update comment
				getComFac.update($scope.comment, succ, err);
			}
		};

		// cancel button: AngularJs Routing to 
		//	templateUrl: index, controller: commentIdxCtl
		$scope.cancel = function(){
			console.log('hitting cancel');

			$location.path("/fashion_trendz_users/" + $scope.comment.fashion_trendz_user_id);
		};

		//for css class
		$scope.errCssClass = function(name){
			//getting form
			var s;
			s = $scope.form[name];
			//returning error string if $invalid & $dirty
			return (s.$invalid) && (s.$dirty) ? "error" : "NO ERROR";
		};

		//errors
		$scope.errorMessage = function(name){
			//getting forms errors
			var s;
			s = $scope.form[name].$error;
			result = [];
			$.each(s, function(key, value){
				result.push(key);
			});
			return result.join(", ");
		};
}]);

/* */