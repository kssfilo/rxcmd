Rx=require 'rxjs'
child_process=require 'child_process'

execForObserver=(commandLine,input=null)->
	Rx.Observable.create (observer)->
		p=child_process.exec commandLine,(err,stdout,stderr)->
			if err
				observer.error err
				return
			else
				observer.next stdout
			observer.complete()
		->true
		if input
			p.stdin.write input
			p.stdin.end()

exports.exec=(commandLine)->
	execForObserver(commandLine)

exports.multiExec=->
	(commandLine)->execForObserver(commandLine)

exports.filter=(commandLine)->
	(input)->execForObserver(commandLine,input)

class RxCmdSinkSubscriber
	constructor:(commandLine,callback)->
		@process=child_process.exec commandLine,(err,stdout,stderr)=>
			if callback?
				callback err,stdout,stderr

	next:(v)->
		@process.stdin.write v

	error:(err)->
		throw err

	complete:->
		@process.stdin.end()

exports.sink=(commandLine,callback=null)->
	new RxCmdSinkSubscriber(commandLine,callback)
