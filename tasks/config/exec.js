/**
 * Execute scripts on start
 *
 * ---------------------------------------------------------------
 *
 * Execute scripts
 *
 * For usage docs see:
 * 		https://github.com/jharding/grunt-exec
 */
module.exports = function(grunt) {

	grunt.config.set('exec', {
		mongo: {
			command: '~/mongodb/mongod --dbpath ./db',
			stdout: false
		}
	});

	grunt.loadNpmTasks('grunt-exec');
};
