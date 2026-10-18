// Paper plan with draft figures: gauge, GPM and GSMaP precipitation in a sparse-gauge mountain area.
// Compile from the repository root:  typst compile paper/paper_plan.typ
// Figures are copies of the `--gpm-gsmap` outputs of scripts/plot_heavy_rain_events.py,
// scripts/plot_satellite_temporal_evaluation.py and scripts/plot_gauge_satellite_fusion.py.
// Numbers are read from the CSVs beside those figures in output/.
// Structure follows Journal of Hydrology (IMRaD); Methods and Results have one subsection per scientific problem.

#set document(
  title: "Paper plan: satellite precipitation and gauge fusion (GPM, GSMaP)",
  date: datetime(year: 2026, month: 10, day: 13),
)
#set page(
  paper: "a4",
  margin: (x: 2.1cm, top: 2.3cm, bottom: 2.2cm),
  numbering: "1",
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 8pt, fill: luma(110))
      Paper plan with draft figures — GPM and GSMaP
      #h(1fr) 13 October 2026
    ]
  },
)
#set text(font: ("Libertinus Serif", "New Computer Modern"), size: 10.5pt, lang: "en")
#set par(justify: true, leading: 0.62em, spacing: 1.05em)
#set heading(numbering: "1.1")
#show heading: set text(font: ("Segoe UI", "Arial"), weight: "semibold")
#show heading.where(level: 1): it => { v(0.6em); it; v(0.25em) }
// Captions carry their planned paper numbers ("Draft Fig. 3"), so Typst adds none of its own.
#set figure(numbering: none)
#show figure.caption: set text(size: 9pt)
#show figure.where(kind: table): set figure.caption(position: top)
#show table.cell: set text(size: 8.5pt)
#show table: set par(justify: false)
#set list(indent: 0.6em)
#set enum(indent: 0.6em)

#let note(body) = block(width: 100%, inset: (x: 10pt, y: 8pt), radius: 3pt, fill: luma(246),
  stroke: (left: 2.5pt + rgb("#2a78d6")), body)
#let rule = table.hline(stroke: 0.8pt)
#let thin = table.hline(stroke: 0.4pt)
// The problem a Results subsection answers, stated before its figures.
#let answers(body) = block(width: 100%, inset: (x: 8pt, y: 6pt), fill: luma(246), [*Problem answered.* #body])
#let todo(body) = text(fill: rgb("#b4451f"))[\[#body\]]

#align(center)[
  #text(size: 17pt, weight: "semibold", font: ("Segoe UI", "Arial"))[Paper plan with draft figures]
  #v(0.2em)
  #text(size: 11.5pt, fill: luma(60))[Can GPM and GSMaP stand in for gauges where the network is sparse, and what does fusing the two gain?]
]

#note[
  *Scope.* This plan covers two satellite products, GPM IMERG and GSMaP. FY4B is left out of the paper:
  on FY4B's own hours it scores worst even when no product is gauge-calibrated (hourly r 0.23 vs
  0.37–0.43, areal-mean r 0.43 vs 0.66–0.83, wet-hour detection 0.34 vs 0.64–0.66).
  The paper is organised around one core problem and three scientific problems derived from it (table
  below). Methods (Section 3) and Results (Section 4) each have one subsection per problem; interpretation is
  kept for the Discussion (Section 5). Eight figures are planned: five are shown as drafts built from finished
  analyses (Figs. 2, 3, 4, 6, 7), the other three are summarised in the text.
]

#figure(
  table(
    columns: (auto, 1.25fr, 1.5fr, auto, auto),
    align: (left, left, left, left, left),
    stroke: none,
    rule,
    table.header([], [*Scientific problem*], [*Research content*], [*Sections*], [*Figures*]),
    thin,
    [*Core*], table.cell(colspan: 4)[Can satellite precipitation stand in for gauges in a sparse mountain
      network at the hourly scale that flood forecasting needs, and how should the two be fused?],
    thin,
    [*P1*], [Spatial fidelity: does the satellite field reproduce _where_ heavy rain falls?],
    [Selection of six heavy-rain events; event-scale spatial scores of 24 h totals at the gauges],
    [3.1, 4.1, 5.1], [2, 3],
    [*P2*], [Intensity-dependent temporal error: does it reproduce _how rain evolves in time_ at each intensity?],
    [Hourly skill by intensity class × season × landform region; rain-event detection, timing and volume],
    [3.2, 4.2, 5.1], [4, 5],
    [*P3*], [Fusion: what does fusing gauges with the satellite gain, where, and with which method and anchor?],
    [Gauge-only interpolators; GWR-family fusion and blends; merged anchor; spatial cross-validation],
    [3.3–3.4, 4.3–4.4, 5.2–5.3], [6, 7, 8, Table],
    rule,
  ),
  caption: [From the core problem to the chapters. Fig. 1 (study area) serves all three problems.],
)

