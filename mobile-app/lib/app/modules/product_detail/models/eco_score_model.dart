class EcoScoreModel {
  final bool? ok;
  final String? productId;
  final InputUsed? inputUsed;
  final Saved? saved;

  EcoScoreModel({this.ok, this.productId, this.inputUsed, this.saved});

  factory EcoScoreModel.fromJson(Map<String, dynamic> json) => EcoScoreModel(
    ok: json["ok"],
    productId: json["product_id"],
    inputUsed: json["input_used"] == null
        ? null
        : InputUsed.fromJson(json["input_used"]),
    saved: json["saved"] == null ? null : Saved.fromJson(json["saved"]),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "product_id": productId,
    "input_used": inputUsed?.toJson(),
    "saved": saved?.toJson(),
  };
}

class InputUsed {
  final TshirtChain? tshirtChain;
  final Assumptions? assumptions;

  InputUsed({this.tshirtChain, this.assumptions});

  factory InputUsed.fromJson(Map<String, dynamic> json) => InputUsed(
    tshirtChain: json["tshirt_chain"] == null
        ? null
        : TshirtChain.fromJson(json["tshirt_chain"]),
    assumptions: json["assumptions"] == null
        ? null
        : Assumptions.fromJson(json["assumptions"]),
  );

  Map<String, dynamic> toJson() => {
    "tshirt_chain": tshirtChain?.toJson(),
    "assumptions": assumptions?.toJson(),
  };
}

class Assumptions {
  final double? pSell;
  final double? rHat;
  final int? resaleDistanceKm;

  Assumptions({this.pSell, this.rHat, this.resaleDistanceKm});

  factory Assumptions.fromJson(Map<String, dynamic> json) => Assumptions(
    pSell: json["p_sell"]?.toDouble(),
    rHat: json["r_hat"]?.toDouble(),
    resaleDistanceKm: json["resale_distance_km"],
  );

  Map<String, dynamic> toJson() => {
    "p_sell": pSell,
    "r_hat": rHat,
    "resale_distance_km": resaleDistanceKm,
  };
}

class TshirtChain {
  final int? massG;
  final Composition? composition;
  final String? countryOfOrigin;
  final String? marketRegion;
  final String? colorDepth;

  TshirtChain({
    this.massG,
    this.composition,
    this.countryOfOrigin,
    this.marketRegion,
    this.colorDepth,
  });

  factory TshirtChain.fromJson(Map<String, dynamic> json) => TshirtChain(
    massG: json["mass_g"],
    composition: json["composition"] == null
        ? null
        : Composition.fromJson(json["composition"]),
    countryOfOrigin: json["country_of_origin"],
    marketRegion: json["market_region"],
    colorDepth: json["color_depth"],
  );

  Map<String, dynamic> toJson() => {
    "mass_g": massG,
    "composition": composition?.toJson(),
    "country_of_origin": countryOfOrigin,
    "market_region": marketRegion,
    "color_depth": colorDepth,
  };
}

class Composition {
  final int? cotton;

  Composition({this.cotton});

  factory Composition.fromJson(Map<String, dynamic> json) =>
      Composition(cotton: json["cotton"]);

  Map<String, dynamic> toJson() => {"cotton": cotton};
}

class Saved {
  final String? version;
  final String? unit;
  final UserFacing? userFacing;
  final ProxyQuantities? proxyQuantities;
  final ProvenanceLite? provenanceLite;

  Saved({
    this.version,
    this.unit,
    this.userFacing,
    this.proxyQuantities,
    this.provenanceLite,
  });

  factory Saved.fromJson(Map<String, dynamic> json) => Saved(
    version: json["version"],
    unit: json["unit"],
    userFacing: json["user_facing"] == null
        ? null
        : UserFacing.fromJson(json["user_facing"]),
    proxyQuantities: json["proxy_quantities"] == null
        ? null
        : ProxyQuantities.fromJson(json["proxy_quantities"]),
    provenanceLite: json["provenance_lite"] == null
        ? null
        : ProvenanceLite.fromJson(json["provenance_lite"]),
  );

  Map<String, dynamic> toJson() => {
    "version": version,
    "unit": unit,
    "user_facing": userFacing?.toJson(),
    "proxy_quantities": proxyQuantities?.toJson(),
    "provenance_lite": provenanceLite?.toJson(),
  };
}

