


~y = Bus.control(s, 1);

(
SynthDef(\mysynth, {|freq|
	var son = Impulse.ar(freq);
	Out.ar(0, son);
}).send(s);
)

x = Synth(\mysynth);
s.queryAllNodes;


(
~act = {Impulse.ar(In.kr(~y.index,1))};
~y.set(10);
~act.play;
)

~y.set(5);


// SETUP
//designate control busses for converging impulse freqs
(
~maxnum = 20;
~grainsynth = Array.newClear(~maxnum);
~impbus = Array.newClear(~maxnum);
for(0,19,{|i|
	~impbus[i] = Bus.control(s,1);
});
)

// synt
(
SynthDef(\mytrig, {|sinfreq=400, impfreq = 10, gate = 0, doneAction=0, out = 0, mul=0.3, impbus|
	var hostsin = SinOsc.ar(sinfreq,0,mul:mul);
	var imp = Impulse.kr(In.kr(impbus,1));
	var trig = Trig1.kr(imp, 0.01);
	//var myenv = Env.new([ 0.001, 1, 0.5, 0 ], [ 0.01, 0.3, 1 ], -4, 2, nil);
	var myenv = Env.perc(0.01, 0.01);
	//var linenv = Env.linen(0.01, 10, 10);
	var gen = [EnvGen.kr(myenv,trig,doneAction:0, timeScale: 0)*hostsin];
	Out.ar(out, [gen,gen]);
}).send(s);
)


(
SynthDef(\singletrig, {|sinfreq=400, impfreq = 10, gate = 0, doneAction, out = 0, mul=0.3, impbus|
	var hostsin = SinOsc.ar(sinfreq,0,mul:mul);
	var myenv = Env.perc(0.01, 0.1);
	var gen = EnvGen.kr(myenv,doneAction:2)*hostsin;
	Out.ar(out, gen);
}).add;
)

Synth(\singletrig);
//// start synth 1
(
~grainsynth[0] = Synth(\mytrig);
~grainsynth[0].set(\impbus, ~impbus[0].index);

{
	var myenv = XLine.kr(1,2,10);
	Out.kr(~impbus[0].index, myenv)}.play;
)

//// start synth2
(
~grainsynth[1] = Synth(\mytrig);
~grainsynth[1].set(\sinfreq, 500);
~grainsynth[1].set(\impbus, ~impbus[1].index);
{
	var myenv = XLine.kr(1,2,10);
	Out.kr(~impbus[1].index, myenv)}.play;
)

/// start synth 3
(
~grainsynth[2] = Synth(\mytrig);
~grainsynth[2].set(\sinfreq, 600);
~grainsynth[2].set(\impbus, ~impbus[2].index);
{
	var myenv = XLine.kr(1,2,10);
	Out.kr(~impbus[2].index, myenv)}.play;
)

~grainsynth[2].free;

(
Pbindef(\synth1, \instrument, \singletrig).play;
Pbindef(\synth1,
	\sinfreq, 400,
	\impfreq, 1,
	\mul, 0.5,
	\dur, 1
);

p.play;
)
s.queryAllNodes;
(
~p1 = Pbindef(\synth2,
	\instrument, \singletrig,
	\sinfreq, 1000,
	\impfreq, 30,
	\mul, 0.5,
	\dur, 0.23,
	\quant, 10
);
~p1.play;
)

PPar
(
~p1 = Pbindef(\mysynth,\instrument, \singletrig, \dur, 1, \sinfreq, 400, \dur, 0.1);
~p2 = Pbindef(\mysynth,\instrument, \singletrig, \dur, 1, \sinfreq, 500, \dur, 0.3);
~p1.play(Quant: [2, 0, 0]);
~p2.play(Quant: [2, 0, 0]);
)
~p1.free;
~p1 = Pbindef(\mysynth, \dur, 0.3);
s.queryAllNodes;

Pbindef(\synth1, \dur, 0.5);
Pbindef(\synth2, \dur, 0.5);










(

a = Array.newClear(~maxnum);

for(0,~maxnum-1,{|i|
	a[i] = Synth(\mytrig);
	a[i].set(\mul, 2.0/~maxnum);
	a[i].set(\sinfreq, rrand(300,900));
	a[i].set(\impfreq, exprand(6,20));
} )
)

(
~target = 10;
for(0, ~maxnum-1, {|i|
	a[i].get(\impfreq, {arg value;
		var temp = value;
	});


a[0].get(\sinfreq, {arg value; value.postln;});



(
a = Synth(\mytrig);
a.set(\sinfreq, 400);
)
a.set(\sinfreq, 400);
a.set(\mul, 0.5);

(
b = Synth(\mytrig);
b.set(\sinfreq, 500);
)
b.set(\impfreq, 7);

(
c = Synth(\mytrig);
c.set(\sinfreq, 600);
c.set(\impfreq, 5.5);
)