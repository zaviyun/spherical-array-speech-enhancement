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

> این بخش را در متن‌ها به‌عنوان **potential future applications** مشخص کرده‌ایم، نه نتیجهٔ آزمایش مقاله.

---

## 7) صوت‌ها

نیازی به کپی دوباره نیست. از مسیرهای موجود استفاده می‌شود:

```text
05_results/<METHOD>/radius_4_2cm/{before,after}.wav
05_results/<METHOD>/radius_10cm/{before,after}.wav
```

اگر نمونهٔ خاص سناریو دارید، بگذارید در:

```text
docs/audio/scenario_demo/
```

(در صورت نیاز آن پوشه را هم می‌سازیم.)

---

## بعد از کپی

1. در GitHub Desktop فایل‌های جدید را می‌بینید  
2. Commit با پیام مثلاً: `Add demo figures and gallery media`  
3. Push origin  

اگر نام فایلی دقیقاً جور نبود، همان را بگویید تا مسیرها را برایتان اصلاح کنم.