class ProvenanceLite {
  final String? countryOfOrigin;
  final String? marketRegion;
  final String? resolvedRegion;
  final String? colorDepth;
  final Assumptions? assumptionsUsed;
  final Traceability? traceability;
  final StageBreakdown? stageBreakdown;
  final ClimateProxy? climateProxy;

  ProvenanceLite({
    this.countryOfOrigin,
    this.marketRegion,
    this.resolvedRegion,
    this.colorDepth,
    this.assumptionsUsed,
    this.traceability,
    this.stageBreakdown,
    this.climateProxy,
  });

  factory ProvenanceLite.fromJson(Map<String, dynamic> json) => ProvenanceLite(
    countryOfOrigin: json["country_of_origin"],
    marketRegion: json["market_region"],
    resolvedRegion: json["resolved_region"],
    colorDepth: json["color_depth"],
    assumptionsUsed: json["assumptions_used"] == null
        ? null
        : Assumptions.fromJson(json["assumptions_used"]),
    traceability: json["traceability"] == null
        ? null
        : Traceability.fromJson(json["traceability"]),
    stageBreakdown: json["stage_breakdown"] == null
        ? null
        : StageBreakdown.fromJson(json["stage_breakdown"]),
    climateProxy: json["climate_proxy"] == null
        ? null
        : ClimateProxy.fromJson(json["climate_proxy"]),
  );

  Map<String, dynamic> toJson() => {
    "country_of_origin": countryOfOrigin,
    "market_region": marketRegion,
    "resolved_region": resolvedRegion,
    "color_depth": colorDepth,
    "assumptions_used": assumptionsUsed?.toJson(),
    "traceability": traceability?.toJson(),
    "stage_breakdown": stageBreakdown?.toJson(),
    "climate_proxy": climateProxy?.toJson(),
  };
}

class ClimateProxy {
  final String? version;
  final String? unit;
  final String? methodNote;
  final Inputs? inputs;
  final StageSharesPct? byStageKgco2;
  final double? totalOpsKgco2;
  final StageSharesPct? sharesPercent;
  final Savings? savings;

  ClimateProxy({
    this.version,
    this.unit,
    this.methodNote,
    this.inputs,
    this.byStageKgco2,
    this.totalOpsKgco2,
    this.sharesPercent,
    this.savings,
  });

  factory ClimateProxy.fromJson(Map<String, dynamic> json) => ClimateProxy(
    version: json["version"],
    unit: json["unit"],
    methodNote: json["method_note"],
    inputs: json["inputs"] == null ? null : Inputs.fromJson(json["inputs"]),
    byStageKgco2: json["by_stage_kgco2"] == null
        ? null
        : StageSharesPct.fromJson(json["by_stage_kgco2"]),
    totalOpsKgco2: json["total_ops_kgco2"]?.toDouble(),
    sharesPercent: json["shares_percent"] == null
        ? null
        : StageSharesPct.fromJson(json["shares_percent"]),
    savings: json["savings"] == null ? null : Savings.fromJson(json["savings"]),
  );

  Map<String, dynamic> toJson() => {
    "version": version,
    "unit": unit,
    "method_note": methodNote,
    "inputs": inputs?.toJson(),
    "by_stage_kgco2": byStageKgco2?.toJson(),
    "total_ops_kgco2": totalOpsKgco2,
    "shares_percent": sharesPercent?.toJson(),
    "savings": savings?.toJson(),
  };
}

class StageSharesPct {
  final double? fibreProduction;
  final double? baselineManufacturing;
  final double? dyeingFinishing;
  final double? transportTotal;

  StageSharesPct({
    this.fibreProduction,
    this.baselineManufacturing,
    this.dyeingFinishing,
    this.transportTotal,
  });

  factory StageSharesPct.fromJson(Map<String, dynamic> json) => StageSharesPct(
    fibreProduction: json["fibre_production"]?.toDouble(),
    baselineManufacturing: json["baseline_manufacturing"]?.toDouble(),
    dyeingFinishing: json["dyeing_finishing"]?.toDouble(),
    transportTotal: json["transport_total"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "fibre_production": fibreProduction,
    "baseline_manufacturing": baselineManufacturing,
    "dyeing_finishing": dyeingFinishing,
    "transport_total": transportTotal,
  };
}

class Inputs {
  final double? heatKgco2PerMj;
  final bool? heatUsedLcia;
  final double? heatLciaScoreRaw;
  final double? transportKgco2PerTkm;
  final bool? electricityLciaAbs;
  final bool? electricityLciaEnabledAndOk;
  final double? electricityLciaScoreRaw;
  final double? electricityLciaMinAbs;
  final int? electricityFallbackKgco2PerKwh;
  final bool? electricityUsedFallback;
  final dynamic electricityFallbackReason;