= Introduction

Planned as five paragraphs, one bullet each. Citations are not yet collected and are marked
#todo[ref needed]; none will be added without a verified source.

+ *Motivation.* Hourly rainfall drives flood forecasting in small mountain catchments, and gauge networks
  there are sparse. #todo[ref needed]
+ *What satellites offer.* GPM IMERG and GSMaP give full spatial coverage at 0.1° and hourly steps, with known
  weaknesses at high intensity, in complex terrain and in winter. #todo[ref needed]
+ *What fusion offers.* Gauge-only interpolation and gauge–satellite merging (residual correction, GWR-family
  models) are established, but are usually scored on all hours pooled. #todo[ref needed]
+ *Gap.* Spatial fidelity in heavy-rain events, intensity-dependent temporal error and the gain from fusion
  are rarely evaluated together, on the same gauges and against held-out gauges, for the moderate and heavy
  rain that matters for floods. #todo[to confirm against the literature]
+ *Core problem, P1–P3 and contributions.* State the core problem and the three problems in the table above,
  then the contributions: an event-scale spatial diagnosis, an intensity-stratified temporal diagnosis, and a
  held-out comparison of interpolation and fusion methods and of the anchor product.

= Study area and data

== Study area
The 237 gauges sit in hills and mountains in the Shiyan study area; none is on a plain. By local relief, 129
gauges are below 500 m, 97 are at 500–1000 m and 11 are at 1000 m or more (too few to interpret alone).
Fig. 1 will be a map with relief, gauges, a location inset and river basins.

== Rain gauges
237 hourly gauges, 2022–2024. The data are quantised to 0.5 mm. Days run 08–08 Beijing time (BJT).

== Satellite products
GPM IMERG and GSMaP hourly at 0.1°, sampled at the gauge pixels, for 2022–2024. The versions are not
equally gauge-adjusted: GPM is IMERG V07 Final, which is calibrated monthly to GPCC gauge totals, while GSMaP
is v8 operational `hourlyPrecipRate`, which has no gauge correction. FY4B AGRI L2 QPE is also uncorrected; it
is excluded from the paper for the reasons in the scope note.

== Terrain and landform regions
Local relief from the Copernicus GLO-30 DEM defines the landform regions (below 500 m, 500–1000 m,
1000 m or more).

= Methods

== Heavy-rain events and spatial scores (P1)
Heavy-rain days are 08–08 days on which more than three gauges exceed 50 mm. Of 56 such days, six are
selected, one per rain system: four widespread and two localized. At each gauge, the satellite 24 h total
is compared with the gauge total, using spatial correlation, spatial CV ratio, rain-centre shift, mean bias,
RMSE and CSI at 50 mm.

== Intensity-stratified hourly and event evaluation (P2)
Only gauge-wet hours are scored; no-rain hours are excluded. The hourly intensity classes are 0.1–2, 2–4,
4–8, 8–20 and ≥ 20 mm h⁻¹. Results are stratified by season (MAM, JJA, SON, DJF) and by landform region.
Rain events are separated by at least 3 dry hours and are scored for detection, timing and volume. An
areal-mean series is compared hourly and daily.

== Gauge-only interpolation and gauge–satellite fusion (P3)
Gauge-only interpolators are IDW, ADW, TPS and GWR. Fusion methods use the satellite as an anchor (residual
GWR, mixed GWR, MGWR), optionally blended with ADW where the satellite reports rain, either directly or by
an agreement blend. A merged anchor combines the products by OLS.

== Validation and significance
Every method is scored at gauges held out of the fit, using balanced spatial 5-fold cross-validation over
13,471 hours. Intervals are 95% day-block bootstrap intervals; differences against ADW are tested across all
cells of a comparison with Holm adjustment.

= Results

== Where heavy rain falls (P1)
#answers[Both products place heavy rain about equally well, but differ sharply in amount, and both miss the
cores of localized storms.]

