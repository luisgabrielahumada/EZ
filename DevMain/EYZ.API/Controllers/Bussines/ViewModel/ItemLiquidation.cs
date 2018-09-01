using Newtonsoft.Json;
using System;

namespace Bussines.ViewModel
{
    public class ItemLiquidation
    {
        [JsonProperty("status")]
        public String Status { get; set; }

        [JsonProperty("priceMT")]
        public float PriceMT { get; set; }

        [JsonProperty("rateLoading")]
        public float RateLoading { get; set; }

        [JsonProperty("rateUnLoading")]
        public float RateUnLoading { get; set; }

        [JsonProperty("valueLoadingCondition")]
        public float ValueLoadingCondition { get; set; }

        [JsonProperty("valueUnLoadingCondition")]
        public float ValueUnLoadingCondition { get; set; }


        [JsonProperty("Quantity")]
        public float Quantity { get; set; }

        [JsonProperty("ifoLoadPort")]
        public float IfoLoadPort { get; set; }


        [JsonProperty("mgoLoadPort")]
        public float MgoLoadPort { get; set; }


        [JsonProperty("loadingRate")]
        public float LoadingRate { get; set; }


        [JsonProperty("unLoadingRate")]
        public float UnLoadingRate { get; set; }

        [JsonProperty("vesselIfoConsumed")]
        public float VesselIfoConsumed { get; set; }


        [JsonProperty("vesselMgoConsumed")]
        public float VesselMgoConsumed { get; set; }

        [JsonProperty("vesselSpeed")]
        public float VesselSpeed { get; set; }
    }
}