  Inputs({
    this.heatKgco2PerMj,
    this.heatUsedLcia,
    this.heatLciaScoreRaw,
    this.transportKgco2PerTkm,
    this.electricityLciaAbs,
    this.electricityLciaEnabledAndOk,
    this.electricityLciaScoreRaw,
    this.electricityLciaMinAbs,
    this.electricityFallbackKgco2PerKwh,
    this.electricityUsedFallback,
    this.electricityFallbackReason,
  });

  factory Inputs.fromJson(Map<String, dynamic> json) => Inputs(
    heatKgco2PerMj: json["heat_kgco2_per_mj"]?.toDouble(),
    heatUsedLcia: json["heat_used_lcia"],
    heatLciaScoreRaw: json["heat_lcia_score_raw"]?.toDouble(),
    transportKgco2PerTkm: json["transport_kgco2_per_tkm"]?.toDouble(),
    electricityLciaAbs: json["electricity_lcia_abs"],
    electricityLciaEnabledAndOk: json["electricity_lcia_enabled_and_ok"],
    electricityLciaScoreRaw: json["electricity_lcia_score_raw"]?.toDouble(),
    electricityLciaMinAbs: json["electricity_lcia_min_abs"]?.toDouble(),
    electricityFallbackKgco2PerKwh: json["electricity_fallback_kgco2_per_kwh"],
    electricityUsedFallback: json["electricity_used_fallback"],
    electricityFallbackReason: json["electricity_fallback_reason"],
  );

  Map<String, dynamic> toJson() => {
    "heat_kgco2_per_mj": heatKgco2PerMj,
    "heat_used_lcia": heatUsedLcia,
    "heat_lcia_score_raw": heatLciaScoreRaw,
    "transport_kgco2_per_tkm": transportKgco2PerTkm,
    "electricity_lcia_abs": electricityLciaAbs,
    "electricity_lcia_enabled_and_ok": electricityLciaEnabledAndOk,
    "electricity_lcia_score_raw": electricityLciaScoreRaw,
    "electricity_lcia_min_abs": electricityLciaMinAbs,
    "electricity_fallback_kgco2_per_kwh": electricityFallbackKgco2PerKwh,
    "electricity_used_fallback": electricityUsedFallback,
    "electricity_fallback_reason": electricityFallbackReason,
  };
}

class Savings {
  final double? pSellUsed;
  final double? rHatUsed;
  final double? newProductionKgco2;
  final double? savedKgco2;
  final double? netKgco2;
  final double? percentSavedVsNew;

  Savings({
    this.pSellUsed,
    this.rHatUsed,
    this.newProductionKgco2,
    this.savedKgco2,
    this.netKgco2,
    this.percentSavedVsNew,
  });

  factory Savings.fromJson(Map<String, dynamic> json) => Savings(
    pSellUsed: json["p_sell_used"]?.toDouble(),
    rHatUsed: json["r_hat_used"]?.toDouble(),
    newProductionKgco2: json["new_production_kgco2"]?.toDouble(),
    savedKgco2: json["saved_kgco2"]?.toDouble(),
    netKgco2: json["net_kgco2"]?.toDouble(),
    percentSavedVsNew: json["percent_saved_vs_new"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "p_sell_used": pSellUsed,
    "r_hat_used": rHatUsed,
    "new_production_kgco2": newProductionKgco2,
    "saved_kgco2": savedKgco2,
    "net_kgco2": netKgco2,
    "percent_saved_vs_new": percentSavedVsNew,
  };
}

class StageBreakdown {
  final BaselineManufacturing? baselineManufacturing;
  final DyeingFinishing? dyeingFinishing;
  final Transport? transport;
  final String? resolvedRegion;
  final String? countryOfOrigin;
  final double? garmentMassKg;
  final Composition? compositionWeights;