#figure(
  image("figures/fig02_event_maps.png", width: 100%),
  caption: [Draft Fig. 2. The six heavy-rain events (columns). (a) Gauge 24 h totals (08–08 BJT).
  (b, c) Satellite minus gauge at each gauge, from the pixel sampled there; red means the satellite is
  drier, blue wetter, grey within ±10 mm. MB is the mean bias (mean of satellite − gauge over the
  event's gauges).],
)

#figure(
  image("figures/fig03_event_metrics.png", width: 100%),
  caption: [Draft Fig. 3. Event-scale spatial scores per event and product: (a) spatial correlation, (b) spatial
  CV ratio, (c) rain-centre shift, (d) mean bias, (e) RMSE, (f) CSI at 50 mm. Gauge–pixel pairs over each
  event's common hours. The solid grey line marks the perfect score.],
)

- *Placement.* Mean spatial r over the six events is 0.55 for both GPM and GSMaP, and 0.6–0.8 on four
  events. Both fail on 2022-06-26 (r ≤ 0.12), although each 8 h phase of that day scores r = 0.43–0.88.
- *Amount.* GPM is nearly unbiased (MB −2.0 mm, RMSE 20.5 mm). GSMaP overestimates (MB +18.9 mm,
  RMSE 39.9 mm), up to +73 mm on 2023-08-26.
- *Storm cores.* CSI at 50 mm is 0 for both products except GPM on 2024-07-30. The cores fell as short
  bursts (median peak 25–27 mm h⁻¹, up to 87% of a gauge's total in three hours), which both products
  spread over more hours at about a fifth of the peak rate. On 2023-09-10 no IMERG cell within 50 km
  exceeds 34 mm.

== How errors grow with intensity (P2)
#answers[Both products underestimate more as intensity grows, in every season; detection is not the problem,
peak magnitude is.]

#figure(
  image("figures/fig04a_intensity_season.png", width: 100%),
  caption: [Draft Fig. 4. Hourly skill of GPM and GSMaP over the full 2022–2024 record by gauge intensity
  class (light 0.1–2, moderate 2–4, heavy 4–8, rainstorm 8–20, severe ≥ 20 mm h⁻¹) and season: (a) relative
  bias, (b) fraction detected as rain (satellite ≥ 0.1 mm), (c) fraction in the same intensity class.
  Gauge-wet hours only, all gauges. Whiskers: 95% day-block bootstrap; grey line: perfect score; hollow
  markers: fewer than 100 hours or 30 events. Gauge data are quantised to 0.5 mm, so gauge light hours are
  0.5–1.5 mm and satellite 0.1–0.5 mm cannot be verified. Winter gauge timing may include delayed snowmelt
  tips (the DJF gauge diurnal cycle peaks at midday). The paper version adds the landform-region split.],
)

- *Bias by class.* Pooled over the year, GPM relative bias runs from −11% (light) to −38% (4–8), −68% (8–20)
  and −85% (≥ 20 mm h⁻¹). GSMaP runs from +16% to +8%, −17%, −59% and −80%. At ≥ 8 mm h⁻¹, at most 13% of
  hours land in the right class.
- *Detection and timing (Fig. 5, text).* Rain events peaking at 2–4 mm h⁻¹ or more are detected 88–96% of
  the time, and rain-centre timing errors stay within ±0.5 h. The error is in peak _magnitude_.
- *Season.* Winter (DJF) is where both fail: bias about −80% and only 14–18% of wet hours detected. Summer
  light rain is overestimated (GPM +39%, GSMaP +52%).
- *Landform region.* Between relief below 500 m and 500–1000 m, the class biases differ by at most 8
  percentage points, far less than between classes or seasons. The ≥ 1000 m region has 11 gauges and is not
  interpreted.
- *Areal mean.* Hourly r is 0.83 for GPM and 0.66 for GSMaP (daily: 0.91 and 0.80). The overall bias is +6%
  for GPM and +33% for GSMaP.

== What fusion recovers (P3)
#answers[Fusion beats both inputs; the gain concentrates on heavy hours and grows with distance from the
gauge network.]

#figure(
  image("figures/fig06b_fusion_methods.png", width: 100%),
  caption: [Draft Fig. 6. RMSE improvement of each fusion method over gauge-only ADW, per anchor, for
  all hours and heavy hours. Rows are grouped by how the satellite enters: direct correction, blend with
  ADW, agreement blend. Blue is better, red worse; colour is clipped at ±16%. Hollow cells are not significant:
  their 95% bootstrap interval includes 0, or the Holm-adjusted p ≥ 0.05 across every cell of the panel. The
  paper version adds a panel comparing the gauge-only interpolators.],
)

