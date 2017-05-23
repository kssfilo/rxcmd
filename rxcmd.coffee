Rx=require 'rxjs'
child_process=require 'child_process'

execForObserver=(commandLine,options=null)->
	{input,stdin}=options ? {}

	Rx.Observable.create (observer)->
		p=child_process.spawn "sh",['-c',commandLine]
		p.stdout.on 'data',(data)->observer.next data
		p.stdout.on 'close',(code)->observer.complete()

		if input?
			p.stdin.write input
			p.stdin.end()
		else if stdin
			process.stdin.pipe p.stdin

		->true

exports.exec=(commandLine,options=null)->
	execForObserver(commandLine,options)

exports.mapExec=->
	(commandLine)->execForObserver(commandLine)

exports.mapFilter=(commandLine)->
	(input)->execForObserver(commandLine,{input})

exports.filter=exports.liftFilter=(commandLine)->
	(source)->
		sink=@

		p=child_process.spawn "sh",['-c',commandLine]

		p.stdout.on 'data',(data)->sink.next data
		p.stdout.on 'close',(code)->sink.complete()

		source.subscribe
			next:(v)->
				p.stdin.write(v)
			error:(e)->
				sink.error e
			complete:->
				p.stdin.end()

exports.sink=(callback=null)->
	r=''

	return
		next:(v)->r+=v
		error:(err)->
			if callback?
				callback err,null
			else
				throw err
		complete:->
			if callback?
				callback null,r
			else
				console.log r