  StageBreakdown({
    this.baselineManufacturing,
    this.dyeingFinishing,
    this.transport,
    this.resolvedRegion,
    this.countryOfOrigin,
    this.garmentMassKg,
    this.compositionWeights,
  });

  factory StageBreakdown.fromJson(Map<String, dynamic> json) => StageBreakdown(
    baselineManufacturing: json["baseline_manufacturing"] == null
        ? null
        : BaselineManufacturing.fromJson(json["baseline_manufacturing"]),
    dyeingFinishing: json["dyeing_finishing"] == null
        ? null
        : DyeingFinishing.fromJson(json["dyeing_finishing"]),
    transport: json["transport"] == null
        ? null
        : Transport.fromJson(json["transport"]),
    resolvedRegion: json["resolved_region"],
    countryOfOrigin: json["country_of_origin"],
    garmentMassKg: json["garment_mass_kg"]?.toDouble(),
    compositionWeights: json["composition_weights"] == null
        ? null
        : Composition.fromJson(json["composition_weights"]),
  );

  Map<String, dynamic> toJson() => {
    "baseline_manufacturing": baselineManufacturing?.toJson(),
    "dyeing_finishing": dyeingFinishing?.toJson(),
    "transport": transport?.toJson(),
    "resolved_region": resolvedRegion,
    "country_of_origin": countryOfOrigin,
    "garment_mass_kg": garmentMassKg,
    "composition_weights": compositionWeights?.toJson(),
  };
}

class BaselineManufacturing {
  final double? baseElecKWh;
  final int? baseHeatMj;
  final int? baseWaterM3;

  BaselineManufacturing({this.baseElecKWh, this.baseHeatMj, this.baseWaterM3});

  factory BaselineManufacturing.fromJson(Map<String, dynamic> json) =>
      BaselineManufacturing(
        baseElecKWh: json["base_elec_kWh"]?.toDouble(),
        baseHeatMj: json["base_heat_MJ"],
        baseWaterM3: json["base_water_m3"],
      );

  Map<String, dynamic> toJson() => {
    "base_elec_kWh": baseElecKWh,
    "base_heat_MJ": baseHeatMj,
    "base_water_m3": baseWaterM3,
  };
}

class DyeingFinishing {
  final double? dyeingWaterM3;
  final double? dyeingHeatMj;
  final double? dyeingElecKWh;

  DyeingFinishing({this.dyeingWaterM3, this.dyeingHeatMj, this.dyeingElecKWh});

  factory DyeingFinishing.fromJson(Map<String, dynamic> json) =>
      DyeingFinishing(
        dyeingWaterM3: json["dyeing_water_m3"]?.toDouble(),
        dyeingHeatMj: json["dyeing_heat_MJ"]?.toDouble(),
        dyeingElecKWh: json["dyeing_elec_kWh"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "dyeing_water_m3": dyeingWaterM3,
    "dyeing_heat_MJ": dyeingHeatMj,
    "dyeing_elec_kWh": dyeingElecKWh,
  };
}

class Transport {
  final int? resaleDistanceKm;
  final double? transportTkmResale;
  final int? transportTkmUpstream;
  final double? upstreamCo2Kg;
  final String? upstreamTransportType;
  final int? upstreamDistanceKm;
  final int? truckKm1;
  final int? seaKm;
  final int? truckKm2;
  final int? totalKm;

  Transport({
    this.resaleDistanceKm,
    this.transportTkmResale,
    this.transportTkmUpstream,
    this.upstreamCo2Kg,
    this.upstreamTransportType,
    this.upstreamDistanceKm,
    this.truckKm1,
    this.seaKm,
    this.truckKm2,
    this.totalKm,
  });

  factory Transport.fromJson(Map<String, dynamic> json) => Transport(
    resaleDistanceKm: json["resale_distance_km"],
    transportTkmResale: json["transport_tkm_resale"]?.toDouble(),
    transportTkmUpstream: json["transport_tkm_upstream"],
    upstreamCo2Kg: json["upstream_co2_kg"]?.toDouble(),
    upstreamTransportType: json["upstream_transport_type"],
    upstreamDistanceKm: json["upstream_distance_km"],
    truckKm1: json["truck_km_1"],
    seaKm: json["sea_km"],
    truckKm2: json["truck_km_2"],
    totalKm: json["total_km"],
  );