#figure(
  image("figures/fig07_where_fusion_helps.png", width: 100%),
  caption: [Draft Fig. 7. Where the satellite adds to the gauges, relative to gauge-only ADW (dashed line):
  (a) RMSE change by gauge rain intensity, (b) RMSE change by distance from the held-out gauge to the
  nearest training gauge, (c) CSI change by event threshold.],
)

- *Overall.* With MGWR plus the agreement blend, RMSE falls by 12% from raw GPM and by 30% from raw GSMaP,
  and it beats gauge-only ADW by 2–4%. Every blended variant on GPM and on the merged anchor beats ADW
  significantly, and so do the MGWR-based blends on GSMaP.
- *Heavy hours.* On heavy hours (≥ 8 mm h⁻¹), MGWR alone improves on ADW by 6.0% (GPM) and 7.4% (GSMaP).
  Unblended regression, however, _hurts_ light and dry hours.
- *Distance from the network.* On GPM, the improvement over ADW is 1% within 20 km of a training gauge, 3%
  at 20–50 km and 7% at 50–100 km (GSMaP: 1%, 2%, 4%).

== Best method and anchor (P3)
#answers[ADW is the best gauge-only interpolator, MGWR with a blend is the best fusion, and GPM is the better
anchor.]

Fig. 8 will show raw vs fused skill per anchor and the merge weights.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto, auto),
    align: (left, left, right, right, right, right, right),
    stroke: none,
    rule,
    table.header([*Anchor*], [*Method*], [*RMSE*], [*r*], [*CSI 2.5*], [*vs raw*], [*vs ADW*]),
    thin,
    [—], [ADW (gauges only)], [0.871], [0.486], [0.280], [—], [0.0%],
    [—], [IDW (gauges only)], [0.874], [0.483], [0.279], [—], [−0.3%],
    [—], [TPS (gauges only)], [0.931], [0.437], [0.281], [—], [−6.9%],
    [—], [GWR (gauges only)], [0.922], [0.422], [0.250], [—], [−5.9%],
    thin,
    [GPM], [raw], [0.962], [0.422], [0.253], [0.0%], [−10.4%],
    [GPM], [MGWR + agreement blend], [0.844], [0.528], [0.317], [+12.3%], [+3.1%],
    [GSMaP], [raw], [1.219], [0.369], [0.233], [0.0%], [−40.0%],
    [GSMaP], [MGWR + agreement blend], [0.853], [0.520], [0.313], [+30.1%], [+2.1%],
    [Merged (OLS)], [raw], [0.888], [0.453], [0.220], [0.0%], [−1.4%],
    [Merged (OLS)], [MGWR + agreement blend], [0.844], [0.532], [0.308], [+5.0%], [+3.6%],
    rule,
  ),
  caption: [Draft headline table. Held-out gauges, balanced spatial CV; RMSE in
  mm h⁻¹; improvements are RMSE reductions. Gauge-only rows are on GPM's evaluation mask.],
)

- *Best interpolator.* ADW, with IDW indistinguishable from it (0.871 vs 0.874 mm h⁻¹). TPS and gauge-only
  GWR are 6–7% worse.
- *Best fusion.* MGWR followed by a blend with ADW where the satellite reports rain. MGWR alone is best for
  heavy hours only.
- *Best product.* GPM. It has the lower raw error (RMSE 0.96 vs 1.22 mm h⁻¹), near-zero event bias and a
  better areal-mean timeline. GSMaP's large wet bias is largely removed by fusion, and once fused the two
  anchors differ by only about 1%. IMERG Uncal also beats GSMaP over all 2022–2024 hours (RMSE 0.75 vs
  1.02 mm h⁻¹, r 0.44 vs 0.38), and calibration moves IMERG's r and CSI only in the third decimal.
- *Merging.* The OLS merge is a better raw field than either product (RMSE 0.888). After fusion it adds
  almost nothing over GPM (RMSE 0.844 for both).

= Discussion

== Why satellites miss heavy-rain cores (P1, P2)
- *Short bursts are smeared in time.* Storm cores are short, intense bursts; both products spread them over
  more hours at about a fifth of the peak rate (Section 4.1). This matches P2: detection is good, peak
  magnitude is not (Section 4.2).
