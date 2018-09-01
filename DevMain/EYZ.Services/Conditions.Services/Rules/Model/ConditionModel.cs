using Gesi.Core.Web.Model;
using Newtonsoft.Json;

namespace Conditions.Services.Rules.Model
{
    public class ConditionModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("value")]
        public float Value { get; set; }

        [JsonProperty("description")]
        public string Description { get; set; }
    }
}