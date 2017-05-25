### globals describe,it ###

assert=require 'assert'

Rx=require('rxjs')
require('./rxjs-exec').patch(Rx.Observable)

it 'exec/execFilter',(cb)->
	r=''
	Rx.Observable.exec('echo foo').execFilter('sed s/foo/bar/g').subscribe
		next:(v)->r+=v
		error:(err)->console.error "error:#{err}"
		complete:->
			assert.equal r,"bar\n"
			cb()

it 'mapExec/mapExecFilter',(cb)->
	commands=[
		'echo hoge'
		'echo fuga'
		'echo moga'
	]

	r=''
	Rx.Observable.from(commands)
	.mapExec().mapExecFilter('sed s/o/x/g').subscribe
		next:(v)->r+=v
		error:(err)->console.error "error:#{err}"
		complete:->
			assert.equal r,"hxge\nfuga\nmxga\n"
			cb()

