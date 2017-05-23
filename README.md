rxcmd
==========

Execute unix shell command process as RxJS Observable like RxCmd.exec('echo hello').subscribe(...)

## Install

```
npm install rxcmd
```

```
RxCmd=require('rxcmd');
```

## Usage

### Run unix command (exec)

```
RxCmd.exec('echo Hello World')
.subscribe(function(output){console.log(output);});

->

Hello World
```

### Filtering (filter/liftFilter)

```
RxCmd.exec('echo Hello World').lift(RxCmd.filter('sed s/World/RxCmd/'))
.subscribe(function(output){console.log(output);});

->

Hello RxCmd
```

### Parallel execution (mapExec/mapFilter)

```
var commands=[
	'echo foo',
	'echo bar',
	'echo boo'
]

Rx.Observable.from(commands)
.flatMap(RxCmd.mapExec()).flatMap(RxCmd.mapFilter('sed s/o/x/g'))
.subscribe(function(output){console.log(output);});

->

fxx
bar
bxx
```

### Sink (sink)

```
Rx.Observable.from('Hello World').subscribe(RxCmd.sink(function(err,stdout){
	console.log(stdout);  #"Hello World"
}));

Rx.Observable.from('Hello World').subscribe(RxCmd.sink());

-> Hello World (Simply print if no argument)
```

### Connecting process.stdin

```
#test.js

RxCmd.exec('cat',{stdin:true})
.subscribe(function(output){console.log(output);});

>echo Hello|node test.js

-> Hello
```

## Change Log

- 0.3.x:using spawn() instead of exec()
- 0.3.x:breaking changes:filter()=liftFilter() specification
- 0.3.x:breaking changes:sink() specification
- 0.3.x:breaking changes:filter()->mapFilter()/multiExec()->mapExec()
- 0.2.x:added sink()
- 0.1.x:first release
