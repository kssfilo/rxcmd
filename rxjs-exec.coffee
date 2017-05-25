Rx=require('rxjs')

child_process=require 'child_process'

execForObserver=(commandLine,options=null)->
	{input,stdin,binary}=options ? {}

	Rx.Observable.create (observer)->
		p=child_process.spawn "sh",['-c',commandLine]
		p.stdout.on 'data',(data)->observer.next data
		p.stdout.on 'close',(code)->observer.complete()
		p.stdout.setEncoding('utf8') unless binary

		if input?
			p.stdin.write input
			p.stdin.end()
		else if stdin
			process.stdin.pipe p.stdin

		->true

exports.exec=(commandLine,options=null)->
	execForObserver(commandLine,options)

liftFilter=(commandLine,options=null)->
	{binary}=options ? {}
	(source)->
		sink=@

		p=child_process.spawn "sh",['-c',commandLine]

		p.stdout.on 'data',(data)->sink.next data
		p.stdout.on 'close',(code)->sink.complete()
		p.stdout.setEncoding('utf8') unless binary

		source.subscribe
			next:(v)->
				p.stdin.write(v)
			error:(e)->
				sink.error e
			complete:->
				p.stdin.end()

exports.execFilter=(commandLine,options=null)->@lift(liftFilter(commandLine,options))

mapExec=->(commandLine,options=null)->execForObserver(commandLine,options)

exports.mapExec=(commandLine,options=null)->@flatMap(mapExec(commandLine,options))

mapExecFilter=(commandLine,options=null)->
	(input)->
		o=options ? {}
		o.input=input
		execForObserver(commandLine,o)

exports.mapExecFilter=(commandLine,options=null)->@flatMap(mapExecFilter(commandLine,options))

exports.patch=(observerClass)->
	observerClass.exec=exports.exec
	observerClass::execFilter=exports.execFilter
	observerClass::mapExec=exports.mapExec
	observerClass::mapExecFilter=exports.mapExecFilter
	true
