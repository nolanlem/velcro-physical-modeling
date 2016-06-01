
class Velcro 
{ 
    
    //"rain" 
    Impulse velcro => LPF filter; 
    // connect 
    filter => Gain left; 
    filter => Gain right; 
} 

// drops per sec (change over time) 
40 => int N; 

// rain drops, so we can rotate around and give each time to 
// have a tail (due to the filter) before being reused for the rain drops 


// linear panning
fun void panLinear(float pan, UGen left, UGen right) 
{ 
    // clamp to bounds 
    if(pan<0) 0 =>pan; 
    else if(pan >1) 1 => pan; 
    
    //set gains 
    1-pan => left.gain; 
    pan => right.gain; 
} 

//constant power panning, expect pan = [0,1] 
fun void panPower(float pan, UGen left, UGen right)
{ 
    //clamp to bounds 
    if (pan < 0) 0 => pan; 
    else if(pan > 1) 1 => pan; 
    
    // set gains 
    Math.cos(pan *pi/2) => left.gain; 
    Math.sin(pan*pi/2) =>right.gain; 
} 

// set global vars
0 => int LINEAR; 
1 => int CONSTANTPOWER; 

//pan, which=0:linear|1:constantpower 
fun void panning(int which, float pan, UGen left, UGen right) 
{ 
    if (which == LINEAR) panLinear(pan, left, right); 
    else if(which == CONSTANTPOWER) panPower(pan, left, right); 
    else <<< "[pan]: ERROR specifying whih pan type!", "">>>; 
} 

//the drop 
fun void oneRip(Velcro rip, float lowerFreq, float upperFreq, int panType)
{
    //randomize filter 
    Math.random2f(lowerFreq, upperFreq) => rip.filter.freq; 
    //randomize pan 
    panning(panType, Math.random2f(0,1), rip.left, rip.right); 
    //fire an impulse 
    Math.random2f(0.1, 0.8) => rip.velcro.next; 
} 

//time until next event, given rate 
// (this is based on the exponential distribution, which models 
// time until next event in a poisson process - the events in this 
// model occur independently and have a rate of lambda) 
fun float timeUntilNext( float lambda) 
{ return -Math.log(1-Math.random2f(0,1)) /lambda;} 

// define the 'clip' as a function 
fun void velClip(dur myDur, int N) 
{ 
    // rain drops, so we can rotate around and give each time to 
    // have a tail (due to the filter) before being reused for the 
    // rain drop 
    Velcro rips[N]; 
    
    //reverb 
    JCRev rL => dac.left; 
    JCRev rR => dac.right; 
    // mix
    0.01 => rL.mix => rR.mix; 
    
    //connect 
    for(int i; i<rips.size(); i++){ 
        rips[i].left => rL; 
        rips[i].right => rR; 
    } 
    
    //counter 
    int counter; 
    <<<"\t clip start at ", now/second,"seconds">>>; 
    now => time myBeg; 
    myBeg + myDur => time myEnd; 
    
    while(now < myEnd){ 
        // LFO on upper freq 
        //800 + 2200*(1+Math.sin(now/second))/2 => float upperFreq;
        //800 + 100*(1+Math.sin((now/second)/2))/2 => float lowerFreq;
        
        Math.random2f(0,1000) => float lowerFreq; 
        Math.random2f(2000,4000) => float upperFreq;
        //<<<lowerFreq, upperFreq>>>;   
        //drop of rain 
        oneRip( rips[counter], lowerFreq, upperFreq, CONSTANTPOWER); 
        // increment 
        counter++; 
        //modulo by rain array size 
        rips.size() %=> counter; 
        // wait (Poisson: from 220b) 
        timeUntilNext(N)::second=> now; 
    } 
    //extra time for reverb Tails 
    200::ms => now; 
    <<<"\tclip end at", now/second, "seconds">>>; 
} 

//TIME 0, start the clip 
spork ~velClip(20::second, N); //launch clip in independent shred 

// write to a file
dac => WvOut2 out => blackhole;
me.sourceDir() + "/velcro_simulation.wav" => string _capture; _capture => out.wavFilename;


20::second=> now; // this master shred needs to remain alive while it's playing 
me.yield(); // on this exact sample, yield master shred so sporked one can finish first 
out.closeFile();


//last item in this program is this print statement 
<<<"program end at", now/second, "seconds">>>; 
// and with nothign left to do this program exits 

    
    
