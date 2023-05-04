// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    string public ZEN_LIBRARY = "!function(e,t){\"object\"==typeof exports&&\"object\"==typeof module?module.exports=t():\"function\"==typeof define&&define.amd?define([],t):\"object\"==typeof exports?exports.zen=t():e.zen=t()}(this,(()=>(()=>{\"use strict\";var e={d:(t,i)=>{for(var n in i)e.o(i,n)&&!e.o(t,n)&&Object.defineProperty(t,n,{enumerable:!0,get:i[n]})},o:(e,t)=>Object.prototype.hasOwnProperty.call(e,t),r:e=>{\"undefined\"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:\"Module\"}),Object.defineProperty(e,\"__esModule\",{value:!0})}},t={};e.r(t),e.d(t,{Context:()=>u,LoopContext:()=>h,accum:()=>accum,add:()=>y,and:()=>j,breakIf:()=>v,createWorklet:()=>W,cycle:()=>cycle,data:()=>C,decay:()=>ue,decayTrig:()=>he,delta:()=>q,div:()=>M,emitCode:()=>d,eq:()=>P,float:()=>c,genArg:()=>b,gt:()=>I,gte:()=>_,history:()=>r,input:()=>$,latch:()=>U,lt:()=>O,lte:()=>k,mult:()=>z,neq:()=>T,noise:()=>ee,or:()=>L,param:()=>te,peek:()=>D,phasor:()=>E,poke:()=>F,pow:()=>S,print:()=>ie,s:()=>se,scale:()=>ne,sine:()=>me,sub:()=>w,sumLoop:()=>X,t60:()=>oe,triangle:()=>de,zen:()=>p,zswitch:()=>ae,zswitch_inline_else:()=>le,zswitch_inline_then:()=>re});class i{}class n extends i{constructor(e,t,i,n,s){super(),this.context=e,this.__idx=-1,this._size=i,this.idx=t,this.size=i,this.allocatedSize=n,this.initData=s}set idx(e){this.__idx=e}get idx(){return this.__idx}set size(e){this._size=e}get size(){return this._size}respond(e){this.responseCallback(e),this.waitingForResponse=void 0}get(){return this.context.postMessage({type:\"memory-get\",body:{idx:this.idx,allocatedSize:this.allocatedSize}}),this.waitingForResponse=\"memory-get\",new Promise((e=>{this.responseCallback=e}))}}class s extends n{constructor(e,t,i,n){super(e,t,i,n),this.context=e,this._idx=t,this._size=i,this.allocatedSize=n,this.channels=0,this.length=0}get idx(){return`${this._idx} + ${this.allocatedSize}*${this.context.loopIdx}*${this.context.loopSize}`}set idx(e){this._idx=e}get size(){return this._size*this.context.loopSize}set size(e){this._size=e}}class a{constructor(e,t){this.size=t,this.context=e,this.references=0,this.blocksInUse=[],this.freeList=[new n(e,0,t,0)]}alloc(e){for(let t=0;t<this.freeList.length;t++){let i=this.freeList[t];if(e<=i.size)return i=this.useBlock(i,e,t),i.allocatedSize=e,this.blocksInUse.push(i),i}return this.increaseHeapSize(),this.alloc(e)}increaseHeapSize(){this.size*=2;let e=this.freeList[this.freeList.length-1];e.size=this.size-e.allocatedSize}useBlock(e,t,i){return e.size==t?this.freeList.splice(i,1):this.freeList.splice(i,1,new n(this.context,e.idx+t,e.size-t,t)),this.references++,e}free(e){this.freeList.push(e),this.references--,0===this.references&&(this.freeList[0].idx=0)}}const r=(e,t)=>{let i,n,s,a,r=u=>h=>{let m=h;t&&t.name,h=m;let c=u?u(m):void 0,$=s!==h;s=h,(void 0===i||$)&&(i=s.alloc(1),n=s.useVariables(\"historyVal\")[0]);let p=`\\nlet ${n} = memory[${i.idx}];\\n`,b=\"\",f=n;if(c){let[e]=s.useVariables(\"histVal\");b=`\\nmemory[${i.idx}] = ${c.variable}\\n`,t&&t.inline||(b+=`;let ${e} = ${n};`),t&&t.inline&&(e=b,b=\"\"),f=e,b=d(s,b,f,c)}let v=c?l(c):[];void 0!==e&&(i.initData=new Float32Array([e])),void 0!==a&&(i.initData=new Float32Array([a]));let x=c?o(c):[];return t&&t.name&&(x=[r,...x]),{code:b,variable:f,histories:[p,...v],params:x}};return t&&(r.paramName=t.name),r.value=(e,t)=>{if(void 0===s)return;let n=void 0!==t?\"schedule-set\":\"memory-set\",r={idx:i.idx,value:e,time:t};s.postMessage({type:n,body:r}),a=e},r},l=(...e)=>e.flatMap((e=>e.histories)),o=(...e)=>e.flatMap((e=>e.params));class u{constructor(){this.memory=new a(this,4194304),this.idx=0,this.histories=0,this.numberOfInputs=1,this.sampleRate=44100,this.emittedVariables={},this.worklets=[]}alloc(e){return this.memory.alloc(e)}addWorklet(e){this.worklets.push(e)}postMessage(e){this.worklets.forEach((t=>t.port.postMessage(e)))}onMessage(e){for(let t of this.memory.blocksInUse)t.waitingForResponse===e.type&&t.respond(e.body)}isVariableEmitted(e){return!0===this.emittedVariables[e]}useVariables(...e){let t=this.idx++;return e.map((e=>`${e}${t}`))}gen(e){return\"number\"==typeof e?c(e)(this):e(this)}emit(e,t,...i){let n=l(...i),s=o(...i),a={code:d(this,e,t,...i),variable:t,histories:n,params:s},r=i.filter((e=>void 0!==e.inputs)).map((e=>e.inputs));return r.length>0&&(a.inputs=Math.max(...r)),a}input(e){return e>this.numberOfInputs&&(this.numberOfInputs=e),\"in\"+e}}class h extends u{constructor(e,t,i){super(),console.log(\"loop context called with context.idx=\",i.idx),this.context=i,this.loopIdx=e,this.loopSize=t.max-t.min,this.memory=i.memory,this.idx=i.idx,this.histories=i.histories,this.numberOfInputs=i.numberOfInputs,this.sampleRate=i.sampleRate,this.emittedVariables=Object.assign({},i.emittedVariables),this.worklets=i.worklets}useVariables(...e){let t=super.useVariables(...e);return this.context.useVariables(...e),t}isVariableEmitted(e){return!0===this.emittedVariables[e]||super.isVariableEmitted(e)}alloc(e){let t=this.memory.alloc(e*this.loopSize);return this.context,new s(this,t.idx,t.size,t.allocatedSize)}}const d=(e,t,i,...n)=>{let s=\"\";if(t.trim().startsWith(\"let\")&&e.isVariableEmitted(i))return i;e.emittedVariables[i]=!0;for(let t of n)m(t)&&(s+=t.code,e.emittedVariables[t.variable]=!0);return s+\"\\n\"+t},m=e=>e.code!==e.variable,c=e=>()=>({code:e.toString(),variable:e.toString(),histories:[],params:[]}),$=(e=0)=>t=>{let i=t.input(e);return{code:i,variable:i,histories:[],inputs:e,params:[]}},p=(...e)=>{let t=new u,i=\"\",n=\"\",s=1,a=1,r=[],l=[];for(let o of e){let e=o(t);i+=\" \"+e.code,n=e.variable,l=[...l,...e.params],e.histories&&(r=[...r,...e.histories]),void 0!==e.outputs&&e.outputs+1>s&&(s=e.outputs+1),void 0!==e.inputs&&e.inputs>a&&(a=e.inputs)}return 1===s&&(i+=`\\noutput0 = ${n};\\n`),{code:i,context:t,variable:n,histories:r,numberOfInputs:a+1,numberOfOutputs:s,params:l}},b=(e,t)=>\"number\"==typeof e?c(e)(t):e(t),f=e=>{let t,i;return n=>void 0!==t&&n==i?n.isVariableEmitted(t.variable)?Object.assign(Object.assign({},t),{code:t.variable}):t:(i=n,t=e(n),t)},accum=(e,t=0,i)=>{let n,s;return f((a=>{n=a.alloc(1),s=a;let r=b(e,a),l=b(t,a),[o]=a.useVariables(\"accum\");void 0!==i.init&&(n.initData=new Float32Array([i.init]));let u=\"number\"==typeof t&&0===t?\"\":`if (${l.variable} > 0) ${o} = ${i.min};`,h=`${i.max-i.min} + ${r.variable}`,d=!(void 0!==i.exclusive&&!i.exclusive),m=!0===d?\">=\":\">\",c=`\\nlet ${o} = memory[${n.idx}];\\n${u}\\nmemory[${n.idx}] = ${o} + ${r.variable};\\nif (memory[${n.idx}] ${m} ${i.max}) memory[${n.idx}] -= ${d?i.max-i.min:h};\\n`;return a.emit(c,o,r,l)}))},v=e=>t=>{let i=t.gen(e),n=`\\nif (${i.variable}) {\\n  break;\\n}\\n`;return t.emit(n,\"\",i)},x=(e,t,i,n)=>(...s)=>f((a=>{let r=s.map((e=>a.gen(e))),[l]=a.useVariables(t+\"Val\"),o=`let ${l} = ${r.map((e=>e.variable)).join(\" \"+e+\" \")};`;return s.every((e=>\"number\"==typeof e))&&void 0!==i?(o=`let ${l} = ${s.map((e=>e)).reduce(i,void 0===n?s[0]:n)}`,a.emit(o,l)):a.emit(o,l,...r)})),g=(e,t,i)=>(...n)=>s=>{let a=n.map((e=>s.gen(e))),[r]=s.useVariables(`${t}Val`),l=n.length>0&&n.every((e=>\"number\"==typeof e))?`let ${r} = ${i(...n)}`:`let ${r} = ${e}(${a.map((e=>e.variable)).join(\",\")});`;return s.emit(l,r,...a)},y=x(\"+\",\"add\",((e,t)=>e+t),0),w=(x(\"<<\",\"shiftLeft\",((e,t)=>e<<t),0),x(\">>\",\"shiftRight\",((e,t)=>e>>t),0),x(\"-\",\"sub\",((e,t)=>e-t))),z=x(\"*\",\"mult\",((e,t)=>e*t),1),M=x(\"/\",\"div\",((e,t)=>e/t)),V=(g(\"Math.abs\",\"abs\",Math.abs),g(\"Math.floor\",\"floor\",Math.floor),g(\"Math.ceil\",\"ceil\",Math.ceil),g(\"Math.sin\",\"sin\",Math.sin),g(\"Math.cos\",\"cos\",Math.cos)),S=g(\"Math.pow\",\"pow\",Math.pow),O=(g(\"Math.sqrt\",\"sqrt\",Math.sqrt),g(\"Math.min\",\"min\",Math.min),g(\"Math.max\",\"max\",Math.max),x(\"<\",\"lt\")),k=x(\"<=\",\"lte\"),I=x(\">\",\"gt\"),_=x(\">=\",\"gte\"),j=x(\"&&\",\"and\"),L=x(\"||\",\"or\"),P=x(\"==\",\"eq\"),T=x(\"!=\",\"neq\"),A=(x(\"%\",\"mod\",((e,t)=>e%t)),{min:0,max:1}),E=(e,t=0,i=A)=>f((n=>{let s=i.max-i.min;return accum(M(z(e,s),n.sampleRate),t,i)(n)})),R=\"this.sineTable\",cycle=(e,t=0)=>f((i=>{let n=i.gen(e),s=i.gen(t),a=((e,t,i)=>t=>{let i=t.gen(e),n=t.gen(0),s=t.gen(1),a=`${s.variable} - ${n.variable}`,[r]=t.useVariables(\"wrapVal\"),l=`\\nvar ${r} = ${i.variable};\\nif( ${r} < ${n.variable}) ${r} = 0 + ((${r} % ${a}) + ${a})%${a};\\nelse if(${r} > ${s.variable}) ${r}=  0 + ((${r} % ${a}) + ${a})%${a};\\n`;return t.emit(l,r,i,n,s)})(y(E(e),t))(i),[r,l,o,u,h]=i.useVariables(\"floatIndex\",\"frac\",\"lerp\",\"index\",\"nextIndex\"),d=`\\n${a.code}\\nlet ${r} = ${a.variable} * 1024;\\nlet ${l} = ${r} - Math.floor(${r});\\nlet ${u} = Math.floor(${r});\\nlet ${h} = ${u} + 1;\\nif (${h} >= 1024) {\\n  ${h} = 0;\\n}\\nlet ${o} = (1.0-${l})*${R}[${u}] + ${l}*${R}[${h}];\\n`;return i.emit(d,o,n,s)})),C=(e=1,t=1,i,n)=>{let s,a,r=n=>(void 0!==s&&a===n||(console.log(\"allocating with size-%s channels=%s\",e,t),s=n.alloc(e*t),s.initData=i,s.length=e,s.channels=t),a=n,s.channels=t,s.length=e,null!=i&&(s.initData=i),n.memory.blocksInUse.push(s),s);return r.get=()=>s?s.get():new Promise((e=>e(new Float32Array(1)))),r.set=e=>{s&&a&&a.postMessage({type:\"init-memory\",body:{idx:s.idx,data:e}})},r},D=(e,t,i)=>n=>{let s=n,a=e(n),r=s.gen(t),l=s.gen(i),[o,u,h,d,m,c]=s.useVariables(\"preIdx\",\"peekIdx\",\"peekVal\",\"channelIdx\",\"frac\",\"nextIdx\"),$=a.length,p=void 0===a._idx?a.idx:a._idx,b=`\\nlet ${o} = ${r.variable};\\nif (${o} > ${a.length}) ${o} -= ${a.length};\\nelse if (${o} < 0) ${o} += ${a.length};\\nlet ${d} = ${l.variable};\\nif (${d} > ${a.channels}) ${d} -= ${a.channels};\\nelse if (${d} < 0) ${d} += ${a.channels};\\nlet ${u} = ${$} * ${d} + ${o};\\nlet ${m} = ${u} - Math.floor(${u});\\nlet ${c} = Math.floor(${u}) + 1;\\nif (${c} >= ${$} * (${l.variable} + 1)) {\\n   ${c} =  ${$} * (${l.variable})\\n}\\nlet ${h} = (1 - ${m})*memory[${p} + Math.floor(${u})] + (${m})*memory[${p} + ${c}];;\\n`;return n.emit(b,h,r,l)},F=(e,t,i,n)=>s=>{let a=e(s),r=s.gen(t),l=s.gen(i),o=s.gen(n),u=`${a.length} * ${l.variable} + Math.floor(${r.variable})`,h=`\\n// begin poke\\n\\nmemory[${a._idx||a.idx} + ${u}] = ${o.variable};\\n// end poke\\n//if (this.counter < 10000)\\n//    console.log(${o.variable});\\nthis.counter++;\\n`;return s.emit(h,o.variable,r,l,o)},q=e=>{let t=r();return w(e,t(e))},U=(e,t=0)=>i=>{let n=i.alloc(1),[s]=i.useVariables(\"latchVal\"),a=i.gen(e),r=i.gen(t),l=`\\nlet ${s} = memory[${n.idx}];\\nif (${r.variable} > 0) {\\n  memory[${n.idx}] = ${a.variable};\\n  ${s} = memory[${n.idx}];\\n}\\n`;return i.emit(l,s,a,r)};const W=(e,t,i=\"Zen\",n=!1)=>new Promise((s=>{return a=void 0,r=void 0,o=function*(){let a=N(i,t);console.log(a);const r=window.URL.createObjectURL(new Blob([a],{type:\"text/javascript\"}));t.numberOfOutputs;const l=()=>{const r=new AudioWorkletNode(e,i,{channelInterpretation:\"discrete\",numberOfInputs:t.numberOfInputs,numberOfOutputs:1,channelCount:t.numberOfOutputs,outputChannelCount:[t.numberOfOutputs]});r.port.onmessage=e=>{let i=e.data.type,n=e.data.body;t.context.onMessage({type:i,body:n})};for(let e of t.context.memory.blocksInUse)void 0!==e.initData&&r.port.postMessage({type:\"init-memory\",body:{idx:void 0===e._idx?e.idx:e._idx,data:e.initData}});return t.context.addWorklet(r),n||s({code:a,workletNode:r}),r};yield e.audioWorklet.addModule(r),n?s(l):l()},new((l=void 0)||(l=Promise))((function(e,t){function i(e){try{s(o.next(e))}catch(e){t(e)}}function n(e){try{s(o.throw(e))}catch(e){t(e)}}function s(t){var s;t.done?e(t.value):(s=t.value,s instanceof l?s:new l((function(e){e(s)}))).then(i,n)}s((o=o.apply(a,r||[])).next())}));var a,r,l,o})),N=(e,t)=>`\\nclass ${e}Processor extends AudioWorkletProcessor {\\n\\n  constructor() {\\n    super();\\n    this.counter=0;\\n    this.disposed = false;\\n    this.id = \"${e}\";\\n    this.events = {};\\n    ${K(\"    \",J(t))}\\n\\n    this.createSineTable();\\n    \\n    this.port.onmessage = (e) => {\\n       if (e.data.type === \"memory-set\") {\\n         let {idx, value} = e.data.body;\\n         this.memory[idx] = value;\\n         //console.log(\"mem set idx=%s value=%s\", idx, value);\\n       } else if (e.data.type === \"schedule-set\") {\\n         let {idx, value, time} = e.data.body;\\n         this.events[idx] = {value, time};\\n         //console.log(\"scheduling idx=%s value=%s time=%s\", idx, value, time, this.events);\\n       } else if (e.data.type === \"init-memory\") {\\n         let {idx, data} = e.data.body;\\n         this.memory.set(data, idx)\\n       } else if (e.data.type === \"memory-get\") {\\n           let {idx, allocatedSize} = e.data.body;\\n           this.port.postMessage({\\n               type: \"memory-get\",\\n               body: this.memory.slice(idx, idx+allocatedSize)\\n           });\\n       } else if (e.data.type === \"dispose\") {\\n           this.disposed = true;\\n           this.memory = null;\\n       }\\n    }\\n  }\\n\\n  createSineTable() {\\n    const sineTableSize = 1024; // Choose a suitable size for the table, e.g., 4096 \\n    this.sineTable = new Float32Array(sineTableSize);\\n\\n    for (let i = 0; i < sineTableSize; i++) {\\n      this.sineTable[i] = Math.sin((2 * Math.PI * i) / sineTableSize);\\n    }\\n  }\\n\\n  scheduleEvents() {\\n      for (let idx in this.events) {\\n          let event = this.events[idx];\\n          let value = event.value;\\n          event.time--;\\n          if (event.time <= 0) {\\n             this.memory[idx] = value;\\n             \\n             //console.log('executing sched idx=%s time=%s value=%s', idx, event.time, event.value);\\n             delete this.events[idx];\\n          }\\n     }\\n  }\\n\\n  ${K(\"   \",B(t))}\\n}\\n\\nregisterProcessor(\"${e}\", ${e}Processor)\\n`,B=e=>`\\nprocess(inputs, outputs) {\\n    if (this.disposed) {\\n      return true;\\n    }\\n  let memory = this.memory;\\n\\n  // note: we need to go thru each output channel for each sample\\n  // instead of how we are doing it here... or else the histories\\n  // will get all messed up.\\n  // actually, really the whole channels concept should be removed...\\n  for (let j=0; j < outputs[0][0].length; j++) {\\n      this.scheduleEvents();\\n      ${Q(e)}\\n      ${Z(e)}\\n      ${H(e)}\\n      ${K(\"      \",e.code)}\\n      ${G(e)}\\n    }\\n  return true;\\n}\\n`,H=e=>{let t=\"\",i=[];for(let n of e.histories)i.includes(n)||(t+=K(\"      \",n)),i.push(n);return t},Q=e=>{let t=\"\";for(let i=0;i<e.numberOfInputs;i++)t+=`let in${i} = inputs[0][${i}]  ? inputs[0][${i}][j] : 0;\\n`;return t},Z=e=>{let t=\"\";for(let i=0;i<e.numberOfOutputs;i++)t+=`let output${i} = 0;`;return t},G=e=>{let t=\"\";for(let i=0;i<e.numberOfOutputs;i++)t+=`\\noutputs[0][${i}][j] = output${i};\\n`;return t},J=e=>`\\n        this.memory = new Float32Array(${e.context.memory.size});\\n        `,K=(e,t)=>t.split(\"\\n\").map((t=>e+t)).join(\"\\n\"),X=(e,t)=>i=>{let[n,s]=i.useVariables(\"i\",\"sum\"),a=\"number\"==typeof e.min&&\"number\"==typeof e.max?new h(n,e,i):i,r=i.gen(e.min),l=i.gen(e.max),o=Y(n),u=t(o)(a),d=Array.from(new Set(u.histories)),m=`\\nlet ${s} = 0;\\nfor (let ${n}=${r.variable}; ${n} < ${l.variable}; ${n}++ ) {\\n${d.join(\"\\n\")}\\n${K(\"    \",u.code)}\\n    ${s} += ${u.variable};\\n}\\n`;return i.emit(m,s)},Y=e=>t=>{let[i]=t.useVariables(\"loopIdx\"),n=`let ${i} = ${e}`;return t.emit(n,i)},ee=g(\"Math.random\",\"random\"),te=(e,t=\"hello\")=>{let i=r(e,{inline:!1,name:t}),n=i();return n.set=(e,t)=>{i.value(e,t)},n},ie=(...e)=>t=>{let i=e.map((e=>t.gen(e))),n=`\\nif (this.counter < 200000)\\nconsole.log(${i.map((e=>e.variable)).join(\",\")});\\nthis.counter++;\\n        `;return t.emit(n,i[0].variable,...i)},ne=(e,t,i,n,s)=>a=>{let r=a.gen(e),l=a.gen(t),o=a.gen(n),u=a.gen(i),h=a.gen(s),d=a.idx++,m=`scaleVal${d}`,c=`range1${d}`,$=`range2${d}`,p=`\\nlet ${c} = ${\"number\"==typeof t&&\"number\"==typeof i?i-t:`${u.variable} - ${l.variable}`};\\nlet ${$} = ${\"number\"==typeof n&&\"number\"==typeof s?s-n:`${h.variable} - ${o.variable}`};\\nlet ${m} = ${c} == 0 ? ${o.variable} : \\n    (((${r.variable} - ${l.variable}) * ${$}) / ${c}) + ${o.variable};\\n\\n`;return a.emit(p,m,r,l,u,o,h)},se=(...e)=>t=>{let i=\"/** SEQ START **/\",n=\"\",s=[],a=[];for(let r of e){if(\"function\"!=typeof r)continue;let e=r(t);a=[...a,...e.params],i+=\" \"+e.code,n=e.variable,t.emittedVariables[n]=!0,e.histories&&(s=[...s,...e.histories])}return i+=\"/** SEQ END **/\",{params:a,code:i,variable:n,histories:s}},ae=(e,t,i)=>n=>{let s=n.gen(e),a=n.gen(t),r=n.gen(i),[l]=n.useVariables(\"switch\"),o=`let ${l} = ${s.variable} ? ${a.variable} : ${r.variable}`;return n.emit(o,l,s,a,r)},re=(e,t,i)=>n=>{let s=n.gen(e),a=n.gen(t),r=n.gen(i),[l]=n.useVariables(\"switch\"),o=`let ${l} = ${s.variable} ? ${a.variable} : ${r.variable}`;return console.log(\"inline = \",o),n.emit(o,l,s,r)},le=(e,t,i)=>n=>{let s=n.gen(e),a=n.gen(t),r=n.gen(i),[l]=n.useVariables(\"switch\"),o=`let ${l} = ${s.variable} ? ${a.variable} : ${r.code}`;return n.emit(o,l,s,a)},oe=e=>f((t=>{let[i]=t.useVariables(\"t60\"),n=b(e,t),s=`\\nlet ${i} = Math.exp(-6.907755278921 / ${n.variable});\\n`;return t.emit(s,i,n)})),ue=(e=44100)=>{let t=r(),i=t(z(t(),oe(e)));return i.trigger=()=>{t.value(1)},i},he=(e,t=44100)=>{let i=r();var n,s,a;return i((n=e,s=i(),a=oe(t),y(z(s,a),z(n,w(c(1),a)))))},de=(e,t=.5)=>ae(O(e,t),ne(e,0,t,0,1),ne(e,t,1,1,0)),me=e=>ne(V(z(Math.PI,e)),1,-1,0,1);return t})()));Object.keys(zen).forEach(key => window[key] = zen[key])";


    function generateHtmlPage() public view returns (string memory) {
        return string(abi.encodePacked(
            '<!DOCTYPE html>',
            '<html lang="en">',
            '<head>',
            '<meta charset="UTF-8">',
            '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
            '<title>Music Generator</title>',
            '</head>',
            '<body>',
            '<h1>Music Generator</h1>',
            '<button onclick="generateMusic()">Generate Music</button>',
            '<script>',
            ZEN_LIBRARY,
            'function generateMusic() {',
                                           'let x = cycle(400); let y = new AudioContext(); createWorklet(y, zen(x)).then(z => z.workletNode.connect(y.destination));' 
            '  ', 
            '}',
            '</script>',
            '</body>',
            '</html>'
        ));
    }
}
