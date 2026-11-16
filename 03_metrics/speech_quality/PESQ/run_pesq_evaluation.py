from pathlib import Path
import csv
import time

import numpy as np
import soundfile as sf
from pypesq import pesq


# ============================================================
# Configuration
# ============================================================

# Project directories
PROJECT_ROOT = Path(__file__).resolve().parents[3]

# Reference and degraded speech directories
REFERENCE_DIR = PROJECT_ROOT / "data" / "clean"
DEGRADED_DIR = PROJECT_ROOT / "data" / "enhanced"

# Evaluation settings
NUM_SPEAKERS = 20
NUM_UTTERANCES = 10
SPEAKER_TYPES = ["F", "M"]

# Noise level
SNR_VALUE = 10

# Expected sampling rate
SAMPLE_RATE = 16000

# Results directory
RESULTS_DIR = (
    PROJECT_ROOT
    / "results"
    / "evaluation"
    / "speech_quality"
    / "PESQ"
)

RESULTS_DIR.mkdir(parents=True, exist_ok=True)


# ============================================================
# Evaluation Scenarios
# ============================================================

SCENARIOS = {
    "Noise": {
        "pattern": "{speaker}{i}_{j} Noisy {snr} (dB).wav"
    },

    "Reverberation": {
        "pattern": "{speaker}{i}_{j}_Microphone (18) Output.wav"
    },

    "Reverberation_Noise": {
        "pattern": (
            "{speaker}{i}_{j}_Microphone (18) "
            "Noisy Output_{snr}(dB).wav"
        )
    }
}


# ============================================================
# Helper Functions
# ============================================================

def load_audio(file_path):
    """Load and preprocess a mono speech recording."""

    signal, sample_rate = sf.read(file_path)

    if signal.ndim != 1:
        raise ValueError(
            f"Expected mono audio, but received {signal.ndim} "
            f"dimensions: {file_path}"
        )

    if sample_rate != SAMPLE_RATE:
        raise ValueError(
            f"Unexpected sample rate {sample_rate} Hz "
            f"(expected {SAMPLE_RATE} Hz): {file_path}"
        )

    signal = signal.astype(np.float64)

    # Remove DC offset
    signal = signal - np.mean(signal)

    # Peak normalization
    peak = np.max(np.abs(signal))

    if peak < 1e-12:
        raise ValueError(f"Silent or zero-valued audio: {file_path}")

    signal = signal / peak

    return signal, sample_rate


def calculate_pesq(reference, degraded, sample_rate):
    """Calculate narrowband PESQ using pypesq."""

    # Make both signals equal in length
    common_length = min(len(reference), len(degraded))

    reference = reference[:common_length]
    degraded = degraded[:common_length]

    if common_length == 0:
        raise ValueError("The input signals are empty.")

    return float(pesq(reference, degraded, sample_rate))


# ============================================================
# Main Evaluation
# ============================================================

start_time = time.time()

all_summary = []

for scenario_name, scenario_config in SCENARIOS.items():

    print(f"\n========== {scenario_name} PESQ Evaluation ==========")

    output_pattern = scenario_config["pattern"]

    scores = []
    result_rows = []

    for speaker_type in SPEAKER_TYPES:

        for i in range(1, NUM_SPEAKERS + 1):

            for j in range(1, NUM_UTTERANCES + 1):

                # Reference filename
                reference_name = f"{speaker_type}{i}_{j}.WAV"

                # Degraded filename
                degraded_name = output_pattern.format(
                    speaker=speaker_type,
                    i=i,
                    j=j,
                    snr=SNR_VALUE
                )

                reference_path = REFERENCE_DIR / reference_name
                degraded_path = DEGRADED_DIR / degraded_name

                # Check file existence
                if not reference_path.is_file():
                    raise FileNotFoundError(
                        f"Reference file not found: {reference_path}"
                    )

                if not degraded_path.is_file():
                    raise FileNotFoundError(
                        f"Degraded file not found: {degraded_path}"
                    )

                print(f"Processing: {degraded_name}")

                # Load and preprocess signals
                reference, sr_ref = load_audio(reference_path)
                degraded, sr_deg = load_audio(degraded_path)

                if sr_ref != sr_deg:
                    raise ValueError(
                        f"Sampling rate mismatch: "
                        f"{reference_name} and {degraded_name}"
                    )

                # Calculate PESQ
                score = calculate_pesq(
                    reference,
                    degraded,
                    sr_ref
                )

                scores.append(score)

                result_rows.append({
                    "Reference": reference_name,
                    "Degraded": degraded_name,
                    "PESQ": score
                })

    # --------------------------------------------------------
    # Statistical Summary
    # --------------------------------------------------------

    scores = np.asarray(scores, dtype=np.float64)

    avg_score = float(np.mean(scores))
    max_score = float(np.max(scores))
    min_score = float(np.min(scores))

    print(f"\n{scenario_name} Results:")
    print(f"Number of samples: {len(scores)}")
    print(f"Average PESQ: {avg_score:.4f}")
    print(f"Maximum PESQ: {max_score:.4f}")
    print(f"Minimum PESQ: {min_score:.4f}")

    # --------------------------------------------------------
    # Save Individual Results
    # --------------------------------------------------------

    results_file = RESULTS_DIR / f"PESQ_{scenario_name}_results.csv"

    with open(results_file, "w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(
            file,
            fieldnames=["Reference", "Degraded", "PESQ"]
        )
        writer.writeheader()
        writer.writerows(result_rows)

    # --------------------------------------------------------
    # Save Scenario Summary
    # --------------------------------------------------------

    all_summary.append({
        "Scenario": scenario_name,
        "Number_of_Samples": len(scores),
        "Average_PESQ": avg_score,
        "Maximum_PESQ": max_score,
        "Minimum_PESQ": min_score
    })


# ============================================================
# Save Combined Summary
# ============================================================

summary_file = RESULTS_DIR / "PESQ_summary.csv"

with open(summary_file, "w", newline="", encoding="utf-8") as file:
    writer = csv.DictWriter(
        file,
        fieldnames=[
            "Scenario",
            "Number_of_Samples",
            "Average_PESQ",
            "Maximum_PESQ",
            "Minimum_PESQ"
        ]
    )
    writer.writeheader()
    writer.writerows(all_summary)


# ============================================================
# Final Report
# ============================================================

print("\n========== Final PESQ Summary ==========")

for result in all_summary:
    print(
        f"{result['Scenario']}: "
        f"Average = {result['Average_PESQ']:.4f}, "
        f"Maximum = {result['Maximum_PESQ']:.4f}, "
        f"Minimum = {result['Minimum_PESQ']:.4f}"
    )

print(f"\nResults saved in: {RESULTS_DIR}")
print(f"Elapsed time: {time.time() - start_time:.2f} seconds")