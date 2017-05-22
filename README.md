rxcmd
==========

Execute unix shell process as RxJS Observable like RxCmd.exec('echo hello').subscribe(...)

## Install

```
npm install rxcmd
```

```
RxCmd=require('rxcmd');
```

## Usage

### Run unix command

```
RxCmd.exec('echo Hello World')
.subscribe(function(output){console.log(output);});

->

Hello World
```

### Filtering 

```
RxCmd.exec('echo Hello World').flatMap(RxCmd.filter('sed s/World/RxCmd/'))
.subscribe(function(output){console.log(output);});

->

Hello RxCmd
```

### Multiple command (Parallel)

```
var commands=[
	'echo foo',
	'echo bar',
	'echo boo'
]

Rx.Observable.from(commands)
.flatMap(RxCmd.multiExec()).flatMap(RxCmd.filter('sed s/o/x/g')).toArray()
.subscribe(function(output){console.log(output);});

->

["fxx\n","bar\n","bxx\n"]
```

### Sink

```
Rx.Observable.from('Hello World').subscribe(RxCmd.sink('tee hello.txt'));

-> cat hello.txt -> "Hello World"

Rx.Observable.from('Hello World').subscribe(RxCmd.sink('tee hello.txt'),function(err,stdout,stderr){
	console.log(stdout);  #"Hello World"
}));
```

## Change Log

- 0.2.x:added sink()
- 0.1.x:first release