- *Pixel averaging is a minor part.* It explains only 16–43% of the core deficit, so the 0.1° grid alone does
  not account for the missed cores.
- *Moving systems.* On 2022-06-26 the rain moved from north to south during the day, so the gauge total is
  nearly flat and much of its variation is at scales below 10 km. Both products overestimate the northern
  convection and underestimate the southern rain that followed; their daily totals keep a north–south
  gradient the gauges do not show. Each phase alone is placed well.
- *Gauge calibration.* GPM's partial success on 2024-07-30 comes from its monthly gauge calibration (×1.7 over
  the uncalibrated estimate). Its lead over GSMaP as an anchor does not, since IMERG Uncal also beats GSMaP
  (Section 4.4).
- *Winter.* The DJF failure (Section 4.2) may partly reflect delayed snowmelt in the gauge record
  #todo[to confirm].

== Why fusion gains grow away from the network (P3)
- A plausible reading #todo[to confirm]: near a training gauge, ADW already carries most of the information; the satellite adds most where the
  nearest gauge is 50–100 km away. This is the sparse-network case the study motivates.
- Regression on the anchor helps heavy hours but hurts light and dry hours, which is why the blend with ADW
  where the satellite reports rain is needed.
- Fusion makes the choice of product matter less: GSMaP's wet bias is largely removed, and the fused anchors
  differ by only about 1%. Merging is worth reporting, but it is not the main source of gain.

== Implications for flood forecasting
Section 4.2 shows that raw satellite rain loses about 60–85% of the volume at 8 mm h⁻¹ and above. That is the
input flood models are most sensitive to, so raw products should not drive them. Fusion recovers part of this
(Figs. 6 and 7), but underestimation at the highest intensities remains. Planned extension (outlook):

+ Aggregate raw, gauge-only and fused hourly fields to basin-mean rainfall for the gauged catchments during
  the six P1 events and the wettest seasons.
+ Correlate basin rainfall (and antecedent totals) with observed hydrological-station discharge, and compare
  raw vs fused.
+ Only if the correlation improves clearly, drive a simple rainfall–runoff model as a demonstration.

*Missing input:* discharge data are not yet available in the project and must be obtained first.

== Limitations
- Gauge data are quantised to 0.5 mm, so satellite rain of 0.1–0.5 mm cannot be verified.
- Winter gauge timing may include delayed snowmelt (the DJF gauge diurnal cycle peaks at midday).
- The ≥ 1000 m relief region has only 11 gauges and is not interpreted.
- The merged anchor still carries a small FY4B term (Section 6).
- The fusion intensity strata differ from the P2 classes (Section 6).
- One study area and three years (2022–2024); transfer to other climates and terrain is untested.

= Conclusions

Planned as one answer per problem, using only the numbers above.

+ *P1.* Both products place heavy rain about equally well (mean spatial r 0.55), but GPM is nearly unbiased
  while GSMaP overestimates, and both miss the cores of localized storms.
+ *P2.* Underestimation grows with intensity in every season, reaching −80% to −85% at ≥ 20 mm h⁻¹;
  events are detected and timed well, so the error is in peak magnitude. Winter is where both fail.
+ *P3.* Fusing gauges with the satellite beats both inputs (RMSE −12% vs raw GPM, −30% vs raw GSMaP, 2–4%
  better than ADW), with the largest gains on heavy hours and far from gauges.
+ *Recommendation.* Use MGWR blended with ADW on a GPM anchor; ADW where no satellite is used. Merging the
  products adds little after fusion.

= Open items before drafting

- Fig. 1: draw the study-area map (relief, gauges, location inset, basins), at the journal width with
  `scripts/joh_style.py`.
- Fig. 7 and the headline table use fusion intensity strata (0.1–2.5, 2.5–8, ≥ 8 mm h⁻¹) that differ from the
  P2 classes. Re-stratify the fusion results on the P2 classes for consistency.
- The merged anchor still carries a small FY4B term (OLS weight 0.03, against 0.40 for GPM and 0.16 for
  GSMaP). It stays for now; refit as a GPM + GSMaP merge before submission.
- Decide whether the newer stacked combination of MGWR and ADW (`stack_mgwr`) replaces the agreement blend
  as the headline fusion method.
- Diurnal-cycle results exist and can go to supplementary material.
- Collect and verify the references for the Introduction and Discussion.
- Journal requirements: abstract and 3–5 highlights #todo[to confirm against the Journal of Hydrology guide].
