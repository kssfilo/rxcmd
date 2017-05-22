### globals describe,it ###

assert=require 'assert'

Rx=require 'rxjs'
RxCmd=require './rxcmd'
Fs=require('fs')

it 'single',(cb)-> RxCmd.exec('echo foo').flatMap(RxCmd.filter('sed s/foo/bar/g')).subscribe (v)->
		cb assert.equal v,"bar\n"

it 'multi',(cb)->
	commands=[
		'echo hoge'
		'echo fuga'
		'echo moga'
	]

	res=''
	
	Rx.Observable.from(commands)
	.flatMap(RxCmd.multiExec()).flatMap(RxCmd.filter('sed s/o/x/g')).toArray().subscribe(
		((v)->res=v)
		,((err)->cb assert.ifError(err))
		,->
			assert.ok "hxge\n" in res
			assert.ok "fuga\n" in res
			assert.ok "mxga\n" in res
			cb()
	)

it 'sink',(cb)->
	Rx.Observable.of('foo').subscribe RxCmd.sink 'tee test.out',(err,stdout,stderr)->
		Fs.readFile 'test.out','utf8',(err,res)->
			Fs.unlink 'test.out',->
				assert.equal res,'foo'
				cb()
