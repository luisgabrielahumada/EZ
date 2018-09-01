using Gesi.Core.Web.Model;
using Newtonsoft.Json;

namespace Contract.Services.Rules.Model
{
    public class NegotiationHistoryModel : BaseModel
    {
        [JsonProperty("observation")]
        public string Observation { get; set; }

        [JsonProperty("oldobservation")]
        public string OldObservation { get; set; }
    }
}