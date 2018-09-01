using Gesi.Core.Web.Model;
using Newtonsoft.Json;

namespace Contract.Services.Rules.Model
{
    public class NegotiationClauseModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("observation")]
        public string Observation { get; set; }

        [JsonProperty("oldobservation")]
        public string OldObservation { get; set; }

        [JsonProperty("isModify")]
        public bool IsModify { get; set; }

        [JsonProperty("isSelected")]
        public bool IsSelected { get; set; }
    }
}