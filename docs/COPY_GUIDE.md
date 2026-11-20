# راهنمای کپی فایل‌ها / Media Copy Guide

فایل‌های خود را **با همین نام‌ها** در پوشه‌های زیر بریزید.  
اگر پسوندتان فرق دارد (`jpg` / `png` / `gif` / `mp4`)، همان پسوند واقعی را نگه دارید و به من بگویید تا مسیرها را در `demo.md` و `README` هماهنگ کنم.

> Prefer **GIF** for animations, **PNG** for still figures. Keep each GIF under ~5–8 MB if possible.

---

## 1) سناریوی آزمایش

| فایل شما | کپی در |
|---|---|
| عکس سناریو (اتاق / منبع / آرایه) | `docs/figures/01_scenario/scenario_room_array_source.png` |

---

## 2) هندسه آرایه و حلقه‌های مجازی

| فایل شما | کپی در |
|---|---|
| گیف ۳۲ میکروفون فیزیکی روی کره، R=4.2 cm | `docs/figures/02_array_geometry/physical_32mics_R4v2.gif` |
| حلقه‌های مجازی R=4.2 cm **بدون** upsampling | `docs/figures/02_array_geometry/virtual_rings_R4v2_no_upsample.png` |
| حلقه‌های مجازی R=4.2 cm **با** upsampling | `docs/figures/02_array_geometry/virtual_rings_R4v2_upsample.png` |
| حلقه‌های مجازی R=10 cm **بدون** upsampling | `docs/figures/02_array_geometry/virtual_rings_R10_no_upsample.png` |
| حلقه‌های مجازی R=10 cm **با** upsampling | `docs/figures/02_array_geometry/virtual_rings_R10_upsample.png` |

---

## 3) بیم‌پترن تک‌میکروفون (۰–۴۰۰۰ Hz ، R=4.2 cm)

| فایل شما | کپی در |
|---|---|
| فیزیکی — ۲بعدی | `docs/figures/03_beampattern_single/physical_mic_2d_R4v2.gif` |
| فیزیکی — ۳بعدی | `docs/figures/03_beampattern_single/physical_mic_3d_R4v2.gif` |
| مجازی روی حلقه — ۲بعدی | `docs/figures/03_beampattern_single/virtual_mic_on_ring_2d_R4v2.gif` |
| مجازی روی حلقه — ۳بعدی | `docs/figures/03_beampattern_single/virtual_mic_on_ring_3d_R4v2.gif` |

---

## 4) بیم‌پترن بعد از Delay-and-Sum روی حلقه (R=4.2 cm)

| فایل شما | کپی در |
|---|---|
| حلقه ۲ — ۲بعدی | `docs/figures/04_beampattern_ring_ds/ring2_ds_2d_R4v2.gif` |
| حلقه ۲ — ۳بعدی | `docs/figures/04_beampattern_ring_ds/ring2_ds_3d_R4v2.gif` |
| حلقه ۳ — ۲بعدی | `docs/figures/04_beampattern_ring_ds/ring3_ds_2d_R4v2.gif` |
| حلقه ۳ — ۳بعدی | `docs/figures/04_beampattern_ring_ds/ring3_ds_3d_R4v2.gif` |

---

## 5) مقایسه متدها (۰–۴۰۰۰ Hz ، R=4.2 cm)

| فایل شما | کپی در |
|---|---|
| USMA-DS ۲بعدی / ۳بعدی | `docs/figures/05_beampattern_methods/USMA_DS_2d_R4v2.gif` و `USMA_DS_3d_R4v2.gif` |
| USMA-SD ۲بعدی / ۳بعدی | `docs/figures/05_beampattern_methods/USMA_SD_2d_R4v2.gif` و `USMA_SD_3d_R4v2.gif` |
| USMA-WPE-BF ۲بعدی / ۳بعدی | `docs/figures/05_beampattern_methods/USMA_WPE_BF_2d_R4v2.gif` و `USMA_WPE_BF_3d_R4v2.gif` |
| Proposed ۲بعدی / ۳بعدی | `docs/figures/05_beampattern_methods/Proposed_2d_R4v2.gif` و `Proposed_3d_R4v2.gif` |

---

## 6) چشم‌انداز / کارهای آینده (نه نتایج مقاله)