  Map<String, dynamic> toJson() => {
    "resale_distance_km": resaleDistanceKm,
    "transport_tkm_resale": transportTkmResale,
    "transport_tkm_upstream": transportTkmUpstream,
    "upstream_co2_kg": upstreamCo2Kg,
    "upstream_transport_type": upstreamTransportType,
    "upstream_distance_km": upstreamDistanceKm,
    "truck_km_1": truckKm1,
    "sea_km": seaKm,
    "truck_km_2": truckKm2,
    "total_km": totalKm,
  };
}

class Traceability {
  final Engine? engine;
  final InputsUsed? inputsUsed;
  final Assumptions? assumptionsUsed;
  final LcaDebug? lcaDebug;
  final EcoinventElectricity? ecoinventElectricity;
  final UpstreamTransportMeta? upstreamTransportMeta;

  Traceability({
    this.engine,
    this.inputsUsed,
    this.assumptionsUsed,
    this.lcaDebug,
    this.ecoinventElectricity,
    this.upstreamTransportMeta,
  });

  factory Traceability.fromJson(Map<String, dynamic> json) => Traceability(
    engine: json["engine"] == null ? null : Engine.fromJson(json["engine"]),
    inputsUsed: json["inputs_used"] == null
        ? null
        : InputsUsed.fromJson(json["inputs_used"]),
    assumptionsUsed: json["assumptions_used"] == null
        ? null
        : Assumptions.fromJson(json["assumptions_used"]),
    lcaDebug: json["lca_debug"] == null
        ? null
        : LcaDebug.fromJson(json["lca_debug"]),
    ecoinventElectricity: json["ecoinvent_electricity"] == null
        ? null
        : EcoinventElectricity.fromJson(json["ecoinvent_electricity"]),
    upstreamTransportMeta: json["upstream_transport_meta"] == null
        ? null
        : UpstreamTransportMeta.fromJson(json["upstream_transport_meta"]),
  );

  Map<String, dynamic> toJson() => {
    "engine": engine?.toJson(),
    "inputs_used": inputsUsed?.toJson(),
    "assumptions_used": assumptionsUsed?.toJson(),
    "lca_debug": lcaDebug?.toJson(),
    "ecoinvent_electricity": ecoinventElectricity?.toJson(),
    "upstream_transport_meta": upstreamTransportMeta?.toJson(),
  };
}

class EcoinventElectricity {
  final bool? enabled;
  final double? electricityKWh;
  final String? db;
  final List<String>? method;
  final String? inferredLocation;
  final int? locationMatchTier;
  final List<DebugRankedCandidatesTop>? debugRankedCandidatesTop;
  final String? activityName;
  final String? activityLocation;
  final List<String>? activityKey;
  final String? solver;
  final double? lciaScore;

  EcoinventElectricity({
    this.enabled,
    this.electricityKWh,
    this.db,
    this.method,
    this.inferredLocation,
    this.locationMatchTier,
    this.debugRankedCandidatesTop,
    this.activityName,
    this.activityLocation,
    this.activityKey,
    this.solver,
    this.lciaScore,
  });

  factory EcoinventElectricity.fromJson(Map<String, dynamic> json) =>
      EcoinventElectricity(
        enabled: json["enabled"],
        electricityKWh: json["electricity_kWh"]?.toDouble(),
        db: json["db"],
        method: json["method"] == null
            ? []
            : List<String>.from(json["method"]!.map((x) => x)),
        inferredLocation: json["inferred_location"],
        locationMatchTier: json["location_match_tier"],
        debugRankedCandidatesTop: json["debug_ranked_candidates_top"] == null
            ? []
            : List<DebugRankedCandidatesTop>.from(
                json["debug_ranked_candidates_top"]!.map(
                  (x) => DebugRankedCandidatesTop.fromJson(x),
                ),
              ),
        activityName: json["activity_name"],
        activityLocation: json["activity_location"],
        activityKey: json["activity_key"] == null
            ? []
            : List<String>.from(json["activity_key"]!.map((x) => x)),
        solver: json["solver"],
        lciaScore: json["lcia_score"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "enabled": enabled,
    "electricity_kWh": electricityKWh,
    "db": db,
    "method": method == null ? [] : List<dynamic>.from(method!.map((x) => x)),
    "inferred_location": inferredLocation,
    "location_match_tier": locationMatchTier,
    "debug_ranked_candidates_top": debugRankedCandidatesTop == null
        ? []
        : List<dynamic>.from(debugRankedCandidatesTop!.map((x) => x.toJson())),
    "activity_name": activityName,
    "activity_location": activityLocation,
    "activity_key": activityKey == null
        ? []
        : List<dynamic>.from(activityKey!.map((x) => x)),
    "solver": solver,
    "lcia_score": lciaScore,
  };
}

class DebugRankedCandidatesTop {
  final int? bucket;
  final int? nameBonus;
  final String? location;
  final String? name;
  final List<String>? key;
  final String? lookup;

