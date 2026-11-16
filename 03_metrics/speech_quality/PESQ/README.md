# PESQ (Perceptual Evaluation of Speech Quality)

## Implementation

The PESQ metric is calculated using the `python-pesq` implementation provided by vBaiCai.

**Source repository:**  
https://github.com/vBaiCai/python-pesq

**Package name:** `pypesq`

## Installation

```bash
pip install pypesq
```

## Usage

```python
import soundfile as sf
from pypesq import pesq

ref, sr = sf.read("reference.wav")
deg, sr = sf.read("degraded.wav")

score = pesq(ref, deg, sr)
print(score)
```

## Notes

- The implementation supports sampling rates of 8 kHz and 16 kHz.
- The package returns the narrowband PESQ score (NB PESQ MOS).
- The reference and degraded signals must have compatible lengths and sampling rates.

## References

- [vBaiCai/python-pesq](https://github.com/vBaiCai/python-pesq)
- [ITU-T Recommendation P.862](https://www.itu.int/rec/T-REC-P.862/en)
