# ASR / WER summary (outlook experiment)

- Array radius: **R = 4.2 cm**
- ASR: **WeNet 2.0** (same stack as the paper WER evaluation)
- Scope: **illustrative outlook** — not a manuscript table

## WER (%)

Fill the numbers from your WeNet runs:

| Input to ASR | No extra SE | + ESPnet | + MP-SENet | + DB-AIAT | + DB-CPT |
|---|---:|---:|---:|---:|---:|
| Clean reference | SOMETHING ELSE DISTRACTED HIM YET THERE WAS NO SOUND ONLY TOMB LIKE SILENCE 
|  |  |  |  |
| Noisy reverberant mic | SOMETHING ELSE DISTRACTED HIM THAT THERE WAS NO SOUND ONLY TWO LIKE SILENCE
 | SOMETHING ELSE IS STRATEGY SAY THERE ONLY TWO NICE
  | -------------------------------------------------------------------------------
   | SO ELSE STRA YEAH TO MY SIDE
    | BUT I LIVING A STATIC AND DEAD NOSE UP ON TWO LIFES
     |
| **Proposed output** | SOMETHING ELSE DISTRACTED HIM YET THERE WAS NO SOUND ONLY TOMB-LIKE SILENCE
 | SOMETHING ELSE DISTRACTED HIM YET THERE WAS NO SOUND ONLY TWO LIKE SILENCE
  | SOMETHING ELSE DRAFTED YET THERE WAS NO SOUND OF TUNE LIFE FUN
   | SOMETHING ELSE DISTRACTED HIM YET THERE WAS NO SOUND ONLY TOO LIKE SILENCE
    | SOMETHING ELSE DISTRACTED HIM YET THERE WAS NO SOUND ONLY TOO LIKE SILENCE
     |

> Note from author experiments: **DB-AIAT** and **DB-CPT** (phase-robust) worked particularly well on top of the proposed front-end, but WER did not reach zero.

## Transcripts

Put plain-text ASR hypotheses here (UTF-8):

```text
transcripts/reference.txt
transcripts/noisy_reverb_mic.txt
transcripts/proposed_output.txt
transcripts/se_ESPnet_on_noisy.txt
transcripts/se_ESPnet_on_proposed.txt
transcripts/se_MP-SENet_on_noisy.txt
transcripts/se_MP-SENet_on_proposed.txt
transcripts/se_DB-AIAT_on_noisy.txt
transcripts/se_DB-AIAT_on_proposed.txt
transcripts/se_DB-CPT_on_noisy.txt
transcripts/se_DB-CPT_on_proposed.txt
```

One utterance per file is enough for this demo (the schematic example).
