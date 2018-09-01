using Gesi.Core.Web.Model;
using Newtonsoft.Json;

namespace Ports.Services.Rules.Model
{
    public class DistanceBetweenPortsModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("inputPortId")]
        public int InputPortId { get; set; }

        [JsonProperty("outPutPortId")]
        public int OutPutPortId { get; set; }

        [JsonProperty("inputName")]
        public string InputName { get; set; }

        [JsonProperty("outPutName")]
        public string OutPutName { get; set; }

        [JsonProperty("interval")]
        public float Interval { get; set; }

        [JsonProperty("hourCanalPanama")]
        public int HourCanalPanama { get; set; }
    }
}