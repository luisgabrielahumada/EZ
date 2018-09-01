using Newtonsoft.Json;
using System;

namespace Bussines.ViewModel
{
    public class RequestView
    {
        [JsonProperty("token")]
        public Guid Token { get; set; } = default(Guid);

        [JsonProperty("productId")]
        public int ProductId { get; set; }

        [JsonProperty("stowageFactorId")]
        public int StowageFactorId { get; set; }

        [JsonProperty("stowageFactor")]
        public float StowageFactor { get; set; }

        [JsonProperty("quantityId")]
        public int QuantityId { get; set; }

        [JsonProperty("quantity")]
        public float Quantity { get; set; }

        [JsonProperty("toleranceId")]
        public int ToleranceId { get; set; }

        [JsonProperty("terms")]
        public int Terms { get; set; }

        [JsonProperty("conditionId")]
        public int ConditionId { get; set; }

        [JsonProperty("loadingConditionId")]
        public int LoadingConditionId { get; set; }

        [JsonProperty("unLoadingConditionId")]
        public int UnLoadingConditionId { get; set; }

        [JsonProperty("loadPortId")]
        public int LoadPortId { get; set; }

        [JsonProperty("loadTerminalId")]
        public int LoadTerminalId { get; set; }

        [JsonProperty("loadingRate")]
        public float LoadingRate { get; set; }

        [JsonProperty("dischargePortId")]
        public int DischargePortId { get; set; }

        [JsonProperty("dischargeTerminalId")]
        public int DischargeTerminalId { get; set; }

        [JsonProperty("unLoadingRate")]
        public float UnLoadingRate { get; set; }

        [JsonProperty("startLaycan")]
        public DateTime StartLaycan { get; set; }

        [JsonProperty("endLaycan")]
        public DateTime EndLaycan { get; set; }

        [JsonProperty("status")]
        public String Status { get; set; }

        [JsonProperty("continue")]
        public bool Continue { get; set; }
    }
}