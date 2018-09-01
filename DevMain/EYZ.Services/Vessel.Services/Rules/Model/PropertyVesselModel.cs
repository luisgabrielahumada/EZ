using Gesi.Core.Web.Model;
using Newtonsoft.Json;

namespace Vessel.Services.Rules.Model
{
    public class PropertyVesselModel : BaseModel
    {
        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("code")]
        public string Code { get; set; }

        [JsonProperty("value")]
        public string Value { get; set; }

        [JsonProperty("vesselId")]
        public int VesselId { get; set; }

        [JsonProperty("propertyVesselId")]
        public int PropertyVesselId { get; set; }

        [JsonProperty("unity")]
        public string Unity { get; set; }
    }
}