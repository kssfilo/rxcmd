### globals describe,it ###

assert=require 'assert'

Rx=require 'rxjs'
RxCmd=require './rxcmd'
Fs=require('fs')

it 'exec/liftFilter',(cb)->

	r=''
	RxCmd.exec('echo foo').lift(RxCmd.liftFilter('sed s/foo/bar/g')).subscribe
		next:(v)->r+=v
		error:(err)->console.error "error:#{err}"
		complete:->
			assert.equal r,"bar\n"
			cb()

it 'mapExec/mapFilter',(cb)->
	commands=[
		'echo hoge'
		'echo fuga'
		'echo moga'
	]

	r=''
	Rx.Observable.from(commands)
	.flatMap(RxCmd.mapExec()).flatMap(RxCmd.mapFilter('sed s/o/x/g')).subscribe
		next:(v)->r+=v
		error:(err)->console.error "error:#{err}"
		complete:->
			assert.equal r,"hxge\nfuga\nmxga\n"
			cb()

it 'sink',(cb)->
	Rx.Observable.of('foo').subscribe RxCmd.sink (err,stdout)->
		assert.equal stdout,'foo'
		cb()

