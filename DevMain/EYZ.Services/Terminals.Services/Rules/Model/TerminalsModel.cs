using Gesi.Core.Web.Model;
using Newtonsoft.Json;
using System.Collections.Generic;

namespace Terminals.Services.Rules.Model
{
    public class TerminalsModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("portId")]
        public int PortId { get; set; }

        [JsonProperty("portName")]
        public string PortName { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("address")]
        public string Address { get; set; }

        [JsonProperty("contants")]
        public string Contants { get; set; }

        [JsonProperty("phone")]
        public string Phone { get; set; }

        [JsonProperty("cityId")]
        public int CityId { get; set; }

        [JsonProperty("cityName")]
        public string CityName { get; set; }

        [JsonProperty("xaxis")]
        public string Xaxis { get; set; }

        [JsonProperty("yaxis")]
        public string Yaxis { get; set; }

        [JsonProperty("email")]
        public string Email { get; set; }

        [JsonProperty("unLoadingRate")]
        public float UnLoadingRate { get; set; }

        [JsonProperty("loadingRate")]
        public float LoadingRate { get; set; }

        [JsonProperty("conditionId")]
        public int ConditionId { get; set; }

        [JsonProperty("conditionName")]
        public string ConditionName { get; set; }

        [JsonProperty("conditionValue")]
        public float ConditionValue { get; set; }

        [JsonProperty("products")]
        public List<ProductByTerminalModel> Products { get; set; }

        [JsonProperty("rank")]
        public List<RankRate> RankRate { get; set; }
    }
}