using Gesi.Core.Web.Model;
using Newtonsoft.Json;

namespace Tolerances.Services.Rules.Model
{
    public class ToleranceModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("value")]
        public int Value { get; set; }
    }
}