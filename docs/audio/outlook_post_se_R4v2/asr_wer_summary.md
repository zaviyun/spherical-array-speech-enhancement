# ASR summary (outlook experiment)

- Array radius: **R = 4.2 cm**
- ASR: **WeNet 2.0**
- Scope: **illustrative outlook** — not a manuscript table

Single-channel SE backends: **ESPnet**, **MP-SENet**, **DB-AIAT**, **DB-CPT**  
(each applied once to a noisy reverberant mic and once to the **proposed** output).

## Observation

After the proposed front-end, phase-robust backends (**DB-AIAT**, **DB-CPT**) yield hypotheses much closer to the reference than when the same backends see the raw noisy mic — though residual recognition errors remain.

## Reference

> SOMETHING ELSE DISTRACTED HIM YET THERE WAS NO SOUND ONLY TOMB-LIKE SILENCE

## WeNet hypotheses

| Condition | Hypothesis |
|---|---|
| Clean reference | SOMETHING ELSE DISTRACTED HIM YET THERE WAS NO SOUND ONLY TOMB-LIKE SILENCE |
| Noisy reverberant mic | SOMETHING ELSE DISTRACTED HIM THAT THERE WAS NO SOUND ONLY TWO LIKE SILENCE |
| Proposed output | SOMETHING ELSE DISTRACTED HIM YET THERE WAS NO SOUND ONLY TOMB-LIKE SILENCE |
| ESPnet on noisy | SOMETHING ELSE IS STRATEGY SAY THERE ONLY TWO NICE |
| ESPnet on proposed | SOMETHING ELSE DISTRACTED HIM YET THERE WAS NO SOUND ONLY TWO LIKE SILENCE |
| MP-SENet on noisy | ------------------------------------------------------------------------------- |
| MP-SENet on proposed | SOMETHING ELSE DRAFTED YET THERE WAS NO SOUND OF TUNE LIFE FUN |
| DB-AIAT on noisy | SO ELSE STRA YEAH TO MY SIDE |
| DB-AIAT on proposed | SOMETHING ELSE DISTRACTED HIM YET THERE WAS NO SOUND ONLY TOO LIKE SILENCE |
| DB-CPT on noisy | BUT I LIVING A STATIC AND DEAD NOSE UP ON TWO LIFES |
| DB-CPT on proposed | SOMETHING ELSE DISTRACTED HIM YET THERE WAS NO SOUND ONLY TOO LIKE SILENCE |

Plain-text copies: [`transcripts/`](transcripts/) · waveforms: [`./`](./)