  DebugRankedCandidatesTop({
    this.bucket,
    this.nameBonus,
    this.location,
    this.name,
    this.key,
    this.lookup,
  });

  factory DebugRankedCandidatesTop.fromJson(Map<String, dynamic> json) =>
      DebugRankedCandidatesTop(
        bucket: json["bucket"],
        nameBonus: json["name_bonus"],
        location: json["location"],
        name: json["name"],
        key: json["key"] == null
            ? []
            : List<String>.from(json["key"]!.map((x) => x)),
        lookup: json["lookup"],
      );

  Map<String, dynamic> toJson() => {
    "bucket": bucket,
    "name_bonus": nameBonus,
    "location": location,
    "name": name,
    "key": key == null ? [] : List<dynamic>.from(key!.map((x) => x)),
    "lookup": lookup,
  };
}

class Engine {
  final String? mode;
  final String? lciaType;

  Engine({this.mode, this.lciaType});

  factory Engine.fromJson(Map<String, dynamic> json) =>
      Engine(mode: json["mode"], lciaType: json["lcia_type"]);

  Map<String, dynamic> toJson() => {"mode": mode, "lcia_type": lciaType};
}

class InputsUsed {
  final double? garmentMassKgUsed;
  final String? countryOfOrigin;
  final String? marketRegion;
  final String? resolvedRegion;
  final int? gridKgco2PerKwhUsed;
  final RegionalisationMeta? regionalisationMeta;
  final String? colorDepthInput;
  final double? cuttingWasteRateDefault;
  final int? resaleDistanceKmUsed;
  final double? resaleTkm;
  final int? upstreamTkm;
  final String? dyeingColorDepthBucket;
  final int? dyeingCellulosicShare;
  final int? dyeingSyntheticShare;
  final int? dyeingWaterFactor;
  final int? dyeingEnergyFactor;
  final bool? fibreParseFallbackUsed;
  final dynamic fibreParseFallbackGroup;

  InputsUsed({
    this.garmentMassKgUsed,
    this.countryOfOrigin,
    this.marketRegion,
    this.resolvedRegion,
    this.gridKgco2PerKwhUsed,
    this.regionalisationMeta,
    this.colorDepthInput,
    this.cuttingWasteRateDefault,
    this.resaleDistanceKmUsed,
    this.resaleTkm,
    this.upstreamTkm,
    this.dyeingColorDepthBucket,
    this.dyeingCellulosicShare,
    this.dyeingSyntheticShare,
    this.dyeingWaterFactor,
    this.dyeingEnergyFactor,
    this.fibreParseFallbackUsed,
    this.fibreParseFallbackGroup,
  });

  factory InputsUsed.fromJson(Map<String, dynamic> json) => InputsUsed(
    garmentMassKgUsed: json["garment_mass_kg_used"]?.toDouble(),
    countryOfOrigin: json["country_of_origin"],
    marketRegion: json["market_region"],
    resolvedRegion: json["resolved_region"],
    gridKgco2PerKwhUsed: json["grid_kgco2_per_kwh_used"],
    regionalisationMeta: json["regionalisation_meta"] == null
        ? null
        : RegionalisationMeta.fromJson(json["regionalisation_meta"]),
    colorDepthInput: json["color_depth_input"],
    cuttingWasteRateDefault: json["cutting_waste_rate_default"]?.toDouble(),
    resaleDistanceKmUsed: json["resale_distance_km_used"],
    resaleTkm: json["resale_tkm"]?.toDouble(),
    upstreamTkm: json["upstream_tkm"],
    dyeingColorDepthBucket: json["dyeing_color_depth_bucket"],
    dyeingCellulosicShare: json["dyeing_cellulosic_share"],
    dyeingSyntheticShare: json["dyeing_synthetic_share"],
    dyeingWaterFactor: json["dyeing_water_factor"],
    dyeingEnergyFactor: json["dyeing_energy_factor"],
    fibreParseFallbackUsed: json["fibre_parse_fallback_used"],
    fibreParseFallbackGroup: json["fibre_parse_fallback_group"],
  );

