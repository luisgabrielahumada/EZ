using Gesi.Core.Web.Model;
using Newtonsoft.Json;

namespace Terminals.Services.Rules.Model
{
    public class ProductByTerminalModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("loadingRate")]
        public float LoadingRate { get; set; }

        [JsonProperty("unLoadingRate")]
        public float UnLoadingRate { get; set; }
    }
}