| فایل شما | کپی در |
|---|---|
| جداسازی منابع با حلقه‌های موازی | `docs/figures/06_outlook/source_separation_parallel_rings.gif` |
| ردیابی/مکان‌یابی پهپاد بدون چرخش رادار | `docs/figures/06_outlook/drone_tracking_outlook.gif` |
| شماتیک پاورپوینت: Proposed → single-channel SE (R=4.2) | `docs/figures/06_outlook/post_se_cascade_concept.png` |
| ویدیو/گیف: Proposed → zero-shot TTS / voice cloning | `docs/figures/06_outlook/post_tts_voice_cloning_concept.gif` |

برای مورد آخر: اگر کلیپ کوتاه است (**ترجیحاً GIF** تا مثل بقیه در گالری دیده شود). اگر طولانی/سنگین است همان `.mp4` بگذارید با همین نام پایه (`post_tts_voice_cloning_concept.mp4`) و بگویید تا لینک را در `demo.md` عوض کنم.

> این بخش **potential future applications** است، نه نتیجهٔ جدول‌های مقاله.

### 6b) صوت + ASR برای post-SE (فقط R = 4.2 cm)

روش‌های تک‌کاناله تست‌شده: **ESPnet**, **MP-SENet**, **DB-AIAT**, **DB-CPT**  
(یک‌بار روی mic نویزی‌+واخنش، یک‌بار روی خروجی Proposed؛ WER با WeNet 2.0)

#### صوت‌ها → `docs/audio/outlook_post_se_R4v2/`

| فایل | معنی |
|---|---|
| `01_clean_reference.wav` | سیگنال تمیز |
| `02_noisy_reverb_mic.wav` | یک میکروفون فیزیکی، نویزی+واخنش |
| `03_proposed_output.wav` | خروجی روش پیشنهادی |
| `se_ESPnet_on_noisy.wav` | ESPnet روی noisy |
| `se_ESPnet_on_proposed.wav` | ESPnet روی Proposed |
| `se_MP-SENet_on_noisy.wav` | MP-SENet روی noisy |
| `se_MP-SENet_on_proposed.wav` | MP-SENet روی Proposed |
| `se_DB-AIAT_on_noisy.wav` | DB-AIAT روی noisy |
| `se_DB-AIAT_on_proposed.wav` | DB-AIAT روی Proposed |
| `se_DB-CPT_on_noisy.wav` | DB-CPT روی noisy |
| `se_DB-CPT_on_proposed.wav` | DB-CPT روی Proposed |

#### متن ASR + WER

| فایل | معنی |
|---|---|
| `docs/audio/outlook_post_se_R4v2/asr_wer_summary.md` | جدول WER را اینجا پر کنید |
| `docs/audio/outlook_post_se_R4v2/transcripts/reference.txt` | متن مرجع (ground truth) |
| `.../transcripts/noisy_reverb_mic.txt` | فرضیه‌ی ASR برای noisy |
| `.../transcripts/proposed_output.txt` | فرضیه برای Proposed |
| `.../transcripts/se_ESPnet_on_noisy.txt` | و به همین ترتیب برای بقیه |
| `.../transcripts/se_ESPnet_on_proposed.txt` | |
| `.../transcripts/se_MP-SENet_on_noisy.txt` | |
| `.../transcripts/se_MP-SENet_on_proposed.txt` | |
| `.../transcripts/se_DB-AIAT_on_noisy.txt` | |
| `.../transcripts/se_DB-AIAT_on_proposed.txt` | |
| `.../transcripts/se_DB-CPT_on_noisy.txt` | |
| `.../transcripts/se_DB-CPT_on_proposed.txt` | |

هر `.txt` فقط همان متن تشخیص‌داده‌شدهٔ WeNet باشد (یک خط یا چند خط ساده).

---

## 7) صوت‌های اصلی مقاله (جداول)

از همین مسیرها استفاده می‌شود (کپی اضافه لازم نیست):

```text
05_results/<METHOD>/radius_4_2cm/{before,after}.wav
05_results/<METHOD>/radius_10cm/{before,after}.wav
```

---

## بعد از کپی

1. در GitHub Desktop فایل‌های جدید را می‌بینید  
2. Commit (نمونه پیام‌ها پایین)  
3. Push origin  

### پیام commit پیشنهادی (Outlook جدید)

```text
Add outlook post-SE cascade demos with ESPnet/MP-SENet/DB-AIAT/DB-CPT and ASR texts
```

اگر نام فایلی دقیقاً جور نبود، بگویید تا مسیرها را هماهنگ کنم.
