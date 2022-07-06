# Velcro Physical Modeling Simulations

This is a repo that applies a few different techniques to the real-time physical modeling of the velcro (aka "hook and loop fastener") ripping sound using SuperCollider and ChuCK for audio synthesis. 


Velvet Noise
+ used often in order to improve coloration in artificial reverb in room acoustics by convolving source signals with room impulse responses (RIRs). It sounds smoother than gaussian random noise and is more computationally efficient to convolve an arbitrary signal with white noise. 
+ randomly triggered impulse train in which the sign is chosen quasi randomly to be positive or negative. Pulse density ($N_d$, number of impulses per second) is a function of the average distance between impulses $T_d$. 

$$ T_d = {f_s \over N_d} $$

impulse locations, k(m) are 

$$ k(m) = {round[m*T_d + r_1 (m)(T_d-1)]} $$ 

to create governing equation for velvet-noise sequence:

$$ s(n) = {2 round [r_2 (m)] - 1}, when {n = k(m)} $$