  Map<String, dynamic> toJson() => {
    "garment_mass_kg_used": garmentMassKgUsed,
    "country_of_origin": countryOfOrigin,
    "market_region": marketRegion,
    "resolved_region": resolvedRegion,
    "grid_kgco2_per_kwh_used": gridKgco2PerKwhUsed,
    "regionalisation_meta": regionalisationMeta?.toJson(),
    "color_depth_input": colorDepthInput,
    "cutting_waste_rate_default": cuttingWasteRateDefault,
    "resale_distance_km_used": resaleDistanceKmUsed,
    "resale_tkm": resaleTkm,
    "upstream_tkm": upstreamTkm,
    "dyeing_color_depth_bucket": dyeingColorDepthBucket,
    "dyeing_cellulosic_share": dyeingCellulosicShare,
    "dyeing_synthetic_share": dyeingSyntheticShare,
    "dyeing_water_factor": dyeingWaterFactor,
    "dyeing_energy_factor": dyeingEnergyFactor,
    "fibre_parse_fallback_used": fibreParseFallbackUsed,
    "fibre_parse_fallback_group": fibreParseFallbackGroup,
  };
}

class RegionalisationMeta {
  final String? countryInput;
  final String? region;
  final String? regionMappingSource;
  final String? gridIntensitySource;
  final int? gridIntensityValue;

  RegionalisationMeta({
    this.countryInput,
    this.region,
    this.regionMappingSource,
    this.gridIntensitySource,
    this.gridIntensityValue,
  });

  factory RegionalisationMeta.fromJson(Map<String, dynamic> json) =>
      RegionalisationMeta(
        countryInput: json["country_input"],
        region: json["region"],
        regionMappingSource: json["region_mapping_source"],
        gridIntensitySource: json["grid_intensity_source"],
        gridIntensityValue: json["grid_intensity_value"],
      );

  Map<String, dynamic> toJson() => {
    "country_input": countryInput,
    "region": region,
    "region_mapping_source": regionMappingSource,
    "grid_intensity_source": gridIntensitySource,
    "grid_intensity_value": gridIntensityValue,
  };
}

class LcaDebug {
  final String? bwProject;
  final List<String>? fuKey;
  final List<String>? method;
  final double? lciaScore;
  final String? solver;

  LcaDebug({
    this.bwProject,
    this.fuKey,
    this.method,
    this.lciaScore,
    this.solver,
  });

  factory LcaDebug.fromJson(Map<String, dynamic> json) => LcaDebug(
    bwProject: json["bw_project"],
    fuKey: json["fu_key"] == null
        ? []
        : List<String>.from(json["fu_key"]!.map((x) => x)),
    method: json["method"] == null
        ? []
        : List<String>.from(json["method"]!.map((x) => x)),
    lciaScore: json["lcia_score"]?.toDouble(),
    solver: json["solver"],
  );

  Map<String, dynamic> toJson() => {
    "bw_project": bwProject,
    "fu_key": fuKey == null ? [] : List<dynamic>.from(fuKey!.map((x) => x)),
    "method": method == null ? [] : List<dynamic>.from(method!.map((x) => x)),
    "lcia_score": lciaScore,
    "solver": solver,
  };
}

class UpstreamTransportMeta {
  final int? truckKm;
  final int? seaKm;
  final int? totalKm;
  final double? truckTkm;
  final int? seaTkm;
  final double? truckEfKgco2PerTkm;
  final double? seaEfKgco2PerTkm;
  final double? truckCo2Kg;
  final double? seaCo2Kg;
  final double? totalCo2Kg;
  final String? source;

  UpstreamTransportMeta({
    this.truckKm,
    this.seaKm,
    this.totalKm,
    this.truckTkm,
    this.seaTkm,
    this.truckEfKgco2PerTkm,
    this.seaEfKgco2PerTkm,
    this.truckCo2Kg,
    this.seaCo2Kg,
    this.totalCo2Kg,
    this.source,
  });

