rxjs-exec
==========

Execute unix shell command process as RxJS Observable like Rx.Observable.exec('echo hello').subscribe(...)

## Install

```
npm install rxjs-exec
```

```
Rx=require('rxjs');
require('rxjs-exec').patch(Rx.Observable);
```

## Usage

### Run unix command (exec)

```
Rx.Observable.exec('echo Hello World')
.subscribe(function(output){console.log(output);});

->

Hello World
```

### Filtering (execFilter)

```
Rx.Observable.exec('echo Hello World').execFilter('sed s/World/rxjs-exec/')
.subscribe(function(output){console.log(output);});

->

Hello rxjs-exec

#same as 
#>echo Hello World|sed s/World/rxjs-exec/ 
```

### Parallel execution (mapExec/mapExecFilter)

```
var commands=[
	'echo foo',
	'echo bar',
	'echo boo'
]

Rx.Observable.from(commands)
.mapExec().mapExecFilter('sed s/o/x/g')
.subscribe(function(output){console.log(output);});

->

fxx
bar
bxx

#same as 
#>echo foo|sed s/o/x/g &
#>echo bar|sed s/o/x/g &
#>echo boo|sed s/o/x/g &
```

```
var commands=[
	'echo foo',
	'echo bar',
	'echo boo'
]

Rx.Observable.from(commands)
.mapExec().execFilter('sed s/o/x/g')
.subscribe(function(output){console.log(output);});

->

fxx
bar
bxx

#same as 
#>{ echo foo;echo bar;echo boo }|sed s/o/x/g 
```

### Connecting process.stdin

```
#test.js

Rx.Observable.exec('cat',{stdin:true})
.subscribe(function(output){console.log(output);});

>echo Hello|node test.js

-> Hello
```

### Buffer(binary) output

```
Rx.Observable.exec('echo Hello',{binary:true})
.execFilter('cat',{binary:true}).
.subscribe(function(output){console.log(output);});

-> <Buffer 48 65 6c 6c 6f 0a>
```

### ES7 style

```
import Rx from 'rxjs';
import {exec,execFilter,mapExec,mapExecFilter} from 'rxjs-exec'

Rx.Observable::exec('echo Hello World')::execFilter('sed s/World/rxjs-exec/').subscribe(v=>console.log(v));

```

## Change Log

- 0.4.0:forked from rxcmd.js
