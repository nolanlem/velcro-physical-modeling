


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


(
SynthDef(\mytrig, {|sinfreq=400, impfreq = 10, gate = 0, doneAction=0, out = 0, mul=0.3|
	var hostsin = SinOsc.ar(sinfreq,0,mul:mul);
	var imp = Impulse.kr(impfreq);
	var trig = Trig1.kr(imp, 0.01);
	//var myenv = Env.new([ 0.001, 1, 0.5, 0 ], [ 0.01, 0.3, 1 ], -4, 2, nil);
	var myenv = Env.perc(0.01, 0.01);
	//var linenv = Env.linen(0.01, 10, 10);
	var gen = [EnvGen.kr(myenv,trig,doneAction:0)*hostsin];
	Out.ar(out, [gen,gen]);
}).send(s);
)


a = Synth(\mytrig);
a.set(\freq, 10);

(

)

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