  factory UpstreamTransportMeta.fromJson(Map<String, dynamic> json) =>
      UpstreamTransportMeta(
        truckKm: json["truck_km"],
        seaKm: json["sea_km"],
        totalKm: json["total_km"],
        truckTkm: json["truck_tkm"]?.toDouble(),
        seaTkm: json["sea_tkm"],
        truckEfKgco2PerTkm: json["truck_ef_kgco2_per_tkm"]?.toDouble(),
        seaEfKgco2PerTkm: json["sea_ef_kgco2_per_tkm"]?.toDouble(),
        truckCo2Kg: json["truck_co2_kg"]?.toDouble(),
        seaCo2Kg: json["sea_co2_kg"]?.toDouble(),
        totalCo2Kg: json["total_co2_kg"]?.toDouble(),
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
    "truck_km": truckKm,
    "sea_km": seaKm,
    "total_km": totalKm,
    "truck_tkm": truckTkm,
    "sea_tkm": seaTkm,
    "truck_ef_kgco2_per_tkm": truckEfKgco2PerTkm,
    "sea_ef_kgco2_per_tkm": seaEfKgco2PerTkm,
    "truck_co2_kg": truckCo2Kg,
    "sea_co2_kg": seaCo2Kg,
    "total_co2_kg": totalCo2Kg,
    "source": source,
  };
}

class ProxyQuantities {
  final double? electricityKWh;
  final double? heatMj;
  final double? waterM3;
  final double? transportTkm;
  final double? transportTkmResale;
  final int? transportTkmUpstream;
  final double? upstreamCo2Kg;

  ProxyQuantities({
    this.electricityKWh,
    this.heatMj,
    this.waterM3,
    this.transportTkm,
    this.transportTkmResale,
    this.transportTkmUpstream,
    this.upstreamCo2Kg,
  });

  factory ProxyQuantities.fromJson(Map<String, dynamic> json) =>
      ProxyQuantities(
        electricityKWh: json["electricity_kWh"]?.toDouble(),
        heatMj: json["heat_MJ"]?.toDouble(),
        waterM3: json["water_m3"]?.toDouble(),
        transportTkm: json["transport_tkm"]?.toDouble(),
        transportTkmResale: json["transport_tkm_resale"]?.toDouble(),
        transportTkmUpstream: json["transport_tkm_upstream"],
        upstreamCo2Kg: json["upstream_co2_kg"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "electricity_kWh": electricityKWh,
    "heat_MJ": heatMj,
    "water_m3": waterM3,
    "transport_tkm": transportTkm,
    "transport_tkm_resale": transportTkmResale,
    "transport_tkm_upstream": transportTkmUpstream,
    "upstream_co2_kg": upstreamCo2Kg,
  };
}

class UserFacing {
  final String? version;
  final String? unit;
  final String? headline;
  final int? co2SavedPct;
  final double? co2SavedKg;
  final double? co2NetKg;
  final double? co2NewKg;
  final double? co2OpsKg;
  final StageSharesPct? stageSharesPct;
  final String? note;

  UserFacing({
    this.version,
    this.unit,
    this.headline,
    this.co2SavedPct,
    this.co2SavedKg,
    this.co2NetKg,
    this.co2NewKg,
    this.co2OpsKg,
    this.stageSharesPct,
    this.note,
  });

  factory UserFacing.fromJson(Map<String, dynamic> json) => UserFacing(
    version: json["version"],
    unit: json["unit"],
    headline: json["headline"],
    co2SavedPct: json["co2_saved_pct"],
    co2SavedKg: json["co2_saved_kg"]?.toDouble(),
    co2NetKg: json["co2_net_kg"]?.toDouble(),
    co2NewKg: json["co2_new_kg"]?.toDouble(),
    co2OpsKg: json["co2_ops_kg"]?.toDouble(),
    stageSharesPct: json["stage_shares_pct"] == null
        ? null
        : StageSharesPct.fromJson(json["stage_shares_pct"]),
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "version": version,
    "unit": unit,
    "headline": headline,
    "co2_saved_pct": co2SavedPct,
    "co2_saved_kg": co2SavedKg,
    "co2_net_kg": co2NetKg,
    "co2_new_kg": co2NewKg,
    "co2_ops_kg": co2OpsKg,
    "stage_shares_pct": stageSharesPct?.toJson(),
    "note": note,
  };
}
